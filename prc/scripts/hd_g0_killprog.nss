//:://////////////////////////////////////////////
//:: KillProg (Item Creation Feats - PC)
//:: HD_G0_KillProg
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Run on a PC when something has killed their icprocess
*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: December 22, 2003
//:://////////////////////////////////////////////

#include "HD_I0_ITEMCREAT"

int IsMultiplayer()
    {return GetLocalInt(GetModule(), "nIsMultiplayer");}


void main()
{
    // Clear all the process variables.
    DeleteLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS");
    string sMesg = "Your item creation process has been ruined!";
    // SendMessageToPC(OBJECT_SELF, sMesg);
    FloatingTextStringOnCreature(sMesg, OBJECT_SELF, FALSE);
    //
    // if (IsMultiplayer())
    //    {DeleteCampaignItemCreationProcess(sCampaignName, "HD_ICPROCESS", OBJECT_SELF);}
}

