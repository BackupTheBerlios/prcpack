//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +2
//:: PRC_PA_Fletch_2.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +2 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: James Tallet
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////
void main()
{

 int nHD = GetHitDice(OBJECT_SELF);
 int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
 int nNewXP = GetXP(OBJECT_SELF) - 80;
 int nGold = GetGold(OBJECT_SELF);

 if (nMinXPForLevel > nNewXP || nNewXP == 0 )
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       return ;
 }
 if (nGold < 800)
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       return ;
 }


 CreateItemOnObject("wammar011", OBJECT_SELF, 99);
 SetXP(OBJECT_SELF,nNewXP);
 TakeGoldFromCreature(800, OBJECT_SELF, TRUE);
}
