#include "inc_item_props"
#include "prc_feat_const"

/// +3 on Craft Weapon /////////
void Expert_Bowyer(object oPC ,object oSkin ,int nBowyer)
{

   if(GetLocalInt(oSkin, "PABowyer") == nBowyer) return;

    SetCompositeBonus(oSkin, "PABowyer", nBowyer, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int nBowyer = GetHasFeat(FEAT_EXPERT_BOWYER, oPC) ? 3 : 0;


    if (nBowyer>0) Expert_Bowyer(oPC, oSkin, nBowyer);
}
