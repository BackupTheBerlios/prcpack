#include "heartward_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iLvl=GetLevelByClass(CLASS_TYPE_TEMPUS,OBJECT_SELF);

    return (iLvl>9 && GetLocalInt(oPC,"TempusPower")>2);
}

