#include "inc_item_props"
#include "strat_prc_inc"
#include "prc_dg_inc"
#include "heartward_inc"

////    bonus CHA    ////
void CharBonus(object oPC ,object oSkin ,int iLevel)
{

  if(GetLocalInt(oSkin, "HeartWardCharBonus") == iLevel) return;

    SetCompositeBonus(oSkin, "HeartWardCharBonus", iLevel, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CHA);

}

/// +2 on CHA based skill /////////
void Heart_Passion(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "HeartPassion") == iLevel) return;

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

void Lips_Rapture(object oPC)
{
  object oRod=GetItemPossessedBy(oPC,"RodofLipsRapture");
  if (oRod==OBJECT_INVALID)
  {
     oRod=CreateItemOnObject("RodofLipsRapture",oPC);
     int iUse=GetAbilityModifier(ABILITY_CHARISMA,oPC);

    while (iUse>5)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY),oRod);
        iUse-=5;
    }

     switch (iUse)
    {
        case 1:
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oRod);
            break;
        case 2:
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY),oRod);
            break;
        case 3:
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY),oRod);
            break;
        case 4:
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY),oRod);
            break;
        case 5:
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIPS_RAPTURE_1,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY),oRod);
            break;
    }
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
    int bLipsR  = GetHasFeat(FEAT_LIPS_RAPTUR, oPC)   ? 1 : 0;
//    int bVoiceS = GetHasFeat(FEAT_VOICE_SIREN, oPC)   ? 1 : 0;
//    int bTearsE = GetHasFeat(FEAT_TEARS_EVERGOLD, oPC)? 1 : 0;
    int bFey    = GetHasFeat(FEAT_FEY_METAMORPH, oPC) ? 1 : 0;

    if (bChar>0)   CharBonus(oPC, oSkin,bChar);
    if (bHeartP>0) Heart_Passion(oPC, oSkin,bHeartP);
    if (bFey>0)    Fey_Type(oPC ,oSkin );

    if (bLipsR>0) Lips_Rapture(oPC);



}
