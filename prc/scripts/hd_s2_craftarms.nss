//:://////////////////////////////////////////////
//:: Craft Magic Arms and Armor (Item Creation Feat)
//:: HD_S2_CraftArms
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Attempt to craft a weapon or armor using the Craft Magic Arms and Armor feat.
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
    object oArmsArmorItem, oBench;
    string sRecipeTag, sArmsArmorTemplate;
    string sMessage;
    int nTargetType = GetObjectType(oTarget);
    struct ireqreport iReport;

    // Current valid targets are: items, placeables, doors, and creatures.
    // If would-be arms creator is trying to use Craft Magic Arms and Armor on some invalid target..
    if (!(
          (nTargetType == OBJECT_TYPE_ITEM) ||
          (nTargetType == OBJECT_TYPE_PLACEABLE) ||
          (nTargetType == OBJECT_TYPE_DOOR) ||
          (nTargetType == OBJECT_TYPE_CREATURE)
         ))
        {
            sMessage = "You cannot use this to craft a magical weapon or armor.\n";
            SendMessageToPC(OBJECT_SELF, sMessage);
            return;
        }
    // If valid target..
    else
        {
            // and if IReqs check out,
            sRecipeTag = GetTag(oTarget);
            iReport = CheckIReqs(sRecipeTag, TRUE, FALSE);
            // Is the result item even a weapon or armor?
            if (IsMagicArmOrArmor(iReport.baseitemtype) == FALSE)
                {
                    sMessage = "You cannot use this to craft a magical weapon or armor.\n";
                    SendMessageToPC(OBJECT_SELF, sMessage);
                    return;
                }
            // if so, create an item creation process on the char
            else
                {
                    iReport = CheckIReqs(sRecipeTag, FALSE, TRUE);
                    sArmsArmorTemplate = iReport.result;
                    // get the weapon/armor template from the IReqTable
                    // Set the variables
                    if (sArmsArmorTemplate != "")
                    {
                        struct itemcreationprocess pProcess;
                        pProcess.result        = sArmsArmorTemplate;
                        pProcess.marketprice   = iReport.marketprice;
                        pProcess.lasttimestamp = GetTimeHour();
                        pProcess.completeddays = 0.0;
                        SetLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS", pProcess);
                        if (iReport.baseitemtype == BASE_ITEM_ARMOR)
                            {FloatingTextStringOnCreature("You have begun crafting a magical armor...", OBJECT_SELF, FALSE);}
                        else if ((iReport.baseitemtype == BASE_ITEM_SMALLSHIELD) ||
                                 (iReport.baseitemtype == BASE_ITEM_LARGESHIELD) ||
                                 (iReport.baseitemtype == BASE_ITEM_TOWERSHIELD))
                            {FloatingTextStringOnCreature("You have begun crafting a magical shield...", OBJECT_SELF, FALSE);}
                        else
                            {FloatingTextStringOnCreature("You have begun crafting a magical weapon...", OBJECT_SELF, FALSE);}
                        DelayCommand(6.0, ExecuteScript("hd_g0_heartbeat", OBJECT_SELF));
                    }
                    return;
                }
        }
}
