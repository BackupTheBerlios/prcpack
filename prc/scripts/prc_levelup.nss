/*
    Put into: OnLevelup Event
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius and DarkGod
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - Jan 6, 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004


#include "prc_dg_inc"
#include "strat_prc_inc"
#include "discipleinclude"
#include "x2_inc_switches"
#include "x2_inc_intweapon"
#include "inc_prc_function"

void main()
{
    object oPC = GetPCLevellingUp();
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    DelayCommand(0.1, EvalPRCFeats(oPC));
}
