//::///////////////////////////////////////////////
//:: [Scare]
//:: [NW_S0_Scare.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is scared for 1d4 rounds.
//:: NOTE THIS SPELL IS EQUAL TO **CAUSE FEAR** NOT SCARE.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_alterations"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = d4();
   effect eScare = EffectFrightened();
   effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
   effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);


   effect eDamagePenalty = EffectDamageDecrease(2);
   effect eAttackPenalty = EffectAttackDecrease(2);


   effect eLink = EffectLinkEffects(eMind, eScare);
   effect eLink2 = EffectLinkEffects(eSave, eDur);
   eLink2 = EffectLinkEffects(eLink2, eDamagePenalty);
   eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);

   //Check the Hit Dice of the creature
   if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
   {
        // * added rep check April 2003
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
        {
            //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SCARE));
           //Make SR check
           if(!MyPRCResistSpell(OBJECT_SELF, oTarget))
           {
                //Make Will save versus fear
                if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_FEAR))
                {
                   //Do metamagic checks
                   if (nMetaMagic == METAMAGIC_MAXIMIZE)
                   {
                       nDuration = 4;
                   }
                   if(nMetaMagic == METAMAGIC_EMPOWER)
                   {
                       nDuration = nDuration + (nDuration/2);
                   }
                   //Apply linked effects and VFX impact
                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
                }
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
