#include "prc_dg_inc"
#include "strat_prc_inc"
#include "discipleinclude"
#include "inc_prc_function"
#include "lookup_2da_spell"

//Added code to correct problems in Hierophant spell-like abilities.
//Added code to apply Spell Power bonuses
//Aaon Graywolf - Jan 6, 2004

// * Hierophant spell-like abilities compute DC by using the character's Hierophant
// * level in place of spell level.  So we'll need to look up the spell level of the
// * abiltiy in the 2da tables and fix this problem.
int GetHierophantSLAAdjustment(object oCaster)
{
    if(GetWasLastSpellHieroSLA())
        return StringToInt(Get2DAString("spells", "Cleric", GetSpellId())) - GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);

    return 0;
}

int add_fire_dc()
{
    object oCaster = OBJECT_SELF;
    int nDC = 0;

    if ( GetHasFeat( FEAT_ES_FIRE, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nDC += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nDC += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nDC += 1;
    }

    return nDC;
}

int add_elec_dc()
{
    object oCaster = OBJECT_SELF;
    int nDC = 0;

    if ( GetHasFeat( FEAT_ES_ELEC, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nDC += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nDC += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nDC += 1;
    }

    return nDC;
}

int add_cold_dc()
{
    object oCaster = OBJECT_SELF;
    int nDC = 0;

    if ( GetHasFeat( FEAT_ES_COLD, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nDC += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nDC += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nDC += 1;
    }

    return nDC;
}

int add_acid_dc()
{
    object oCaster = OBJECT_SELF;
    int nDC = 0;

    if ( GetHasFeat( FEAT_ES_ACID, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nDC += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nDC += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nDC += 1;
    }

    return nDC;
}

void main()
{
    object oCaster = OBJECT_SELF;
    string element = lookup_spell_type(GetSpellId());

    int nDC = 0;

    //Sorry to mess with your scripts, but I needed to make sure
    //that spell power and hierophant spell-like ability adjustments
    //didn't get short circuited by these functions. All I did was
    //change your functions to return ints and add them up at the end
    //instead of terminating the script.
    // - Aaon Graywolf
    if (element == "Fire")
        nDC += add_fire_dc();
    else if (element == "Cold")
        nDC += add_cold_dc();
    else if (element == "Electricity")
        nDC += add_elec_dc();
    else if (element == "Acid")
        nDC += add_acid_dc();

    nDC += GetSpellPowerBonus(oCaster);
    nDC += GetHierophantSLAAdjustment(oCaster);

    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nDC);
}

