//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_alterations"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLower = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eLink = EffectLinkEffects(eVis, eLower);
    int bValid = FALSE;
    float fDelay = GetRandomDelay(1.0, 2.2);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));
        //Make SR check
        effect eAOE = GetFirstEffect(oTarget);
        if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
        {
            while (GetIsEffectValid(eAOE))
            {
                //If the effect was created by the Mind_Fog then remove it
                if (GetEffectSpellId(eAOE) == SPELL_MIND_FOG && GetAreaOfEffectCreator() == GetEffectCreator(eAOE))
                {
                    if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
                //Get the next effect on the creation
                eAOE = GetNextEffect(oTarget);
            }
        //Check if the effect has been put on the creature already.  If no, then save again
        //If yes, apply without a save.
        }
        if(bValid == FALSE)
        {
            if(!MyPRCResistSpell(OBJECT_SELF, oTarget))
            {
                //Make Will save to negate
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply VFX impact and lowered save effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
                }
            }
        }
        else
        {
            //Apply VFX impact and lowered save effect
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
