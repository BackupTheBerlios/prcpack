//::///////////////////////////////////////////////
//:: True Necomancer Energy Drain
//:: PRC_TN_EnDrain.nss
//:://////////////////////////////////////////////
/*
    Target loses 2d4 levels.
*/
//:://////////////////////////////////////////////
//:: Created By: James Tallet
//:: Created On: Mar 4, 2004
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget = GetSpellTargetObject();
    int nDrain = d4(2);
    effect eDrain = EffectNegativeLevel(nDrain);
    eDrain = SupernaturalEffect(eDrain);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERGY_DRAIN));
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

