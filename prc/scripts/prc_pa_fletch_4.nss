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

#include "prc_feat_const"

void main()
{

 int nHD = GetHitDice(OBJECT_SELF);
 int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
 int nNewXP = GetXP(OBJECT_SELF) - 675;
 int nGold = GetGold(OBJECT_SELF);

 if (nMinXPForLevel > nNewXP || nNewXP == 0 )
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_4);
       return ;
 }
 if (nGold < 6750)
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, FEAT_PA_FLETCH_4);
       return ;
 }


 SetIdentified(CreateItemOnObject("NW_WAMMAR012", OBJECT_SELF, 99), TRUE);
 SetXP(OBJECT_SELF,nNewXP);
 TakeGoldFromCreature(6750, OBJECT_SELF, TRUE);
}
