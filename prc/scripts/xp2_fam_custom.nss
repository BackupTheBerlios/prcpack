//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Check what type of familiar the PC has.
*/
//:://////////////////////////////////////////////
//:: Created By: Dan Whiteside
//:: Created On: Oct. 2003
//:://////////////////////////////////////////////
#include "inc_npc"
int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "iAssocType") == TRUE)
        return TRUE;
    return FALSE;
}
