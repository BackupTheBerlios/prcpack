#include "prc_inc_function"
#include "lookup_2da_spell"

int GetHierophantSLAAdjustment(object oCaster)
{
    if(GetWasLastSpellHieroSLA())
        return StringToInt(lookup_spell_cleric_level(GetSpellId())) - GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);

    return 0;
}

int GetHeartWarderDC(object oCaster)
{
  if(GetLevelByClass(CLASS_TYPE_HEARTWARDER,oCaster)<6)
   return 0;

  string VS=lookup_spell_vs(GetSpellId());
  if (!(VS=="s" ||VS=="vs"))
     return 0;

  if ( GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT,oCaster) || GetMetaMagicFeat()==METAMAGIC_SILENT || GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT,oCaster))
   return 0;

  if (GetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR")==SPELL_SCHOOL_ENCHANTMENT)
   return 2;

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
    nDC += GetHeartWarderDC(oCaster);

    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nDC);
}


