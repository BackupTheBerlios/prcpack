//::///////////////////////////////////////////////
//:: Check if Stealth Enabled
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently use stealth when
    moving.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:
//:://////////////////////////////////////////////
//:: Brent: May 2002: Disabled this option

#include "hench_i0_generic"

int StartingConditional()
{
//    return FALSE;
// Auldar: Undisabling this script
/*    if(GetAssociateState(NW_ASC_AGGRESSIVE_STEALTH))
    {
        return TRUE;
    }
    return FALSE; */
    return GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE");    

}
