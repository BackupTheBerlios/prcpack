//::///////////////////////////////////////////////
//:: [Vassal Feats]
//:: [prc_vassal.nss]
//:://////////////////////////////////////////////
//:: Check to see which Vassal of Bahamut lvls a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Created On: April 5, 2005
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

void AddArmorOnhit(object oPC,int iEquip)

     {
     object oItem ;
     if (iEquip==2)
     {
         oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     if ( GetLocalInt(oItem,"Dragonwrack")) return;
         AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);
         SetLocalInt(oItem,"Dragonwrack",1);
     }
     else if (iEquip==1)
     {

void main()
{

    // *get the vassal's class level and his armors
    int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL,OBJECT_SELF);
    object oArmor4 = GetItemPossessedBy(OBJECT_SELF, "Platinumarmor4");
    object oArmor6 = GetItemPossessedBy(OBJECT_SELF, "Platinumarmor6");
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);

    // *Level 1
    if (nVassal==1)
    // *Give him the Platinum Armor+4
    {
    if ( GetLocalInt(OBJECT_SELF, "Level1") == 1) return ;

    CreateItemOnObject("Platinumarmor4", OBJECT_SELF, 1);
    SetLocalInt(OBJECT_SELF, "Level1", 1);
    }

    // *Level 2
    if (nVassal==2)
    // *Shared Trove
    {
    if ( GetLocalInt(OBJECT_SELF, "Level2") == 1) return ;

    GiveGoldToCreature(OBJECT_SELF, 200000);
    SetLocalInt( OBJECT_SELF, "Level2", 1);
    }

    // *Level 4

    // *Level 5
    if (nVassal==5)
    // *Shared Trove
    {
    if ( GetLocalInt(OBJECT_SELF, "Level5") == 1) return ;

    GiveGoldToCreature(OBJECT_SELF, 50000);
    // *Platinum Armor +6
    DestroyObject(oArmor4, 0.0f);
    CreateItemOnObject("Platinumarmor6", OBJECT_SELF, 1);
    SetLocalInt( OBJECT_SELF, "Level5", 1);
    }

    // *Level 8
    if (nVassal==8)
    {
    // *Shared Trove
    GiveGoldToCreature(OBJECT_SELF, 80000);
    }

    // *Level 10
    if (nVassal==10)
    {
    // *platinum Armor +8
    if ( GetLocalInt(OBJECT_SELF, "Level10") == 1) return ;
    DestroyObject(oArmor6, 0.0f);
    CreateItemOnObject("Platinumarmor8", OBJECT_SELF, 1);
    SetLocalInt( OBJECT_SELF, "Level10", 1);
    }
}
