//:://////////////////////////////////////////////
//:: TrackProg (Item Creation Feats - Module)
//:: HD_O0_TrackProg
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Run every game hour (by default: 2 real minutes)
*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: December 11, 2003
//:://////////////////////////////////////////////

#include "HD_I0_ITEMCREAT"

void main()
{
    // Check each player for an item creation process

    int nPCs = 0;
    object oPC = GetFirstPC();
    struct itemcreationprocess pProcess;
    while (GetIsObjectValid(oPC) == TRUE)
    {
        pProcess = GetLocalItemCreationProcess(oPC, "HD_ICPROCESS");
        if (pProcess.result != "")
            {DelayCommand(nPCs * 0.05, ExecuteScript("hd_g0_trackprog", oPC));}
        nPCs = nPCs + 1;
        oPC = GetNextPC();
    }
}
