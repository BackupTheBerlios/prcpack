//::///////////////////////////////////////////////
//:: [Spellsword Feats]
//:: [prc_spellswd.nss]
//:://////////////////////////////////////////////
//:: Check to see which Spellsword feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.  Modified by Aaon Graywolf
//:: Created On: Dec 28, 2003
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

// * Applies the Spellsword's Spell Failure reduction on object's skin.
// * iLevel = IP_CONST_ARCANE_SPELL_FAILURE_*
// * sFlag = Flag to check whether the property has already been added
void SpellswordIgnoreSpellFailure(object oPC, object oSkin, int iLevel, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, GetLocalInt(oSkin, sFlag), 1, sFlag);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyArcaneSpellFailure(iLevel), oSkin);
    SetLocalInt(oSkin, sFlag, iLevel);
}

void main()
{
    object oPC = OBJECT_SELF;

    int bSpells = GetHasFeat(FEAT_SPELLS_1, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT : 0;
        bSpells = GetHasFeat(FEAT_SPELLS_2, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT : bSpells;
        bSpells = GetHasFeat(FEAT_SPELLS_3, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT : bSpells;
        bSpells = GetHasFeat(FEAT_SPELLS_4, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT : bSpells;
        bSpells = GetHasFeat(FEAT_SPELLS_5, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT : bSpells;
        bSpells = GetHasFeat(FEAT_SPELLS_6, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT : bSpells;
        bSpells = GetHasFeat(FEAT_SPELLS_7, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT : bSpells;
        bSpells = GetHasFeat(FEAT_SPELLS_8, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT : bSpells;
        bSpells = GetHasFeat(FEAT_SPELLS_9, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT : bSpells;

    int bSpells2 = GetHasFeat(FEAT_SPELLS_10, oPC) ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT  : 0;
        bSpells2 = GetHasFeat(FEAT_SPELLS_11, oPC) ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT : bSpells2;
        bSpells2 = GetHasFeat(FEAT_SPELLS_12, oPC) ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT : bSpells2;
        bSpells2 = GetHasFeat(FEAT_SPELLS_13, oPC) ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT : bSpells2;
        bSpells2 = GetHasFeat(FEAT_SPELLS_14, oPC) ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT : bSpells2;
        bSpells2 = GetHasFeat(FEAT_SPELLS_15, oPC) ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT : bSpells2;

    object oSkin = GetPCSkin(oPC);

    if(bSpells > 0)  SpellswordIgnoreSpellFailure(oPC, oSkin, bSpells, "SpellswordSFBonusNormal");
    if(bSpells2 > 0) SpellswordIgnoreSpellFailure(oPC, oSkin, bSpells, "SpellswordSFBonusEpic");
}
