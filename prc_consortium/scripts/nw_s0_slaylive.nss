//::///////////////////////////////////////////////
//:: [Slay Living]
//:: [NW_S0_SlayLive.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Caster makes a touch attack and if the target
//:: fails a Fortitude save they die.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: January 22nd / 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

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
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLAY_LIVING));
        //Make SR check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget))
        {
            //Make melee touch attack
            if(TouchAttackMelee(oTarget))
            {
                //Make Fort save
                if  (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_DEATH))
                {
                    //Apply the death effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                else
                {
                    //Roll damage
                    nDamage = d6(3)+ nCasterLevel;
                    //Make metamagic checks
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 18 + nCasterLevel;
                    }
                    if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                        nDamage = d6(3) + nCasterLevel;
                        nDamage = nDamage + (nDamage/2) + nCasterLevel;
                    }
                    //Apply damage effect and VFX impact
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
