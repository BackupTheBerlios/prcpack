//::///////////////////////////////////////////////
//:: Turn On Stealth Mode
//:: NW_CH_SRCH_ON.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
// Auldar: If asked to be Stealthy, flag associate for OnHeartbeat to maintain
// stealthy state, and activate stealth mode - Hmm. Can't activate stealth mode when
// in conversation. Removed code and leave it to OnHeartbeat.
#include "hench_i0_generic"

void main()
{
//    SetAssociateState(NW_ASC_AGGRESSIVE_STEALTH);
    ClearAllActions();
    SetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE", 1);
    DelayCommand(1.0, SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE));
}

