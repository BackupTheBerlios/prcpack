//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    make an attack roll. If succesful target is held for 1 round/level


*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"

#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    int nDuration = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 461, TRUE));

        // Check spell resistance
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget))
        {
            // Check caster ability vs. target's AC

            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            int nCasterRoll = d20(1)
                + nCasterModifier
                + (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF)) + 10 + -1;

            int nTargetRoll = GetAC(oTarget);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check to
                // * hold target for duration of spell
                // * check caster ability vs. target's size & strength
                nCasterRoll = d20(1) + nCasterModifier
                    + (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF)) + 10 +4;

                nTargetRoll = GetSizeModifier(oTarget)
                    + GetAbilityModifier(ABILITY_STRENGTH);

                if (nCasterRoll >= nTargetRoll)
                {
                    // Hold the target paralyzed
                    effect eKnockdown = EffectParalyze();
                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eDur);
                    eLink = EffectLinkEffects(eHand, eLink);
                    eLink = EffectLinkEffects(eVis, eLink);
                    if (GetIsImmune(oTarget, EFFECT_TYPE_PARALYZE) == FALSE)
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                            eLink, oTarget,
                                            RoundsToSeconds(nDuration));

    //                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
    //                                        eVis, oTarget,RoundsToSeconds(nDuration));
                        FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
                    }
                }
                else
                {
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}


