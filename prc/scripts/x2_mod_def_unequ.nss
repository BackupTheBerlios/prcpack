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
//:://////////////////////////////////////////////
//:: Modified By: Sir_Attilla
//:: Modified On: 2004-01-03
//:://///////////////////////////////////////////
#include "x2_inc_switches"
#include "x2_inc_intweapon"

void main()
{

    object oItem = GetPCItemLastUnequipped();
    object oPC   = GetPCItemLastUnequippedBy();
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nBaseItem = GetBaseItemType(oItem);
    //const int FEAT_HELLFIRE_GRASP = 2000;
    //const int FEAT_FIRE_ADEPT = 2001;
    //const int FEAT_FIRE_RESISTANCE_10 = 2002;
    //const int FEAT_FIRE_RESISTANCE_20 = 2007;

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
     // -------------------------------------------------------------------------
     // Disciple of Mephistopheles Glove Check
     // -------------------------------------------------------------------------
    if (GetHasFeat(2000, oPC))
    {
        if (nBaseItem == BASE_ITEM_GLOVES)
        {
            RemoveItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6));
            SetPlotFlag( oItem, FALSE );
        }
    }
    // -------------------------------------------------------------------------
    // Fire Resistance
    // -------------------------------------------------------------------------
    if (GetHasFeat(2007, oPC))
    {
        RemoveItemProperty(oArmour, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20));
        SetPlotFlag(oArmour, FALSE);
    }
    else if (GetHasFeat(2002, oPC))
        {
            RemoveItemProperty(oArmour, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10));
            SetPlotFlag(oArmour, FALSE);
        }
}

