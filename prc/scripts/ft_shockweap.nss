#include "heartward_inc"

void main()
{
   if (GetIsImmune(GetSpellTargetObject(),IMMUNITY_TYPE_CRITICAL_HIT)) return;

   object oWeap=GetSpellCastItem();
   if (GetBaseItemType(oWeap)!=BASE_ITEM_SHORTSPEAR ) return;


   int nThreat  = 20-GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN);
       nThreat -= GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR);
   int dice=d20();

   string tosay="*hit*: ("+IntToString(dice)+")";
      SendMessageToPC(OBJECT_SELF,tosay);


     if (dice>=nThreat)
    {
      SendMessageToPC(OBJECT_SELF,"*critical hit*");

      if (GetHasFeat( FEAT_SHOCKING_WEAPON,OBJECT_SELF))
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d10(),DAMAGE_TYPE_ELECTRICAL,DAMAGE_POWER_NORMAL),GetSpellTargetObject());

      ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d8(),DAMAGE_TYPE_SONIC,DAMAGE_POWER_NORMAL),GetSpellTargetObject());

    }
}
