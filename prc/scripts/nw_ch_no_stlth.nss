//::///////////////////////////////////////////////
//:: Check if Stealth Disabled
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does the henchman currently not use stealth when
    moving.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:
//:://////////////////////////////////////////////
// Auldar: Do we have skill points spent in either Hide or Move Silently skills
#include "hench_i0_generic"

int StartingConditional()
{
/*    if(!GetAssociateState(NW_ASC_AGGRESSIVE_STEALTH))
    {
        return TRUE;
    }
    return FALSE; */
    
    return !GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE");    
}
