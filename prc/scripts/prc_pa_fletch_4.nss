//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +4
//:: PRC_PA_Fletch_4.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +4 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: James Tallet
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////
void main()
{

 int nHD = GetHitDice(OBJECT_SELF);
 int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
 int nNewXP = GetXP(OBJECT_SELF) - 675;
 int nGold = GetGold(OBJECT_SELF);

 if (nMinXPForLevel > nNewXP || nNewXP == 0 )
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       return ;
 }
 if (nGold < 6750)
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       return ;
 }


 CreateItemOnObject("wammar013", OBJECT_SELF, 99);
 SetXP(OBJECT_SELF,nNewXP);
 TakeGoldFromCreature(6750, OBJECT_SELF, TRUE);
}
