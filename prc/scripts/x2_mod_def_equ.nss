//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_equ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
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

    object oItem = GetPCItemLastEquipped();
    object oPC   = GetPCItemLastEquippedBy();
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nBaseItem = GetBaseItemType(oItem);
    //const int FEAT_HELLFIRE_GRASP = 2000;
    //const int FEAT_FIRE_ADEPT = 2001;
    //const int FEAT_FIRE_RESISTANCE_10 = 2002;
    //const int FEAT_FIRE_RESISTANCE_20 = 2007;

    // -------------------------------------------------------------------------
    // Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
        IWSetIntelligentWeaponEquipped(oPC,oItem);
        // prevent players from reequipping their weapon in
        if (IWGetIsInIntelligentWeaponConversation(oPC))
        {
                object oConv =   GetLocalObject(oPC,"X2_O_INTWEAPON_SPIRIT");
                IWEndIntelligentWeaponConversation(oConv, oPC);
        }
        else
        {
            //------------------------------------------------------------------
            // Trigger Drain Health Event
            //------------------------------------------------------------------
            if (GetLocalInt(oPC,"X2_L_ENSERRIC_ASKED_Q3")==1)
            {
                ExecuteScript ("x2_ens_dodrain",oPC);
            }
            else
            {
                IWPlayRandomEquipComment(oPC,oItem);
            }
        }
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
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
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
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oItem, 0.0);
            SetPlotFlag( oItem, TRUE );
        }
    }
    // -------------------------------------------------------------------------
    // Fire Resistance
    // -------------------------------------------------------------------------
    if (GetHasFeat(2007, oPC))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20), oArmour, 0.0);
        SetPlotFlag(oArmour, TRUE);
    }
    else if (GetHasFeat(2002, oPC))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10), oArmour, 0.0);
            SetPlotFlag(oArmour, TRUE);
        }
}
