#include "prc_spell_const"
#include "prc_class_const"

void main()
{

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();

    string Elemental;

    //Determine Invok Elemental subradial type
    if(nSpell == SPELL_ELE_CONF_FIRE)
    {
        Elemental = "NW_FIREHUGE";
    }
    else if (nSpell == SPELL_ELE_CONF_WATER)
    {
        Elemental = "NW_WATERHUGE";
    }
    else if (nSpell == SPELL_ELE_CONF_EARTH)
    {
        Elemental = "NW_EARTHHUGE";
    }
    else if (nSpell == SPELL_ELE_CONF_AIR)
    {
        Elemental = "NW_AIRHUGE";
    }

    int Duration=GetLevelByClass(CLASS_TYPE_CLERIC,oTarget)+GetLevelByClass(CLASS_TYPE_DRUID,oTarget)+GetLevelByClass(CLASS_TYPE_STORMLORD,oTarget);

    effect Summon=EffectSummonCreature(Elemental,VFX_NONE,0.0,1);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,Summon,GetLocation(oTarget),RoundsToSeconds(Duration));
}

