#include "heartward_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iLvl=GetLevelByClass(CLASS_TYPE_TEMPUS,OBJECT_SELF);

    return (iLvl>1 && GetLocalInt(oPC,"TempusPower"));
}
