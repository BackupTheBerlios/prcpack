#include "inc_item_props"
#include "heartward_inc"

void RemovBonusStormlord(object oPC)
{
   object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

   if (GetBaseItemType(oItem)!=BASE_ITEM_SHORTSPEAR) return;
   if (GetLocalInt(oItem,"STShock")) return;

   if (GetHasFeat(FEAT_SHOCK_WEAPON,oPC)) SetLocalInt(oItem,"STShock",1);
   if (GetHasFeat(FEAT_THUNDER_WEAPON,oPC)) SetLocalInt(oItem,"STThund",1);
}




void main()
{
    //The composite properties system gets confused when an exported
    //character re-enters.  Local Variables are lost and most properties
    //get re-added, sometimes resulting in larger than normal bonuses.
    //The only real solution is to wipe the skin on entry.  This will
    //mess up the lich, but only until I hook it into the EvalPRC event -
    //hopefully in the next update
    //  -Aaon Graywolf
    object oEntering=GetEnteringObject();
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oEntering);
    DestroyObject(oSkin);

     if (GetLevelByClass(CLASS_TYPE_STORMLORD,oEntering))
      RemovBonusStormlord(oEntering);
}
