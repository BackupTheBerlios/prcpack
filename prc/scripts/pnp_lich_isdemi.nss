//::///////////////////////////////////////////////
//:: FileName pnp_lich_isdemi
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/24/2004 9:30:45 AM
//:://////////////////////////////////////////////
#include "prc_class_const"

// Determines if the the lich is able to start the process of becoming a demilich

int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if((GetLevelByClass(CLASS_TYPE_LICH, GetPCSpeaker()) >= 4) &&
       ((GetLevelByClass(CLASS_TYPE_CLERIC,GetPCSpeaker()) >= 21) ||
        (GetLevelByClass(CLASS_TYPE_WIZARD,GetPCSpeaker()) >= 21) ||
        (GetLevelByClass(CLASS_TYPE_SORCERER,GetPCSpeaker()) >= 21)) )
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
