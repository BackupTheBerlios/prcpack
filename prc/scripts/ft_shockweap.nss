#include "prc_feat_const"

void main()
{
   if (GetIsImmune(GetSpellTargetObject(),IMMUNITY_TYPE_CRITICAL_HIT)) return;

   object oWeap=GetSpellCastItem();

   if (GetBaseItemType(oWeap)!=BASE_ITEM_SHORTSPEAR ) return;


   int nThreat  = 20;

   if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
   {
   nThreat = nThreat - 1;
   }

   if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR) == TRUE)
   {
   nThreat = nThreat - 1;
   }

   int dice=d20();

 int iDiceCritical=2 + (GetHasFeat(FEAT_WEAPON_OF_CHOICE_SHORTSPEAR) && GetHasFeat(FEAT_INCREASE_MULTIPLIER));

     if (dice>=nThreat)
    {
      FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);

      if (GetHasFeat( FEAT_SHOCKING_WEAPON,OBJECT_SELF))
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d10(2),DAMAGE_TYPE_ELECTRICAL,DAMAGE_POWER_NORMAL),GetSpellTargetObject());

      ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d8(2),DAMAGE_TYPE_SONIC,DAMAGE_POWER_NORMAL),GetSpellTargetObject());

    }
}
