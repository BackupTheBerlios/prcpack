#include "heartward_inc"

void main()
{
    object oPC = GetPCSpeaker();

    if (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_ENHANC3)
        return;

    if(!GetLocalInt(oPC,"WeapEchant1"))
      SetLocalInt(oPC,"WeapEchant1",TEMPUS_ABILITY_ENHANC3);

    SetLocalInt(oPC,"TempusPower",GetLocalInt(oPC,"TempusPower")-3);

}
