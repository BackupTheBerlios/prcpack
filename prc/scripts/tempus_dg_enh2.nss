#include "heartward_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iLvl=GetLevelByClass(CLASS_TYPE_TEMPUS,OBJECT_SELF);

    return (iLvl>5 && GetLocalInt(oPC,"TempusPower")>1);
}

