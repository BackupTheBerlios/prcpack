//::///////////////////////////////////////////////
//:: Vampiric Drain
//:: PRC_vampdrain.nss
//:://////////////////////////////////////////////
/*
    Drain living, caster heals
    Drain dead, caster dies
*/
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Created On: April 5, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"

#include "x0_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
    /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();

    int nCasterLevel = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    int nDDice = nCasterLevel /4;
    if ((nDDice) == 0)
    {
        nDDice = 1;
    }
    //Damage Limit
        else if (nDDice>5)
    {
        nDDice = 5;
    }

    int nDamage = d6(nDDice);
    //--------------------------------------------------------------------------
    //Enter Metamagic conditions
    //--------------------------------------------------------------------------
    nDamage = MaximizeOrEmpower(6,nDDice,nMetaMagic);
    int nDuration = nCasterLevel/3;

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }
    //--------------------------------------------------------------------------
    //Limit damage to max hp + 10
    //--------------------------------------------------------------------------
    int nMax = GetCurrentHitPoints(oTarget) + 10;
    if(nMax < nDamage)
    {
        nDamage = nMax;
    }

    effect eHeal = EffectTemporaryHitpoints(nDamage/2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHeal, eDur);
    effect eHurt = EffectDamage(nDamage/2);
    effect eBad =EffectTemporaryHitpoints(nDamage);
    effect eNegLink = EffectLinkEffects(eBad, eDur);
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
    float fDelay;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Get first target in shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
        {
            //Check if the target is undead
            if( MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHurt, OBJECT_SELF);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
                    RemoveTempHitPoints();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1));
                }
            //Check if the target is hostile, and not an undead or construct
            //or protected by a spell
            if(!GetIsReactionTypeFriendly(oTarget) &&
                MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
                MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
                !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
                {
                    if(MyPRCResistSpell(OBJECT_SELF, oTarget) == 0)
                    {
                    if(/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
                    {
                        nDamage = nDamage/2;
                    }
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF);
                        RemoveTempHitPoints();
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(1));
                    }
                }
            //Get next target in spell area
            oTarget = GetNextInPersistentObject();
        }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the integer used to hold the spells spell school
    }