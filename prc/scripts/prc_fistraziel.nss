//#include "heartward_inc"
#include "ft_martialstrike"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bMartialS = GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE, oPC) ?  1: 0;

    if (bMartialS>0) MartialStrike();



}
