/**
 * Master of Shrouds: Summon Undead (1-4)
 * 2004/02/15
 * Brian Greinke
 * edited to include epic wraith summons 2004/03/04; also removed unnecessary scripting.
 * Lockindal Linantal
 */

#include "prc_class_const"
#include "prc_feat_const"

void main()
{
    string sSummon;
    effect eSummonB;
    object oCreature;
    int nClass = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, OBJECT_SELF);


    if ( GetHasFeat(FEAT_MOS_UNDEAD_4) )
    {
        if(GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, OBJECT_SELF) >= 11)
        {
            switch (nClass)
            {
                case 11:
                    sSummon = "summonedgreaterw";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 14:
                    sSummon = "summonedgreat001";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 17:
                    sSummon = "summonedgreat002";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 20:
                    sSummon = "summonedgreat003";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 23:
                    sSummon = "summonedgreat004";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 26:
                    sSummon = "summonedgreat005";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 29:
                    sSummon = "summonedgreat006";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 180:  //max level for npc
                    sSummon = "summonedgreat006";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
            }
        }
        else
        {
            sSummon = "prc_mos_spectre2";
            eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
        }
    }
    else if ( GetHasFeat(FEAT_MOS_UNDEAD_3) )
    {
        sSummon = "prc_mos_spectre1";
        eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_20 );
    }
    else if ( GetHasFeat(FEAT_MOS_UNDEAD_2) )
    {
        sSummon = "prc_mos_wraith";
        eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_10 );
    }
    else
    {
        sSummon = "prc_mos_allip";
        eSummonB = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
    }
   float fDelay = 0.0;
   effect eSum = EffectSummonCreature(sSummon, VFX_NONE, fDelay);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSum, OBJECT_SELF, fDelay);
}
