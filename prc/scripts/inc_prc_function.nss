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
//:: places.
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

#include "prc_dg_inc"
#include "discipleinclude"
#include "strat_prc_inc"
#include "heartward_inc"
// Gets the racial type (RACIAL_TYPE_*) of oCreature
// * Return value if oCreature is not a valid creature: RACIAL_TYPE_INVALID
// This function includes changes via levels of classes (like the lich)
// If you want to set a race dynamicaly set a local called "RACIAL_TYPE"
// NOTE "RACIAL_TYPE" must be RACIAL_TYPE_* + 1, because we use 0 as meaning it
// is not set but a zero == RACIAL_TYPE_DWARF
int MyPRCGetRacialType(object oCreature);

// * Check to see which custom PRCs oPC has and apply the proper feat bonuses
void EvalPRCFeats(object oPC);

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
}

// This is required if you want your skin effects to work with the shifter
// The shifter skin is wiped when it returns to normal form
// Any locals you use for your skin should be added to this list
void DeletePRCLocalInts(object oSkin);
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
// heartWarder
    DeleteLocalInt(oSkin,"HeartPassion");
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

//--------------------------------------------------------
//Miscellaneous PRC Functions
//--------------------------------------------------------

// * Hierophant Spell-Like abilities have some problems that need to be corrected
// * during spell casting.  This function checks to see if the spell that triggered
// * a particular script was a Hierophant SLA.
int GetWasLastSpellHieroSLA();

// * Adjust DC and Spell Pen for spell power feats.  Hierophants and Archmages get these.
int GetSpellPowerBonus(object oCaster);

// * Finds the difference between alignment of oSource and oTarget
// * returns the number of steps between the two
// * i.e. Good compared to Evil = 2 steps
int CompareAlignment(object oSource, object oTarget);

// * This function will check to see if a spell should be maximized by
// * the Hierophant's Faith Healing or Blast Infidel feats.
// * oCaster = Object casting the spell
// * oTarget = Object being targetted
// * iEnergyType = DAMAGE_TYPE_* (POSITIVE for healing, or NEGATIVE for Neg Energy spells
// * iDisplay = TRUE/FALSE (Whether or not to show feedback)
int BlastInfidelOrFaithHeal(object oCaster, object oTarget, int iEnergyType, int iDisplayFeedback);

