//:://////////////////////////////////////////////
//:: Craft Staff (Item Creation Feat)
//:: HD_S2_CraftStaf
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Attempt to craft a staff using the Craft Staff feat.
*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: December 11, 2003
//:://////////////////////////////////////////////

#include "HD_I0_ITEMCREAT"

void main()
{
    // If there is a previous item creation process, end it on beginning this attempt.
    struct itemcreationprocess pProcess = GetLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS");
    if (pProcess.result != "")
        {
            DeleteLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS");
            FloatingTextStringOnCreature("Your item creation process has been ruined!", OBJECT_SELF, FALSE);
        }
    // Persistent Tracking only
    // DeleteCampaignItemCreationProcess(sCampaignName, "HD_ICPROCESS", OBJECT_SELF);
    object oTarget = GetSpellTargetObject();
    object oStaff, oBench;
    string sRecipeTag, sStaffTemplate;
    string sMessage;
    int nTargetType = GetObjectType(oTarget);
    struct ireqreport iReport;

    // Current valid targets are: items, placeables, doors, and creatures.
    // If would-be staff creator is trying to use Craft Staff on some invalid target..
    if (!(
          (nTargetType == OBJECT_TYPE_ITEM) ||
          (nTargetType == OBJECT_TYPE_PLACEABLE) ||
          (nTargetType == OBJECT_TYPE_DOOR) ||
          (nTargetType == OBJECT_TYPE_CREATURE)
         ))
        {
            sMessage = "You cannot use this to craft a staff\n";
            SendMessageToPC(OBJECT_SELF, sMessage);
            return;
        }
    // If valid target..
    else
        {
            // and if IReqs check out,
            sRecipeTag = GetTag(oTarget);
            iReport = CheckIReqs(sRecipeTag, TRUE, FALSE);
            // Is the result item even a staff?
            if (IsStaff(iReport.baseitemtype) == FALSE)
                {
                    sMessage = "You cannot use this to craft a staff\n";
                    SendMessageToPC(OBJECT_SELF, sMessage);
                    return;
                }
            // if so, progress
            else
                {
                    iReport = CheckIReqs(sRecipeTag, FALSE, TRUE);
                    sStaffTemplate = iReport.result;
                    // get the staff template from the IReqTable
                    // Set the variables
                    if (sStaffTemplate != "")
                    {
                        struct itemcreationprocess pProcess;
                        pProcess.result        = sStaffTemplate;
                        pProcess.marketprice   = iReport.marketprice;
                        pProcess.lasttimestamp = GetTimeHour();
                        pProcess.completeddays = 0.0;
                        SetLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS", pProcess);
                        FloatingTextStringOnCreature("You have begun crafting a staff...", OBJECT_SELF, FALSE);
                        DelayCommand(6.0, ExecuteScript("hd_g0_heartbeat", OBJECT_SELF));
                    }
                    return;
                }
        }
}
