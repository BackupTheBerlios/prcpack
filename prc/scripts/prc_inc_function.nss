//::///////////////////////////////////////////////
//:: [PRC Feat Router]
//:: [inc_prc_function.nss]
//:://////////////////////////////////////////////
//:: This file serves as a hub for the various
//:: PRC passive feat functions.  If you need to
//:: add passive feats for a new PRC, link them here.
//::
//:: This file also contains a few multi-purpose
//:: PRC functions that need to be included in several
//:: places, ON DIFFERENT PRCS. Make local include files
//:: for any functions you use ONLY on ONE PRC.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 19, 2003
//:://////////////////////////////////////////////

//--------------------------------------------------------------------------
// This is the "event" that is called to re-evalutate PRC bonuses.  Currently
// it is fired by OnEquip, OnUnequip and OnLevel.  If you want to move any
// classes into this event, just copy the format below.  Basically, this function
// is meant to keep the code looking nice and clean by routing each class's
// feats to their own self-contained script
//--------------------------------------------------------------------------

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_alterations"
#include "prc_inc_oni"



void EvalPRCFeats(object oPC)
{
    //Elemental savant is sort of four classes in one, so we'll take care
    //of them all at once.
    int iElemSavant =  GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_COLD, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_ACID, oPC);

    //Route the event to the appropriate class specific scripts
    if(GetLevelByClass(CLASS_TYPE_DUELIST, oPC) > 0)            ExecuteScript("prc_duelist", oPC);
    if(GetLevelByClass(CLASS_TYPE_ACOLYTE, oPC) > 0)            ExecuteScript("prc_acolyte", oPC);
    if(GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC) > 0)         ExecuteScript("prc_spellswd", oPC);
    if(GetLevelByClass(CLASS_TYPE_MAGEKILLER, oPC) > 0)         ExecuteScript("prc_magekill", oPC);
    if(GetLevelByClass(CLASS_TYPE_OOZEMASTER, oPC) > 0)         ExecuteScript("prc_oozemstr", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_MEPH, oPC) > 0)   ExecuteScript("prc_discmeph", oPC);
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)               ExecuteScript("pnp_lich_level", oPC);
    if(iElemSavant > 0)                                         ExecuteScript("prc_elemsavant", oPC);
    if(GetLevelByClass(CLASS_TYPE_HEARTWARDER,oPC) > 0)         ExecuteScript("prc_heartwarder", oPC);
    if(GetLevelByClass(CLASS_TYPE_STORMLORD,oPC) > 0)           ExecuteScript("prc_stormlord", oPC);
    if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER ,oPC) > 0)        ExecuteScript("prc_shifter", oPC);
    if(GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE,oPC) > 0)      ExecuteScript("prc_knghtch", oPC);
    if(GetLevelByClass(CLASS_TYPE_FRE_BERSERKER, oPC) > 0)      ExecuteScript("prc_frebzk", oPC);
    if(GetLevelByClass(CLASS_TYPE_TEMPEST, oPC) > 0)            ExecuteScript("prc_tempest", oPC);    
}



void DeletePRCLocalInts(object oSkin)
{
    // In order to work with the PRC system we need to delete some locals for each
    // PRC that has a hide
    // Duelist
    DeleteLocalInt(oSkin,"DiscMephResist");
    DeleteLocalInt(oSkin,"GraceBonus");
    DeleteLocalInt(oSkin,"ElaborateParryBonus");
    DeleteLocalInt(oSkin,"CannyDefenseBonus");
    // Elemental Savants
    DeleteLocalInt(oSkin,"ElemSavantResist");
    DeleteLocalInt(oSkin,"ElemSavantPerfection");
    DeleteLocalInt(oSkin,"ElemSavantImmMind");
    DeleteLocalInt(oSkin,"ElemSavantImmParal");
    DeleteLocalInt(oSkin,"ElemSavantImmSleep");
    // HeartWarder
    DeleteLocalInt(oSkin, "HeartPassionA");
    DeleteLocalInt(oSkin, "HeartPassionP");
    DeleteLocalInt(oSkin, "HeartPassionPe");
    DeleteLocalInt(oSkin, "HeartPassionT");
    DeleteLocalInt(oSkin, "HeartPassionUMD");
    DeleteLocalInt(oSkin, "HeartPassionB");
    DeleteLocalInt(oSkin, "HeartPassionI");
    DeleteLocalInt(oSkin,"FeyType");
    // MageKiller
    DeleteLocalInt(oSkin,"MKFortBonus");
    DeleteLocalInt(oSkin,"MKRefBonus");
    // Master Harper
    DeleteLocalInt(oSkin,"MHLycanbane");
    DeleteLocalInt(oSkin,"MHMililEar");
    DeleteLocalInt(oSkin,"MHDeneirsOrel");
    // OozeMaster
    DeleteLocalInt(oSkin,"OozeChaPen");
    DeleteLocalInt(oSkin,"IndiscernibleCrit");
    DeleteLocalInt(oSkin,"IndiscernibleBS");
    DeleteLocalInt(oSkin,"OneOozeMind");
    DeleteLocalInt(oSkin,"OneOozePoison");
    // Storm lord
    DeleteLocalInt(oSkin,"StormLResElec");
    // Spell sword
    DeleteLocalInt(oSkin,"SpellswordSFBonusNormal");
    DeleteLocalInt(oSkin,"SpellswordSFBonusEpic");
    // Acolyte of the skin
    DeleteLocalInt(oSkin,"AcolyteSkinBonus");
    DeleteLocalInt(oSkin,"AcolyteSymbBonus");
    DeleteLocalInt(oSkin,"AcolyteStatBonusCon");
    DeleteLocalInt(oSkin,"AcolyteStatBonusDex");
    DeleteLocalInt(oSkin,"AcolyteStatBonusInt");
    DeleteLocalInt(oSkin,"AcolyteResistanceCold");
    DeleteLocalInt(oSkin,"AcolyteResistanceFire");
    DeleteLocalInt(oSkin,"AcolyteResistanceAcid");
    DeleteLocalInt(oSkin,"AcolyteResistanceElectric");
    DeleteLocalInt(oSkin,"AcolyteStatBonusDex");
    // future PRCs Go below here
}



