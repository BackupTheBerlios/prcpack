//::///////////////////////////////////////////////
//:: Check Locks No Help
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently not help with locked
    items
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "inc_npc"
int StartingConditional()
{
    if(!GetAssociateStateNPC(NW_ASC_RETRY_OPEN_LOCKS))
    {
        return TRUE;
    }
    return FALSE;
}
