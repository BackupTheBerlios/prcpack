//::///////////////////////////////////////////////
//:: Web: On Enter
//:: NW_S0_WebA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle targets who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/5 normal.
    The higher the creatures Strength the faster
    they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    effect eWeb = EffectEntangle();
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    effect eLink = EffectLinkEffects(eWeb, eVis);
    object oTarget = GetEnteringObject();

    // * the lower the number the faster you go
    int nSlow = 65 - (GetAbilityScore(oTarget, ABILITY_STRENGTH)*2);
    if (nSlow <= 0)
    {
        nSlow = 1;
    }

    if (nSlow > 99)
    {
        nSlow = 99;
    }

    effect eSlow = EffectMovementSpeedDecrease(nSlow);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
         if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_WEB));
            //Spell resistance check
            if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget))
            {
                //Make a Fortitude Save to avoid the effects of the entangle.
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(GetAreaOfEffectCreator()))))
                {
                    //Entangle effect and Web VFX impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
                }
                //Slow down the creature within the Web
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school

}
