#include "x2_inc_itemprop"

void main()
{
   object oItem=GetSpellTargetObject();
   int iType=GetBaseItemType(oItem);

   string iSlot = Get2DAString("baseitems", "EquipableSlots", iType);


   if (iSlot=="0x1C030" || iSlot=="0x1C010" ||iSlot=="0x02000"  ||iSlot=="0x01000" ||iSlot=="0x00800"  ||iSlot=="0x00030" ||iSlot=="0x00020" || iSlot=="0x00010" ||iSlot=="0x00002")
   {

      if (GetPlotFlag(oItem))
      {
        FloatingTextStringOnCreature("Don't work on Artifact", OBJECT_SELF);
        return;
      }
      SetIdentified(oItem,TRUE );

   }
   else
   {
     FloatingTextStringOnCreature("Work only on armors and Weapons", OBJECT_SELF);
     return;
   }












}
