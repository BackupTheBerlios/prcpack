#include "heartward_inc"

void main()
{
    object oPC = GetPCSpeaker();


    if (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_VAMPIRE)
        return;

    if(!GetLocalInt(oPC,"WeapEchant1"))
      SetLocalInt(oPC,"WeapEchant1",TEMPUS_ABILITY_VAMPIRE);

    SetLocalInt(oPC,"TempusPower",GetLocalInt(oPC,"TempusPower")-3);

}
