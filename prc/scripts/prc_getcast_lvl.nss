#include "prc_dg_inc"
#include "strat_prc_inc"
#include "discipleinclude"
#include "inc_prc_function"
#include "heartward_inc"


int  TYPE_ARCANE = 1;
int  TYPE_DIVINE = 2;

int GetCasterLvl(int iTypeSpell)
{


object oCaster = OBJECT_SELF;
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// This is the section where you declare any + 1 caster level prc's and the amount
// of casting levels they should add
//////////////////////////////////////////////////////////////////////////////////

int nDivine;
int nArcane;

int nDruid=GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
int nCleric=GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
int nPaladin=GetLevelByClass(CLASS_TYPE_PALADIN, oCaster);
int nRanger=GetLevelByClass(CLASS_TYPE_RANGER, oCaster);

int nSorcerer=GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
int nWizard=GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
int nBard=GetLevelByClass(CLASS_TYPE_BARD, oCaster);

nDivine = (nDruid>nCleric)   ? nDivine :  nCleric ;
nDivine = (nDivine>nPaladin) ? nDivine :  nPaladin ;
nDivine = (nDivine>nRanger)  ? nDivine :  nRanger ;

nArcane = (nSorcerer>nWizard)? nSorcerer :  nWizard ;
nArcane = (nArcane>nBard)    ? nArcane   : nBard ;






// Determine how many caster levels of Pale Master are added to oCaster's arcane spells.
int nPaleMasterLevels = GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster);
if(nPaleMasterLevels > 0) nPaleMasterLevels = (nPaleMasterLevels - 1) / 2 + 1;

/******************* DarkGod PrC ********************/

/* Archmages */
int nArchmageLevels = GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster);

/* Spell Power feats */
int nSpellPowerLevels = 0;
if (GetHasFeat(FEAT_SPELL_POWER_V)) nSpellPowerLevels = 5;
else if (GetHasFeat(FEAT_SPELL_POWER_IV)) nSpellPowerLevels = 4;
else if (GetHasFeat(FEAT_SPELL_POWER_III)) nSpellPowerLevels = 3;
else if (GetHasFeat(FEAT_SPELL_POWER_II)) nSpellPowerLevels = 2;
else if (GetHasFeat(FEAT_SPELL_POWER_I)) nSpellPowerLevels = 1;

/* Oozemasters */
int nOozemasterLevels = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) / 2;

/******************* Stratovarius PrC ********************/

int nMageKillerLevels = GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster);
int nHarperLevels = GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster);
int nSpellswordLevels = GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) / 2;
int nAcolyteLevels = GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) / 2;
int nEldritchLevels = GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster);
int nFireLevels = GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster);
int nColdLevels = GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster);
int nElecLevels = GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster);
int nAcidLevels = GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster);
int nFireAdept = GetHasFeat(FEAT_FIRE_ADEPT, oCaster);
int nBondedSumm = GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster)/2;


int nHeartWLevels = GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster);
int nStormlord    = GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
int nFistRaziel   = GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)>0 ? GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)-1:0;
int nTempus       = GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster)/2;

/////////////////////////////////////////////////////////////////////////////////
// INSTRUCTIONS
//
// If you want to add more +1 caster level prc's, declare them above
// and sort out the exact number of caster levels each one should add
// then add that amount to the appropriate category below.
// -> either add the amount to nArcaneCastLevels or to nDivineCastLevels, depending
//    on which kind of class it affects.
//////////////////////////////////////////////////////////////////////////////////


int nArcaneCastLevels = nArcane +
                        nArchmageLevels +
                        nSpellPowerLevels +
                        nMageKillerLevels +
                        nAcolyteLevels +
                        nEldritchLevels +
                        nHarperLevels +
                        nSpellswordLevels +
                        nFireLevels + nAcidLevels + nColdLevels + nElecLevels +
                        nPaleMasterLevels + nFireAdept +
                        nOozemasterLevels +
                        nBondedSumm; // + n<levels from any other arcane prc you define>;

int nDivineCastLevels = nDivine +
                        nHeartWLevels +
                        nStormlord +
                        nFistRaziel +
                        nTempus +
                        nOozemasterLevels; // + n<levels from any divine prc you define>;


 if (iTypeSpell == TYPE_ARCANE)
   return nArcaneCastLevels;
 else
   return nDivineCastLevels;

}// end function

