#include "prc_dg_inc"
#include "strat_prc_inc"
#include "discipleinclude"
#include "inc_prc_function"
#include "lookup_2da_spell"

int add_fire_SP()
{
    object oCaster = OBJECT_SELF;
    int nSP = 0;

    if ( GetHasFeat( FEAT_ES_FIRE, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nSP += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nSP += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nSP += 1;
    }

    return nSP;
}

int add_elec_SP()
{
    object oCaster = OBJECT_SELF;
    int nSP = 0;

    if ( GetHasFeat( FEAT_ES_ELEC, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nSP += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nSP += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nSP += 1;
    }

    return nSP;
}

int add_cold_SP()
{
    object oCaster = OBJECT_SELF;
    int nSP = 0;

    if ( GetHasFeat( FEAT_ES_COLD, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nSP += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nSP += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nSP += 1;
    }

    return nSP;
}

int add_acid_SP()
{
    object oCaster = OBJECT_SELF;
    int nSP = 0;

    if ( GetHasFeat( FEAT_ES_ACID, oCaster ))
    {
        if ( GetHasFeat ( FEAT_ES_FOCUS_3, oCaster ))
            nSP += 3;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_2, oCaster ))
            nSP += 2;
        else if ( GetHasFeat ( FEAT_ES_FOCUS_1, oCaster ))
            nSP += 1;
    }

    return nSP;
}

void main()
{
    object oCaster = OBJECT_SELF;
    string element = lookup_spell_type(GetSpellId());

    int nSP = 0;

    //Sorry to mess with your scripts, but I needed to make sure
    //that spell power and hierophant spell-like ability adjustments
    //didn't get short circuited by these functions. All I did was
    //change your functions to return ints and add them up at the end
    //instead of terminating the script.
    // - Aaon Graywolf
    if (element == "Fire")
        nSP += add_fire_SP();
    else if (element == "Cold")
        nSP += add_cold_SP();
    else if (element == "Electricity")
        nSP += add_elec_SP();
    else if (element == "Acid")
        nSP += add_acid_SP();

    nSP += GetSpellPowerBonus(oCaster);

    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nSP);
}