int GetWasLastSpellHieroSLA()
{
    int iAbility = GetLastSpellCastClass() == CLASS_TYPE_INVALID;
    int iClass   = GetLevelByClass(CLASS_TYPE_HIEROPHANT, OBJECT_SELF) > 0;
    int iSpellID = GetSpellId();
    int iSpell   = iSpellID == SPELL_HOLY_AURA ||
                   iSpellID == SPELL_UNHOLY_AURA ||
                   iSpellID == SPELL_BANISHMENT ||
                   iSpellID == SPELL_BATTLETIDE ||
                   iSpellID == SPELL_BLADE_BARRIER ||
                   iSpellID == SPELL_CIRCLE_OF_DOOM ||
                   iSpellID == SPELL_CONTROL_UNDEAD ||
                   iSpellID == SPELL_CREATE_GREATER_UNDEAD ||
                   iSpellID == SPELL_CREATE_UNDEAD ||
                   iSpellID == SPELL_CURE_CRITICAL_WOUNDS ||
                   iSpellID == SPELL_DEATH_WARD ||
                   iSpellID == SPELL_DESTRUCTION ||
                   iSpellID == SPELL_DISMISSAL ||
                   iSpellID == SPELL_DIVINE_POWER ||
                   iSpellID == SPELL_EARTHQUAKE ||
                   iSpellID == SPELL_ENERGY_DRAIN ||
                   iSpellID == SPELL_ETHEREALNESS ||
                   iSpellID == SPELL_FIRE_STORM ||
                   iSpellID == SPELL_FLAME_STRIKE ||
                   iSpellID == SPELL_FREEDOM_OF_MOVEMENT ||
                   iSpellID == SPELL_GATE ||
                   iSpellID == SPELL_GREATER_DISPELLING ||
                   iSpellID == SPELL_GREATER_MAGIC_WEAPON ||
                   iSpellID == SPELL_GREATER_RESTORATION ||
                   iSpellID == SPELL_HAMMER_OF_THE_GODS ||
                   iSpellID == SPELL_HARM ||
                   iSpellID == SPELL_HEAL ||
                   iSpellID == SPELL_HEALING_CIRCLE ||
                   iSpellID == SPELL_IMPLOSION ||
                   iSpellID == SPELL_INFLICT_CRITICAL_WOUNDS ||
                   iSpellID == SPELL_MASS_HEAL ||
                   iSpellID == SPELL_MONSTROUS_REGENERATION ||
                   iSpellID == SPELL_NEUTRALIZE_POISON ||
                   iSpellID == SPELL_PLANAR_ALLY ||
                   iSpellID == SPELL_POISON ||
                   iSpellID == SPELL_RAISE_DEAD ||
                   iSpellID == SPELL_REGENERATE ||
                   iSpellID == SPELL_RESTORATION ||
                   iSpellID == SPELL_RESURRECTION ||
                   iSpellID == SPELL_SLAY_LIVING ||
                   iSpellID == SPELL_SPELL_RESISTANCE ||
                   iSpellID == SPELL_STORM_OF_VENGEANCE ||
                   iSpellID == SPELL_SUMMON_CREATURE_IV ||
                   iSpellID == SPELL_SUMMON_CREATURE_IX ||
                   iSpellID == SPELL_SUMMON_CREATURE_V ||
                   iSpellID == SPELL_SUMMON_CREATURE_VI ||
                   iSpellID == SPELL_SUMMON_CREATURE_VII ||
                   iSpellID == SPELL_SUMMON_CREATURE_VIII ||
                   iSpellID == SPELL_SUNBEAM ||
                   iSpellID == SPELL_TRUE_SEEING ||
                   iSpellID == SPELL_UNDEATH_TO_DEATH ||
                   iSpellID == SPELL_UNDEATHS_ETERNAL_FOE ||
                   iSpellID == SPELL_WORD_OF_FAITH;

    return iClass && iAbility && iSpell;
}

