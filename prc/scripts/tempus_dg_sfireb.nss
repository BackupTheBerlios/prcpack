#include "heartward_inc"

void main()
{
    object oPC = GetPCSpeaker();
   if (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_FIREBALL)
        return;

    if(!GetLocalInt(oPC,"WeapEchant1"))
      SetLocalInt(oPC,"WeapEchant1",TEMPUS_ABILITY_FIREBALL);
    else if(!GetLocalInt(oPC,"WeapEchant2"))
      SetLocalInt(oPC,"WeapEchant2",TEMPUS_ABILITY_FIREBALL);

     SetLocalInt(oPC,"TempusPower",GetLocalInt(oPC,"TempusPower")-2);

}
