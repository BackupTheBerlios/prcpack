//::///////////////////////////////////////////////
//:: [Acolyte of the Skin Feats]
//:: [prc_acolyte.nss]
//:://////////////////////////////////////////////
//:: Check to see which Acolyte of the Skin feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 28, 2003
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

// * Applies the Acolyte's AC bonuses as CompositeBonuses on object's skin.
// * iLevel = integer AC Bonus
void AcolyteFiendSkin(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "AcolyteSkinBonus") == iLevel) return;

    SetCompositeBonus(oSkin, "AcolyteSkinBonus", iLevel, ITEM_PROPERTY_AC_BONUS);
}

// * Applies the Acolyte's damage reduction bonuses as CompositeBonuses on object's skin.
// * iLevel = IP_CONST_DAMAGEREDUCTION_*
void AcolyteSymbiosis(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "AcolyteSymbBonus") == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION, GetLocalInt(oSkin, "AcolyteSymbBonus"), IP_CONST_DAMAGESOAK_20_HP, 1, "AcolyteSymbBonus");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(iLevel, IP_CONST_DAMAGESOAK_20_HP), oSkin);
    SetLocalInt(oSkin, "AcolyteSymbBonus", iLevel);
}

// * Applies the Acolyte's stat bonuses as CompositeBonuses on object's skin.
// * Currently only valid for Con, Dex and Int
// * iLevel = integer stat bonus
// * iStat = IP_CONST_ABILITY_*
void AcolyteStatBonus(object oPC, object oSkin, int iLevel, int iStat)
{
    string sFlag;
    if(iStat == IP_CONST_ABILITY_CON) sFlag = "AcolyteStatBonusCon";
    if(iStat == IP_CONST_ABILITY_DEX) sFlag = "AcolyteStatBonusDex";
    if(iStat == IP_CONST_ABILITY_INT) sFlag = "AcolyteStatBonusInt";

    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    if(iLevel > 0){
        SetCompositeBonus(oSkin, sFlag, iLevel, ITEM_PROPERTY_ABILITY_BONUS, iStat);
        SetLocalInt(oSkin, sFlag, TRUE);
    }
    else {
        SetCompositeBonus(oSkin, sFlag, 0, ITEM_PROPERTY_ABILITY_BONUS, iStat);
        SetLocalInt(oSkin, sFlag, FALSE);
   }
}

// * Applies the Acolyte's resistance bonuses as CompositeBonuses on object's skin.
// * Currently only valid for Cold, Fire, Acid and Electric
// * Resistance level is hardcodded to 20
// * iType = IP_CONST_DAMAGETYPE_*
void AcolyteResistance(object oPC, object oSkin, int iType)
{
    string sFlag;
    if(iType == IP_CONST_DAMAGETYPE_COLD) sFlag = "AcolyteResistanceCold";
    if(iType == IP_CONST_DAMAGETYPE_FIRE) sFlag = "AcolyteResistanceFire";
    if(iType == IP_CONST_DAMAGETYPE_ACID) sFlag = "AcolyteResistanceAcid";
    if(iType == IP_CONST_DAMAGETYPE_ELECTRICAL) sFlag = "AcolyteResistanceElectric";

    if(GetLocalInt(oSkin, sFlag) == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(iType, IP_CONST_DAMAGERESIST_20), oSkin);
    SetLocalInt(oSkin, sFlag, TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;

    int bFSkin = GetHasFeat(FEAT_WEAR_FIEND, oPC)           ? 1 : 0;
        bFSkin = GetHasFeat(FEAT_SKIN_ADAPTION, oPC)        ? 2 : bFSkin;

    int bSymbi = GetHasFeat(FEAT_SYMBIOSIS, oPC)            ? IP_CONST_DAMAGEREDUCTION_1  : -1;
        bSymbi = GetHasFeat(FEAT_EPIC_SYMBIOSIS_1, oPC)     ? IP_CONST_DAMAGEREDUCTION_2  : bSymbi;
        bSymbi = GetHasFeat(FEAT_EPIC_SYMBIOSIS_2, oPC)     ? IP_CONST_DAMAGEREDUCTION_3  : bSymbi;
        bSymbi = GetHasFeat(FEAT_EPIC_SYMBIOSIS_3, oPC)     ? IP_CONST_DAMAGEREDUCTION_4  : bSymbi;
        bSymbi = GetHasFeat(FEAT_EPIC_SYMBIOSIS_4, oPC)     ? IP_CONST_DAMAGEREDUCTION_5  : bSymbi;

    int bStCon = GetHasFeat(FEAT_SKIN_ADAPTION, oPC)        ? 2 : 0;
        bStCon = GetHasFeat(FEAT_EPIC_CON_1, oPC)           ? 4 : bStCon;
        bStCon = GetHasFeat(FEAT_EPIC_CON_2, oPC)           ? 6 : bStCon;
        bStCon = GetHasFeat(FEAT_EPIC_CON_3, oPC)           ? 8 : bStCon;

    int bStDex = GetHasFeat(FEAT_WEAR_FIEND, oPC)           ? 2 : 0;

    int bStInt = GetHasFeat(FEAT_EPIC_INT_1, oPC)           ? 2 : 0;
        bStInt = GetHasFeat(FEAT_EPIC_INT_2, oPC)           ? 4 : bStInt;

    int bResCo = GetHasFeat(FEAT_COLD_RESISTANT, oPC);
    int bResFl = GetHasFeat(FEAT_FLAME_RESISTANT, oPC);
    int bResAc = GetHasFeat(FEAT_ACID_RESISTANT, oPC);
    int bResEl = GetHasFeat(FEAT_ELEC_RESISTANT, oPC);

    object oSkin = GetPCSkin(oPC);

    if(bFSkin > 0) AcolyteFiendSkin(oPC, oSkin, bFSkin);
    //NOT IMPLEMENTED if(bFKnow > 0) AcolyteFiendishKnowledge(oPC, oSkin, bFKnow);
    if(bSymbi > -1) AcolyteSymbiosis(oPC, oSkin, bSymbi);
    if(bStCon > 0) AcolyteStatBonus(oPC, oSkin, bStCon, IP_CONST_ABILITY_CON);
    if(bStDex > 0) AcolyteStatBonus(oPC, oSkin, bStDex, IP_CONST_ABILITY_DEX);
    if(bStInt > 0) AcolyteStatBonus(oPC, oSkin, bStInt, IP_CONST_ABILITY_INT);
    if(bResCo) AcolyteResistance(oPC, oSkin, IP_CONST_DAMAGETYPE_COLD);
    if(bResFl) AcolyteResistance(oPC, oSkin, IP_CONST_DAMAGETYPE_FIRE);
    if(bResAc) AcolyteResistance(oPC, oSkin, IP_CONST_DAMAGETYPE_ACID);
    if(bResEl) AcolyteResistance(oPC, oSkin, IP_CONST_DAMAGETYPE_ELECTRICAL);
}
