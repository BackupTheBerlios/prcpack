//::///////////////////////////////////////////////
//:: Summon Hamatula
//:: NW_S0_Summon1
//:://////////////////////////////////////////////
/*
    Summons a Hamatula to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Sir Attilla
//:: Created On: January 3 , 2004
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "discipleinclude"
void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */
        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    // End of Spell Cast Hook


    //Declare major variables
    //const int FEAT_IMP_SUMMON_HAMATULA = 2011;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    object oPC = OBJECT_SELF;
    effect eSummon = EffectSummonCreature("HAMATULA");

    if (GetHasFeat(FEAT_IMP_SUMMON_HAMATULA, oPC))
    {
        eSummon = EffectSummonCreature("HAMATULA_35E");
    }

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
}

