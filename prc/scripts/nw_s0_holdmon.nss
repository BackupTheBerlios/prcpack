//::///////////////////////////////////////////////
//:: Hold Monster
//:: NW_S0_HoldMon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will hold any monster in place for 1
    round per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_alterations"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
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
    int nCasterLvl = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    int nMeta = GetMetaMagicFeat();
    int nDuration = nCasterLvl;
    nDuration = GetScaledDuration(nDuration, oTarget);
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = EffectLinkEffects(eLink, eDur3);


    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_MONSTER));
       //Make SR check
       if (!MyPRCResistSpell(OBJECT_SELF, oTarget))
       {
            //Make Will save
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF))))
            {
                //Check for metamagic extend
                if (nMeta == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Apply the paralyze effect and the VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
