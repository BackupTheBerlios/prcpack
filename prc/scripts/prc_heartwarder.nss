#include "inc_item_props"
#include "prc_feat_const"

////    bonus CHA    ////
void CharBonus(object oPC ,object oSkin ,int iLevel)
{

  if(GetLocalInt(oSkin, "HeartWardCharBonus") == iLevel) return;

    SetCompositeBonus(oSkin, "HeartWardCharBonus", iLevel, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CHA);

}

/// +2 on CHA based skill /////////
void Heart_Passion(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "HeartPassionA") == iLevel) return;

    SetCompositeBonus(oSkin, "HeartPassionA", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
    SetCompositeBonus(oSkin, "HeartPassionP", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
    SetCompositeBonus(oSkin, "HeartPassionPe", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "HeartPassionT", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_TAUNT);
    SetCompositeBonus(oSkin, "HeartPassionUMD", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_USE_MAGIC_DEVICE);
    SetCompositeBonus(oSkin, "HeartPassionB", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
    SetCompositeBonus(oSkin, "HeartPassionI", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);

}

//// subtype Fey   ////
void Fey_Type(object oPC ,object oSkin )
{
   if(GetLocalInt(oSkin, "FeyType") == 1) return;

   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON),oSkin);
   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON),oSkin);
   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON),oSkin);
   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM),oSkin);

   SetLocalInt(oSkin, "FeyType",1);
}

void LipsRaptur(object oPC)
{

   int iLips=GetLocalInt(oPC,"FEAT_LIPS_RAPTUR");
   if (!iLips)
   {
      iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC)+1;
      if (iLips<2)iLips=1;
      SetLocalInt(oPC,"FEAT_LIPS_RAPTUR",iLips);
      SendMessageToPC(oPC," Lips of Rapture : use " +IntToString(iLips-1));
   }

}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bChar=GetHasFeat(FEAT_CHARISMA_INC1, oPC) ? 1 : 0;
        bChar=GetHasFeat(FEAT_CHARISMA_INC2, oPC) ? 2 : bChar;
        bChar=GetHasFeat(FEAT_CHARISMA_INC3, oPC) ? 3 : bChar;
        bChar=GetHasFeat(FEAT_CHARISMA_INC4, oPC) ? 4 : bChar;
        bChar=GetHasFeat(FEAT_CHARISMA_INC5, oPC) ? 5 : bChar;

    int bHeartP = GetHasFeat(FEAT_HEART_PASSION, oPC) ? 2 : 0;
    int bFey    = GetHasFeat(FEAT_FEY_METAMORPH, oPC) ? 1 : 0;

    if (bChar>0)   CharBonus(oPC, oSkin,bChar);
    if (bHeartP>0) Heart_Passion(oPC, oSkin,bHeartP);
    if (bFey>0)    Fey_Type(oPC ,oSkin );

    if ( GetHasFeat(FEAT_LIPS_RAPTUR, oPC)) LipsRaptur(oPC);




}
