//::///////////////////////////////////////////////
//:: FileName pnp_shift_c107
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 2/22/2004 5:22:03 PM
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "pnp_shifter"

// The user has selected index 1 from the starting condition to shift into

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=7;
    ShiftFromKnownArray(nStartIndex,OBJECT_SELF,oPC);

}
