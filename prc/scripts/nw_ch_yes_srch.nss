//::///////////////////////////////////////////////
//:: Check if Search Enabled
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently not search when
    moving.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:
//:://////////////////////////////////////////////
//:: Brent: May 2002: Disabled this option
#include "hench_i0_generic"
#include "inc_npc"

int StartingConditional()
{
//    return FALSE;
// Auldar: Undisabling this script
    if(GetAssociateStateNPC(NW_ASC_AGGRESSIVE_SEARCH))
    {
        return TRUE;
    }
    return FALSE;
}