int GetSpellPowerBonus(object oCaster)
{
    int nBonus = 0;

    if(GetHasFeat(FEAT_SPELLPOWER_10, OBJECT_SELF))
        nBonus += 10;
    else if(GetHasFeat(FEAT_SPELLPOWER_8, OBJECT_SELF))
        nBonus += 8;
    else if(GetHasFeat(FEAT_SPELLPOWER_6, OBJECT_SELF))
        nBonus += 6;
    else if(GetHasFeat(FEAT_SPELLPOWER_4, OBJECT_SELF))
        nBonus += 4;
    else if(GetHasFeat(FEAT_SPELLPOWER_2, OBJECT_SELF))
        nBonus += 2;

    return nBonus;
}


int CompareAlignment(object oSource, object oTarget)
{
    int iStepDif;
    int iGE1 = GetAlignmentGoodEvil(oSource);
    int iLC1 = GetAlignmentLawChaos(oSource);
    int iGE2 = GetAlignmentGoodEvil(oTarget);
    int iLC2 = GetAlignmentLawChaos(oTarget);

    if(iGE1 == ALIGNMENT_GOOD){
        if(iGE2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iGE2 == ALIGNMENT_EVIL)
            iStepDif += 2;
    }
    if(iGE1 == ALIGNMENT_NEUTRAL){
        if(iGE2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iGE1 == ALIGNMENT_EVIL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_GOOD)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_LAWFUL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_CHAOTIC)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_NEUTRAL){
        if(iLC2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iLC1 == ALIGNMENT_CHAOTIC){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_LAWFUL)
            iStepDif += 2;
    }
    return iStepDif;
}

int BlastInfidelOrFaithHeal(object oCaster, object oTarget, int iEnergyType, int iDisplayFeedback)
{
    //Don't bother doing anything if iEnergyType isn't either positive/negative energy
    if(iEnergyType != DAMAGE_TYPE_POSITIVE && iEnergyType != DAMAGE_TYPE_NEGATIVE)
        return FALSE;

    //If the target is undead and damage type is negative
    //or if the target is living and damage type is positive
    //then we're healing.  Otherwise, we're harming.
    int iHeal = ( MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && iEnergyType == DAMAGE_TYPE_NEGATIVE ) ||
                ( MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && iEnergyType == DAMAGE_TYPE_POSITIVE );
    int iRetVal = FALSE;
    int iAlignDif = CompareAlignment(oCaster, oTarget);
    string sFeedback = "";

    if(iHeal){
        if((GetHasFeat(FEAT_FAITH_HEALING, oCaster) && iAlignDif <= 2)){
            iRetVal = TRUE;
            sFeedback = "Faith Healing";
        }
    }
    else{
        if((GetHasFeat(FEAT_BLAST_INFIDEL, oCaster) && iAlignDif >= 2)){
            iRetVal = TRUE;
            sFeedback = "Blast Infidel";
        }
    }

    if(iDisplayFeedback) FloatingTextStringOnCreature(sFeedback, oCaster);
    return iRetVal;
}

/*
int MyPRCGetRacialType(object oCreature)
{
	THIS CODE IS IN prc_alteration
} */

void CheckSpecialPRCRecs(object oPC)
{
    //Check if the player meets the requirement for the Knight of the Chalice
    //i.e. Can cast Protection from Evil

    /*  Talent functions seem to be bugged.  So the inferior function
     *  Below will need to suffice until BW fixes this
    talent protAlign = TalentSpell(321);
    if(GetCreatureHasTalent(protAlign, oPC))
        SetLocalInt(oPC, "PRC_KnghtCh", 1);
     */

    //This function is unreliable at best for Wizards as they
    //would need to have Protection from Alignment memorized upon
    //leveling up for it to work.  It should work for Sorcerers
    //and Bards though, since they automatically memorize spells.
    int iClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    int iPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
    int iWisdomBonus = GetAbilityModifier(ABILITY_WISDOM);
    int bHasSpell = FALSE;

    if(iClericLevel >= 0) bHasSpell = TRUE;
    if((iPaladinLevel >= 4 && iWisdomBonus >= 1) || (iPaladinLevel >= 6)) bHasSpell = TRUE;
    if(GetHasSpell(321, oPC)) bHasSpell = TRUE;

    if(bHasSpell)
        SetLocalInt(oPC, "PRC_KnghtCh", 1);

}


