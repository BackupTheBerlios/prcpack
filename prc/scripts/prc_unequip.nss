//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_unequ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "x2_inc_switches"
#include "x2_inc_intweapon"
#include "inc_item_props"

void PrcFeats(object oPC)
{
     SetLocalInt(oPC,"ONEQUIP",1);
     EvalPRCFeats(oPC);
     DeleteLocalInt(oPC,"ONEQUIP");
}

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - 6 Jan 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004
void main()
{
     object oItem = GetPCItemLastUnequipped();
     object oPC   = GetPCItemLastUnequippedBy();

    // -------------------------------------------------------------------------
    //  Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
            IWSetIntelligentWeaponEquipped(oPC,OBJECT_INVALID);
            IWPlayRandomUnequipComment(oPC,oItem);
    }

     // -------------------------------------------------------------------------
     // Generic Item Script Execution Code
     // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // it will execute a script that has the same name as the item's tag
     // inside this script you can manage scripts for all events by checking against
     // GetUserDefinedItemEventNumber(). See x2_it_example.nss
     // -------------------------------------------------------------------------
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }

     }

     DelayCommand(0.5,PrcFeats(oPC));

     // * Moved code to turn off precise strike here
     // * because unequiped weapons weren't being found
     // * correctly through EvalPRCFeats
     DuelistRemovePreciseStrike(oItem);
     KnightRemoveDaemonslaying(oItem);
}
