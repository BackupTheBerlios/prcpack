#include "prc_feat_const"
#include "prc_class_const"
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

int GetHeartWarderPene(object oCaster){

    if(GetLevelByClass(CLASS_TYPE_HEARTWARDER,oCaster)<6)
        return 0;

    string VS=lookup_spell_vs(GetSpellId());
    if (!(VS=="s" ||VS=="vs"))
        return 0;

    if ( GetHasFeat(FEAT_SPELL_PENETRATION,oCaster) || GetMetaMagicFeat()==METAMAGIC_SILENT || GetHasFeat(FEAT_GREATER_SPELL_PENETRATION,oCaster)|| GetHasFeat(FEAT_EPIC_SPELL_PENETRATION,oCaster))
        return 0;

    return 2;
}

int GetSpellPowerBonus(object oCaster)
{
    int nBonus = 0;

    if(GetHasFeat(FEAT_SPELLPOWER_10, OBJECT_SELF))
        nBonus = 10;
    else if(GetHasFeat(FEAT_SPELLPOWER_8, OBJECT_SELF))
        nBonus = 8;
    else if(GetHasFeat(FEAT_SPELLPOWER_6, OBJECT_SELF))
        nBonus = 6;
    else if(GetHasFeat(FEAT_SPELLPOWER_4, OBJECT_SELF))
        nBonus = 4;
    else if(GetHasFeat(FEAT_SPELLPOWER_2, OBJECT_SELF))
        nBonus = 2;

    return nBonus;
}

void main()
{
    object oCaster = OBJECT_SELF;
    string element = lookup_spell_type(GetSpellId());

    int nSP = 0;

    if (element == "Fire")
        nSP += add_fire_SP();
    else if (element == "Cold")
        nSP += add_cold_SP();
    else if (element == "Electricity")
        nSP += add_elec_SP();
    else if (element == "Acid")
        nSP += add_acid_SP();

    nSP += GetSpellPowerBonus(oCaster);

    nSP += GetHeartWarderPene(oCaster);

    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nSP);
}
