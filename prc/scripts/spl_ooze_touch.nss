#include "X0_I0_SPELLS"
#include "prc_alterations"
#include "x2_inc_spellhook"

/* Fungus touch */
void ooze_touch_fungus()
{
    object oTarget = GetSpellTargetObject();
    int nDuration;

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CIGetIsCraftFeatBaseItem(oTarget))
    {
        // Do not allow casting on not equippable items
        if (!IPGetIsItemEquipable(oTarget))
        {
         // Item must be equipable...
             FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
            return;
        }

        itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_PURPLE);

        if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
        {
            IPRemoveMatchingItemProperties(oTarget,ITEM_PROPERTY_LIGHT,DURATION_TYPE_TEMPORARY);
        }

        nDuration = GetLevelByClass(CLASS_TYPE_OOZEMASTER);

        AddItemProperty(DURATION_TYPE_TEMPORARY,ip,oTarget,HoursToSeconds(nDuration));
    }
    else
    {
        effect eVis = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eDur);

        nDuration = GetLevelByClass(CLASS_TYPE_OOZEMASTER);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
    }
}

int ooze_touch_damage(effect eDamage)
{
    object oTarget = GetSpellTargetObject();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Make a touch attack to afflict target

       // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
        if (TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID)>0)
        {
            effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            return TRUE;
        }
    }
    return FALSE;
}
int ooze_touch_effect(effect eDamage, int time)
{
    object oTarget = GetSpellTargetObject();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Make a touch attack to afflict target

       // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
        if (TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID)>0)
        {
            effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oTarget, RoundsToSeconds(time));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            return TRUE;
        }
    }
    return FALSE;
}

void main()
{
    object target = GetSpellTargetObject();
    int level = GetLevelByClass(CLASS_TYPE_OOZEMASTER);

    switch (GetSpellId())
    {
        /* Brown Mold */
        case 2010:
        {
            ooze_touch_damage(EffectDamage(d6() + level, DAMAGE_TYPE_COLD));
            break;
        }
        /* Gray ooze */
        case 2011:
        {
            ooze_touch_damage(EffectDamage(d6() + level, DAMAGE_TYPE_ACID));
            break;
        }
        /* Ochre Jelly */
        case 2012:
        {
            effect damage = EffectDamage(d4() + level, DAMAGE_TYPE_ACID);
            object target = GetSpellTargetObject();
            int DC = 15 + level;

            if (ooze_touch_damage(damage))
            {
                if (!MySavingThrow(SAVING_THROW_REFLEX, target, DC, SAVING_THROW_TYPE_ACID, OBJECT_SELF))
                {
                    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
                    effect stun = EffectLinkEffects(EffectStunned(), eMind);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, stun, target, RoundsToSeconds(1));
                }
            }
            break;
        }
        /* Phosphorescent Fungus */
        case 2013:
            ooze_touch_fungus();
            break;

        /* Black pudding */
        case 2014:
        {
            ooze_touch_damage(EffectDamage(d6(2) + level, DAMAGE_TYPE_ACID));
            break;
        }
        /* Gelatinous cube */
        case 2015:
        {
            object target = GetSpellTargetObject();
            int DC = 15 + level;

            if (!MySavingThrow(SAVING_THROW_FORT, target, DC, SAVING_THROW_TYPE_NONE, OBJECT_SELF))
            {
                effect damage = EffectParalyze();
                effect eMind = EffectVisualEffect(VFX_DUR_PARALYZED);
                effect paralyze = EffectLinkEffects(damage, eMind);

                ooze_touch_effect(paralyze, 1 + (level / 2));
            }
            break;
        }
        /* Green Slime */
        case 2016:
        {
            effect damage = EffectDamage(d6() + level, DAMAGE_TYPE_ACID);
            object target = GetSpellTargetObject();
            int DC = 15 + level;

            if (ooze_touch_damage(damage))
            {
                if (!MySavingThrow(SAVING_THROW_FORT, target, DC, SAVING_THROW_TYPE_ACID, OBJECT_SELF))
                {
                    effect eMind = EffectVisualEffect(VFX_DUR_IOUNSTONE_RED);
                    effect stun = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION, d6()), eMind);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, stun, target, RoundsToSeconds(1 + (level / 2)));
                }
            }
            break;
        }
        /* Yellow Mold */
        case 2017:
        {
            effect damage;
            object target = GetSpellTargetObject();
            int DC = 15 + level;

            if (!MySavingThrow(SAVING_THROW_FORT, target, DC, SAVING_THROW_TYPE_NONE, OBJECT_SELF))
            {
                damage = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(2));
            }
            else
            {
                damage = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6());
            }
            effect eMind = EffectVisualEffect(VFX_DUR_IOUNSTONE_RED);
            effect paralyze = EffectLinkEffects(damage, eMind);

            ooze_touch_effect(paralyze, 1 + level);
            break;
        }
    }
}