//Check that the character has Hierophant levels, that the last
//spell cast was an ability (i.e. accessed from class abilities), and
//that the spell was on the list of Hierophant SLAs.  It's not a perfect
//test, but it should work 99.9% of the time.
int GetWasLastSpellHieroSLA()
{
    int iAbility = GetLastSpellCastClass() == CLASS_TYPE_INVALID;
    int iClass   = GetLevelByClass(CLASS_TYPE_HIEROPHANT, OBJECT_SELF) > 0;
    int iSpell   = GetSpellId() == SPELL_HOLY_AURA ||
                   GetSpellId() == SPELL_UNHOLY_AURA ||
                   GetSpellId() == SPELL_BANISHMENT ||
                   GetSpellId() == SPELL_BATTLETIDE ||
                   GetSpellId() == SPELL_BLADE_BARRIER ||
                   GetSpellId() == SPELL_CIRCLE_OF_DOOM ||
                   GetSpellId() == SPELL_CONTROL_UNDEAD ||
                   GetSpellId() == SPELL_CREATE_GREATER_UNDEAD ||
                   GetSpellId() == SPELL_CREATE_UNDEAD ||
                   GetSpellId() == SPELL_CURE_CRITICAL_WOUNDS ||
                   GetSpellId() == SPELL_DEATH_WARD ||
                   GetSpellId() == SPELL_DESTRUCTION ||
                   GetSpellId() == SPELL_DISMISSAL ||
                   GetSpellId() == SPELL_DIVINE_POWER ||
                   GetSpellId() == SPELL_EARTHQUAKE ||
                   GetSpellId() == SPELL_ENERGY_DRAIN ||
                   GetSpellId() == SPELL_ETHEREALNESS ||
                   GetSpellId() == SPELL_FIRE_STORM ||
                   GetSpellId() == SPELL_FLAME_STRIKE ||
                   GetSpellId() == SPELL_FREEDOM_OF_MOVEMENT ||
                   GetSpellId() == SPELL_GATE ||
                   GetSpellId() == SPELL_GREATER_DISPELLING ||
                   GetSpellId() == SPELL_GREATER_MAGIC_WEAPON ||
                   GetSpellId() == SPELL_GREATER_RESTORATION ||
                   GetSpellId() == SPELL_HAMMER_OF_THE_GODS ||
                   GetSpellId() == SPELL_HARM ||
                   GetSpellId() == SPELL_HEAL ||
                   GetSpellId() == SPELL_HEALING_CIRCLE ||
                   GetSpellId() == SPELL_IMPLOSION ||
                   GetSpellId() == SPELL_INFLICT_CRITICAL_WOUNDS ||
                   GetSpellId() == SPELL_MASS_HEAL ||
                   GetSpellId() == SPELL_MONSTROUS_REGENERATION ||
                   GetSpellId() == SPELL_NEUTRALIZE_POISON ||
                   GetSpellId() == SPELL_PLANAR_ALLY ||
                   GetSpellId() == SPELL_POISON ||
                   GetSpellId() == SPELL_RAISE_DEAD ||
                   GetSpellId() == SPELL_REGENERATE ||
                   GetSpellId() == SPELL_RESTORATION ||
                   GetSpellId() == SPELL_RESURRECTION ||
                   GetSpellId() == SPELL_SLAY_LIVING ||
                   GetSpellId() == SPELL_SPELL_RESISTANCE ||
                   GetSpellId() == SPELL_STORM_OF_VENGEANCE ||
                   GetSpellId() == SPELL_SUMMON_CREATURE_IV ||
                   GetSpellId() == SPELL_SUMMON_CREATURE_IX ||
                   GetSpellId() == SPELL_SUMMON_CREATURE_V ||
                   GetSpellId() == SPELL_SUMMON_CREATURE_VI ||
                   GetSpellId() == SPELL_SUMMON_CREATURE_VII ||
                   GetSpellId() == SPELL_SUMMON_CREATURE_VIII ||
                   GetSpellId() == SPELL_SUNBEAM ||
                   GetSpellId() == SPELL_TRUE_SEEING ||
                   GetSpellId() == SPELL_UNDEATH_TO_DEATH ||
                   GetSpellId() == SPELL_UNDEATHS_ETERNAL_FOE ||
                   GetSpellId() == SPELL_WORD_OF_FAITH;

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

//Return the number of steps difference on the alignment
//chart between oSource and oTarget
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

//Check to see if oTarget will be healed or hurt by iEnergyType.
//Then check to see if oTarget is of an appropriate alignment compared
//to oCaster for either Blast Infidel or Faith Healing to work.
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

int MyPRCGetRacialType(object oCreature)
{
    // Determine if they have a class that makes them another racial type
    // level 4 lich is undead
    if (GetLevelByClass(CLASS_TYPE_LICH,oCreature) >= 4)
        return RACIAL_TYPE_UNDEAD;
    if (GetLevelByClass(CLASS_TYPE_MONK,oCreature) >= 20)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_OOZEMASTER,oCreature) >= 10)
        return RACIAL_TYPE_OOZE;
    if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE,oCreature) >= 10)
        return RACIAL_TYPE_DRAGON;
    if (GetLevelByClass(CLASS_TYPE_ACOLYTE,oCreature) >= 10)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_ES_FIRE,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_COLD,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ELEC,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ACID,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_HEARTWARDER,oCreature) >= 10)
        return RACIAL_TYPE_FEY;
    // check for a local variable that overrides the race
    // the shifter will use this everytime they change
    // the racial types are zero based, use 1 based to ensure the variable is set
    int nRace = GetLocalInt(oCreature,"RACIAL_TYPE");
    if (nRace)
        return (nRace-1);
    return GetRacialType(oCreature);
}
