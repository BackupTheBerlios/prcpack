#include "heartward_inc"
#include "inc_item_props"

void LipsRap(object oPC,int iUse,object oRod)
{
  while (iUse>5)
  {
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY),oRod);
    iUse-=5;
  }

  switch (iUse)
  {
    case 1:
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oRod);
      break;
    case 2:
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY),oRod);
     break;
   case 3:
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),oRod);
     break;
   case 4:
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY),oRod);
     break;
   case 5:
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY),oRod);
     break;
  }
}

void main()
{
  if (GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
  {
     object oPC=GetLastPCRested();

     if (GetHasFeat(FEAT_LIPS_RAPTUR,oPC))
     {
       object oRod=GetItemPossessedBy(oPC,"RodofLipsRapture");
       TotalAndRemoveProperty(oRod,ITEM_PROPERTY_CAST_SPELL);
       int iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC);
       if (iLips>0)
        LipsRap(oPC,iLips,oRod);
     }

   }
}
