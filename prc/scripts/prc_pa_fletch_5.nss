//::///////////////////////////////////////////////
//:: Peerless Archer Fletching +5
//:: PRC_PA_Fletch_5.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 +5 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: James Tallet
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////
void main()
{

 int nHD = GetHitDice(OBJECT_SELF);
 int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
 int nNewXP = GetXP(OBJECT_SELF) - 1200;
 int nGold = GetGold(OBJECT_SELF);

 if (nMinXPForLevel > nNewXP || nNewXP == 0 )
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       return ;
 }
 if (nGold < 12000)
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       return ;
 }


 CreateItemOnObject("wammar014", OBJECT_SELF, 99);
 SetXP(OBJECT_SELF,nNewXP);
 TakeGoldFromCreature(12000, OBJECT_SELF, TRUE);
}
