#include "heartward_inc"
#include "inc_item_props"


void RemoveSpecificsProperty(object oItem, int iType, int iSubType = -1, int iCostVal = -1, int iParamV =-1,int iNum = 1, string sFlag = "")
{
  int iRemoved = 0;
  itemproperty ip = GetFirstItemProperty(oItem);

  while(GetIsItemPropertyValid(ip) && iRemoved < iNum)
  {
    if(GetItemPropertyType(ip) == iType && (GetItemPropertySubType(ip) == iSubType || iSubType==-1 )&& (GetItemPropertyCostTableValue(ip) == iCostVal || iCostVal==-1) )
    {
      if ( GetItemPropertyParam1Value(ip)==iParamV || iParamV==-1 )
      {
        RemoveItemProperty(oItem, ip);
        iRemoved++;
      }
    }
    ip = GetNextItemProperty(oItem);
  }
  SetLocalInt(oItem, sFlag, 0);
}

void MartialStrike()
{
   object oItem;
   object oPC = OBJECT_SELF;

   if (GetLocalInt(oPC,"ONENTER"))
   {
     //SetLocal(oPC);
     return;
   }

   int iEquip=GetLocalInt(oPC,"ONEQUIP");
   int iType;

   if (iEquip==2)
   {
     oItem=GetPCItemLastEquipped();
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

     if ( GetLocalInt(oItem,"MartialStrik")) return ;

     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem);
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem);
     SetLocalInt(oItem,"MartialStrik",1);
  }
   else if (iEquip==1)
   {
     oItem=GetPCItemLastUnequipped();
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

    if ( GetLocalInt(oItem,"MartialStrik"))
    {
      RemoveSpecificsProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6,IP_CONST_DAMAGETYPE_DIVINE);
      RemoveSpecificsProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY);
      DeleteLocalInt(oItem,"MartialStrik");
    }

   }
   else
   {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

     if (!GetLocalInt(oItem,"MartialStrik"))
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem);
       SetLocalInt(oItem,"MartialStrik",1);
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     if ( !GetLocalInt(oItem,"MartialStrik"))
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6),oItem);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY),oItem);
       SetLocalInt(oItem,"MartialStrik",1);
     }
   }


}
