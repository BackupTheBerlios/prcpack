#include "heartward_inc"
#include "inc_item_props"
#include "soul_inc"

void Discorp(object oPC,int iEquip)
{
  object oItem ;

  if (iEquip==2)
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     if ( GetLocalInt(oItem,"ShaDiscorp")) return;

        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);
        SetLocalInt(oItem,"ShaDiscorp",1);
  }
  else if (iEquip==1)
  {
      oItem=GetPCItemLastUnequipped();
      if (!GetLocalInt(oItem,"ShaDiscorp")) return;
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
      DeleteLocalInt(oItem,"ShaDiscorp");
  }
   else
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     if ( !GetLocalInt(oItem,"ShaDiscorp"))
     {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);
       SetLocalInt(oItem,"ShaDiscorp",1);
     }
  }


}


void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bDiscor= GetHasFeat(FEAT_SHADOWDISCOPOR, oPC) ? 1 : 0;

    if (GetLocalInt(oPC,"ONENTER")) return;
    if (bDiscor>0)   Discorp(oPC,GetLocalInt(oPC,"ONEQUIP"));


}
