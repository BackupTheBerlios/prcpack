//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_trap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// trap the soul spell for the lich class (demilich)

#include "prc_alterations"

void main()
{
    object oTarget = GetSpellTargetObject();

    // Gotta be a living critter
    int nType = MyPRCGetRacialType(oTarget);
    if ((nType == RACIAL_TYPE_CONSTRUCT) ||
        (nType == RACIAL_TYPE_UNDEAD) ||
        (nType == RACIAL_TYPE_ELEMENTAL))
    {
        FloatingTextStringOnCreature("Target must be alive",OBJECT_SELF);
        // should not count as a usage but... no way to do it
        return;
    }


    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    // To use this is to be pure evil...
    AdjustAlignment(OBJECT_SELF,ALIGNMENT_EVIL,20);

    // Total character levels
    int nTotalHD = GetHitDice(OBJECT_SELF);
    // Save DC
    int nSaveDC = 10 + nTotalHD/2 + GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);

    effect eVis;
    // Apply 4 neg levels if they fort save save
    if(FortitudeSave(oTarget,nSaveDC,SAVING_THROW_TYPE_DEATH ))
    {
        eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE );
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget,1.0);
        effect eNegLev = EffectNegativeLevel(4);
        // Cant be dispelled
        eNegLev = SupernaturalEffect(eNegLev);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eNegLev,oTarget);
        // should not count as a usage but... no way to do it
        return;
    }


    // They failed, now they die
    eVis = EffectVisualEffect(VFX_FNF_PWKILL);
    effect eDeath = EffectDeath(TRUE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
    // Blow yellow chunks for extra fun
    eVis = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_MEDIUM);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
    // Give the PKill vis time to run
    DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oTarget));

    return;
}
