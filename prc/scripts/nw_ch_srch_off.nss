//::///////////////////////////////////////////////
//:: Turn Off Search Mode
//:: NW_CH_SRCH_ON.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
#include "hench_i0_generic"

void main()
{
    SetAssociateState(NW_ASC_AGGRESSIVE_SEARCH, FALSE);
    SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
}
