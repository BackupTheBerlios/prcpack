//::///////////////////////////////////////////////
//:: Check if Search Disabled
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
// Auldar: Do we have skill points spent in the search skill
#include "hench_i0_generic"
#include "inc_npc"

int StartingConditional()
{
    if(!GetAssociateStateNPC(NW_ASC_AGGRESSIVE_SEARCH) && (GetDetectMode(OBJECT_SELF) != 1))
    {
        return TRUE;
    }
    else return FALSE;
}
