#include "inc_item_props"
#include "prc_feat_const"

////    Resistance Electricity   ////

void ResElec(object oPC ,object oSkin ,int iLevel)
{
  if(GetLocalInt(oSkin, "StormLResElec") == iLevel) return;

  RemoveSpecificProperty(oSkin,ITEM_PROPERTY_DAMAGE_RESISTANCE,IP_CONST_DAMAGETYPE_ELECTRICAL,GetLocalInt(oSkin, "StormLResElec"));
  AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,iLevel),oSkin);
  SetLocalInt(oSkin, "StormLResElec",iLevel);
}

void ShockWeap(object oPC,int iEquip)
{
  object oItem ;

  if (iEquip==2)        // On Equip
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

     if ( GetLocalInt(oItem,"STShock")) return ;


     if (GetBaseItemType(oItem)==BASE_ITEM_SHORTSPEAR)
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oItem);
       SetLocalInt(oItem,"STShock",1);
     }

  }
  else if (iEquip==1)     // Unequip
  {
     oItem=GetPCItemLastUnequipped();
     if (GetBaseItemType(oItem)!=BASE_ITEM_SHORTSPEAR) return;
     if ( GetLocalInt(oItem,"STShock"))
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6);
     DeleteLocalInt(oItem,"STShock");

  }
  else
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     if ( !GetLocalInt(oItem,"STShock")&& GetBaseItemType(oItem)==BASE_ITEM_SHORTSPEAR)
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oItem);
       SetLocalInt(oItem,"STShock",1);
     }
  }

}

void ShockingWeap(object oPC,int iEquip)
{
  object oItem ;

  if (iEquip==2)
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     if ( GetLocalInt(oItem,"STThund"))
         return;

     if (GetBaseItemType(oItem)==BASE_ITEM_SHORTSPEAR)
     {
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);

        SetLocalInt(oItem,"STThund",1);
     }
  }
  else if (iEquip==1)
  {
      oItem=GetPCItemLastUnequipped();
      if (GetBaseItemType(oItem)!=BASE_ITEM_SHORTSPEAR) return;
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
      DeleteLocalInt(oItem,"STThund");
  }
   else
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     if ( !GetLocalInt(oItem,"STThund")&& GetBaseItemType(oItem)==BASE_ITEM_SHORTSPEAR)
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);
        SetLocalInt(oItem,"STThund",1);
     }
  }


}

void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bResElec=GetHasFeat(FEAT_ELECTRIC_RES_10, oPC) ? IP_CONST_DAMAGERESIST_10 : 0;
        bResElec=GetHasFeat(FEAT_ELECTRIC_RES_15, oPC) ? IP_CONST_DAMAGERESIST_15 : bResElec;
        bResElec=GetHasFeat(FEAT_ELECTRIC_RES_20, oPC) ? IP_CONST_DAMAGERESIST_20 : bResElec;
        bResElec=GetHasFeat(FEAT_ELECTRIC_RES_30, oPC) ? IP_CONST_DAMAGERESIST_30 : bResElec;

    int bShockWeap=GetHasFeat(FEAT_SHOCK_WEAPON,oPC)        ?  1:0;
    int bShockingWeap=GetHasFeat(FEAT_THUNDER_WEAPON,oPC)   ?  1:0;

    if (bResElec>0) ResElec(oPC,oSkin,bResElec);
    if (bShockWeap>0)ShockWeap(oPC,GetLocalInt(oPC,"ONEQUIP"));
    if (bShockingWeap>0)ShockingWeap(oPC,GetLocalInt(oPC,"ONEQUIP"));

}
