/**
 * Master of Shrouds: Summon Undead (1-4)
 * 2004/02/15
 * Brian Greinke
 */

#include "strat_prc_inc"

void main()
{
    int num;
    string type;
    int i;
    location locCentroid = GetSpellTargetLocation();
    vector vCentroid = GetPositionFromLocation( locCentroid );
    effect eSummonA = EffectVisualEffect( VFX_DUR_ELEMENTAL_SHIELD );
    effect eSummonB;
    object oCreature;
    vector vLoc;
    location locSummon;
    object oPC = OBJECT_SELF;

    if ( GetHasFeat(FEAT_MOS_UNDEAD_4) )
    {
        num = 8;
        type = "SPECTRE_SUMM";
        eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
    }
    else if ( GetHasFeat(FEAT_MOS_UNDEAD_3) )
    {
        num = 2;
        type = "SPECTRE_SUMM";
        eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_20 );
    }
    else if ( GetHasFeat(FEAT_MOS_UNDEAD_2) )
    {
        num = 2;
        type = "WRAITH_SUMM";
        eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_10 );
    }
    else
    {
        num = 2;
        type = "ALLIP_SUMM";
        eSummonB = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
    }

    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectLinkEffects(eSummonA, eSummonB), locCentroid, 1.5f );
    for ( i=0; i<num; i++ )
    {
        vLoc = Vector( vCentroid.x + (Random(6) - 2.5f),
                       vCentroid.y + (Random(6) - 2.5f),
                       vCentroid.z );
        locSummon = Location( GetArea(oPC), vLoc, IntToFloat(Random(361) - 180) );
        oCreature = CreateObject( OBJECT_TYPE_CREATURE, type, locSummon, FALSE );
        AssignCommand( oCreature, ActionDoCommand(SetLocalInt(oCreature, "ttl", GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oPC))) );
        AssignCommand( oCreature, ActionDoCommand(SetLocalObject(oCreature, "summoner", oPC)) );
    }
}

