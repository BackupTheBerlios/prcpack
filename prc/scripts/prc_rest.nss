#include "heartward_inc"

void main()
{
  if (GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
  {
     object oPC=GetLastPCRested();

     if (GetHasFeat(FEAT_LIPS_RAPTUR,oPC))
     {
      int iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC);
      if (iLips<1)
          iLips=1;
        SetLocalInt(oPC,"FEAT_LIPS_RAPTUR",iLips);
        SendMessageToPC(oPC," Lips of Rapture : use " +IntToString(iLips));

     }
  }
}
