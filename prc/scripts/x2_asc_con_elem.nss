//::///////////////////////////////////////////////
//:: x2_asc_con_summo
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    - returns true if dominated
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "inc_npc"

int StartingConditional()
{
    object oSelf = OBJECT_SELF;
    if ( GetLocalObject(OBJECT_SELF, "oMaster")==GetPCSpeaker())
    {
        return TRUE;
    }
    return FALSE;

}
