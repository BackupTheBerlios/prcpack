#include "prc_dg_inc"
#include "strat_prc_inc"
#include "discipleinclude"
#include "inc_prc_function"

//Added code to correct problems in Hierophant spell-like abilities.
//Aaon Graywolf - 6 Jan 2004

int bArcane(int nCastingClass);
int bDivine(int nCastingClass);
int bIsFirstArcaneClass(int nCastingClass, object oCaster = OBJECT_SELF);
int bIsFirstDivineClass(int nCastingClass, object oCaster = OBJECT_SELF);



void main()
{
// prevents any prc levels from being added to the cast level of a wand or scroll.
if(GetSpellCastItem() != OBJECT_INVALID)
{
return;
}

object oCaster = OBJECT_SELF;
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// This is the section where you declare any + 1 caster level prc's and the amount
// of casting levels they should add
//////////////////////////////////////////////////////////////////////////////////



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


/////////////////////////////////////////////////////////////////////////////////
// INSTRUCTIONS
//
// If you want to add more +1 caster level prc's, declare them above
// and sort out the exact number of caster levels each one should add
// then add that amount to the appropriate category below.
// -> either add the amount to nArcaneCastLevels or to nDivineCastLevels, depending
//    on which kind of class it affects.
//////////////////////////////////////////////////////////////////////////////////


int nArcaneCastLevels = nArchmageLevels +
                        nSpellPowerLevels +
                        nMageKillerLevels +
                        nAcolyteLevels +
                        nEldritchLevels +
                        nHarperLevels +
                        nSpellswordLevels +
                        nFireLevels + nAcidLevels + nColdLevels + nElecLevels +
                        nPaleMasterLevels + nFireAdept; // + n<levels from any other arcane prc you define>;

int nDivineCastLevels = 0; // + n<levels from any divine prc you define>;

/* Find which class to add levels to for Oozemasters */
if (bArcane(GetClassByPosition(1, oCaster)) || bDivine(GetClassByPosition(1, oCaster)))
{
    if (bArcane(GetClassByPosition(1, oCaster)))
        nArcaneCastLevels += nOozemasterLevels;
    else if (bDivine(GetClassByPosition(1, oCaster)))
        nDivineCastLevels += nOozemasterLevels;
}
else if (bArcane(GetClassByPosition(2, oCaster)) || bDivine(GetClassByPosition(2, oCaster)))
{
    if (bArcane(GetClassByPosition(2, oCaster)))
        nArcaneCastLevels += nOozemasterLevels;
    else if (bDivine(GetClassByPosition(2, oCaster)))
        nDivineCastLevels += nOozemasterLevels;
}


///////////////////////////////////////////////////////////////////////////////////
// This is the end of the section where you declare any +1 caster level prc's -
//
// - so there shouldn't be any need to alter any lines of code below this line if all
// you're trying to do is add more prc classes.
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

int nCastingClass = GetLastSpellCastClass();

if(bArcane(nCastingClass) && nArcaneCastLevels)
// Making sure they are using an arcane class, and there is something to be added.
{
    if(bIsFirstArcaneClass(nCastingClass))
    // determine whether nCastingClass is their first arcane class.
    {
    int nToReturn = nArcaneCastLevels;
    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nToReturn);
    }
}
else if(bDivine(nCastingClass) && nDivineCastLevels)
// Making sure they are using a divine class, and there is something to be added.
{
    if(bIsFirstDivineClass(nCastingClass))
    // determine whether nCastingClass is their first divine class.
    {
    int nToReturn = nDivineCastLevels;
    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nToReturn);
    }
}
//Hierophant spell-like abilities should be cast using Cleric level, not Hierophant level
else if(GetWasLastSpellHieroSLA())
{
    int nToReturn = GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) - GetLevelByClass(CLASS_TYPE_HIEROPHANT, OBJECT_SELF);
    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nToReturn);
}


}// end void main


// Determines whether a given class is one of the 3 arcane base classes
int bArcane(int nCastingClass)
{
switch(nCastingClass)
{
case CLASS_TYPE_WIZARD: return TRUE; break;
case CLASS_TYPE_SORCERER: return TRUE; break;
case CLASS_TYPE_BARD: return TRUE; break;
}
return FALSE;
}
// Determines whether a given class is one of the 2 divine base classes.
// I'm not sure if Paladin or Ranger can be used, so I commented them out, but you can
// feel free to uncomment them if you discover that they can be used.
int bDivine(int nCastingClass)
{
switch(nCastingClass)
{
case CLASS_TYPE_CLERIC: return TRUE; break;
case CLASS_TYPE_DRUID: return TRUE; break;
//case CLASS_TYPE_PALADIN: return TRUE; break;  // I'm not sure if the +1 Caster Level spell progression
//case CLASS_TYPE_RANGER: return TRUE; break;   // works for Rangers or Paladins, so they're commented out
}
return FALSE;
}

// This function's job is just to make sure that if the character has 2 arcane classes, they
// aren't using the second one to cast the spell

int bIsFirstArcaneClass(int nCastingClass, object oCaster = OBJECT_SELF)
{
int nFirstClass = GetClassByPosition(1, oCaster);
if(nFirstClass == nCastingClass || !bArcane(nFirstClass))
// If the first character class isn't arcane, then the second one must be or the
// character could never have taken any levels in a +1 casting level arcane prc to
// begin with, so there's no need to screen for that.
// It HAS to be the case
{
return TRUE;
}
else
{
return FALSE;
}
}// end function


// This function's job is just to make sure that if the character has 2 divine classes, they
// aren't using the second one to cast the spell

int bIsFirstDivineClass(int nCastingClass, object oCaster = OBJECT_SELF)
{
int nFirstClass = GetClassByPosition(1, oCaster);
if(nFirstClass == nCastingClass || !bDivine(nFirstClass))
// If the first character class isn't divine, then the second one must be or the
// character could never have taken any levels in a +1 casting level divine prc to
// begin with, so there's no need to screen for that.
// It HAS to be the case
{
return TRUE;
}
else
{
return FALSE;
}
}// end function

