/**
 * Master of Shrouds: Summon Undead (1-4)
 * 2004/02/15
 * Brian Greinke
 * edited to include epic wraith summons 2004/03/04; also removed unnecessary scripting.
 * Lockindal Linantal
 */

#include "strat_prc_inc"

void main()
{
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
    //added variables to check MoS total caster level to determine which summon to use; checks for
    //MoS undead 4, than does a case/switch to determine which summon.

    int nCasterLevel = 0; //What is my total caster level?
    int nCasterBase = 0; //which caster do I base off of?

    //Base class can only be Paladin or Cleric. I won't include Druid or Ranger. People can modify this if
    //they desire, but it doesn't make sense to include them. It hardly makes sense to include Paladin, but since it's in the desc...
    if(GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > GetLevelByClass(CLASS_TYPE_CLERIC, oPC))
        nCasterBase = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);

    else
        nCasterBase = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);

    nCasterLevel = nCasterBase + (GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oPC));


    if ( GetHasFeat(FEAT_MOS_UNDEAD_4) )
    {
        if((GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oPC) > 11) && (nCasterLevel > 21)) // epic MoS summon; requires MoS level 11 or greater.
        {
            switch (nCasterLevel)
            {
                case 21:
                    type = "summonedgreaterw";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 24:
                    type = "summonedgreat001";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 27:
                    type = "summonedgreat002";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 30:
                    type = "summonedgreat003";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 33:
                    type = "summonedgreat004";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 36:
                    type = "summonedgreat005";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 39:
                    type = "summonedgreat006";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 180:  //max level for npc
                    type = "summonedgreat006";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
            }
        }
        else
        {
            type = "SPECTRE_SUMM";
            eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
        }
    }
    else if ( GetHasFeat(FEAT_MOS_UNDEAD_3) )
    {
        type = "SPECTRE_SUMM";
        eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_20 );
    }
    else if ( GetHasFeat(FEAT_MOS_UNDEAD_2) )
    {
        type = "WRAITH_SUMM";
        eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_10 );
    }
    else
    {
        type = "ALLIP_SUMM";
        eSummonB = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
    }

    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectLinkEffects(eSummonA, eSummonB), locCentroid, 1.5f );
        vLoc = Vector( vCentroid.x + (Random(6) - 2.5f),
                       vCentroid.y + (Random(6) - 2.5f),
                       vCentroid.z );
        locSummon = Location( GetArea(oPC), vLoc, IntToFloat(Random(361) - 180) );
        oCreature = CreateObject( OBJECT_TYPE_CREATURE, type, locSummon, FALSE );
        AssignCommand( oCreature, ActionDoCommand(SetLocalInt(oCreature, "ttl", GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oPC))) );
        AssignCommand( oCreature, ActionDoCommand(SetLocalObject(oCreature, "summoner", oPC)) );
}