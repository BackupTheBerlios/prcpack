//::///////////////////////////////////////////////
//:: Momento Mori
//:: NW_S0_FingDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You can slay any one living creature within range.
// The victim is entitled to a Fortitude saving throw to
// survive the attack. If he succeeds, he instead
// sustains 3d6 +20 points of damage.
// .
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Dec 26, 2003
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "x0_I0_SPELLS"
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
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);


    if( GetAbilityModifier( ABILITY_INTELLIGENCE, OBJECT_SELF ) >= GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ))
    {
        int nDC = 30 + GetAbilityModifier( ABILITY_INTELLIGENCE, OBJECT_SELF);
    }
    else
    if( GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ) > GetAbilityModifier( ABILITY_INTELLIGENCE, OBJECT_SELF ))
    {
        int nDC = 30 + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF );
    }

    int nDC = nDC;

    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
    {
        //GZ: I still signal this event for scripting purposes, even if a placeable
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FINGER_OF_DEATH));
         if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
                 //Make Forttude save
                 if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
                 {
                    //Apply the death effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 }
                 else
                 {
                    //Roll damage
                    nDamage = d6(3) + 20;
                    //Make metamagic checks
                    //Set damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    //Apply damage effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
            }

    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
