//::///////////////////////////////////////////////
//:: Check Traps Help
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently help with locked
    items
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"
#include "inc_npc"

int StartingConditional()
{
    if(GetAssociateStateNPC(NW_ASC_DISARM_TRAPS))
    {
        return TRUE;
    }
    return FALSE;
}

