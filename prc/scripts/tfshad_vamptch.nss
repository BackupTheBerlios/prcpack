//::///////////////////////////////////////////////
//:: Vampiric Touch
//:: NW_S0_VampTch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    drain 1d6
    HP per 2 caster levels from the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

/*
bugfix by Kovi 2002.07.22
- did double damage with maximize
- temporary hp was stacked
2002.08.25
- got temporary hp some immune creatures (Negative Energy Protection), lost
temporary hp against other resistant (SR, Shadow Shield)

Georg 2003-09-11
- Put in melee touch attack check, as the fixed attack bonus is now calculated correctly

*/

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"
#include "soul_inc"

#include "x0_I0_SPELLS"


#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
    //--------------------------------------------------------------------------
    /*  Spellcast Hook Code
       Added 2003-06-20 by Georg
       If you want to make changes to all spells,
       check x2_inc_spellhook.nss to find out more
    */
    //--------------------------------------------------------------------------

    if (!X2PreSpellCastCode())
    {
        return;
    }
    //--------------------------------------------------------------------------
    // End of Spell Cast Hook
    //--------------------------------------------------------------------------


    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();

    int nCasterLevel  = GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);

    int nDDice = nCasterLevel /2;
    if ((nDDice) == 0)
    {
        nDDice = 1;
    }
    //--------------------------------------------------------------------------
    // GZ: Cap according to the book
    //--------------------------------------------------------------------------
    else if (nDDice>10)
    {
        nDDice = 10;
    }

    int nDamage = d6(nDDice);

    int nDuration = nCasterLevel/2;


    //--------------------------------------------------------------------------
    //Limit damage to max hp + 10
    //--------------------------------------------------------------------------
    int nMax = GetCurrentHitPoints(oTarget) + 10;
    if(nMax < nDamage)
    {
        nDamage = nMax;
    }

    effect eHeal = EffectTemporaryHitpoints(nDamage);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHeal, eDur);

    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(!GetIsReactionTypeFriendly(oTarget) &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {


            SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, FALSE));
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, TRUE));
            // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
            if (TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID)>0)
            {
                if(MyPRCResistSpell2(OBJECT_SELF, oTarget,nCasterLevel) == 0)
                 {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF);
                    RemoveTempHitPoints();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(nDuration));
                 }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
