//::///////////////////////////////////////////////
//:: Firebrand
//:: x0_x0_Firebrand
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// * Fires a flame arrow to every target in a
// * colossal area
// * Each target explodes into a small fireball for
// * 1d6 damage / level (max = 15 levels)
// * Only nLevel targets can be affected
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 29 2002
//:://////////////////////////////////////////////
//:: Last Updated By:

//
// Altered to give targets reflex saves per pnp.
//

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void DoFirebrand(int nD6Dice, int nCap, int nSpell, 
	int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, 
	int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    int nDamage = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    if (nDamage > 15)
        nDamage = 15;

	// Changed to local function to add reflex save.
    DoFirebrand(nDamage, 15, SPELL_FIREBRAND, VFX_IMP_MIRV_FLAME, VFX_IMP_FLAME_M, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE), TRUE);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}



//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Modified March 14 2003: Removed the option to hurt chests/doors
//::  was potentially causing bugs when no creature targets available.
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Modified March 14 2003: Removed the option to hurt chests/doors
//::  was potentially causing bugs when no creature targets available.
void DoFirebrand(int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE)
{
    object oTarget = OBJECT_INVALID;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt = 1;
    effect eMissile = EffectVisualEffect(nMIRV);
    effect eVis = EffectVisualEffect(nVIS);
    float fDist = 0.0;
    float fDelay = 0.0;
    float fDelay2, fTime;
    location lTarget = GetSpellTargetLocation(); // missile spread centered around caster
    int nMissiles = nCasterLvl;

    if (nMissiles > nCap)
    {
        nMissiles = nCap;
    }

        /* New Algorithm
            1. Count # of targets
            2. Determine number of missiles
            3. First target gets a missile and all Excess missiles
            4. Rest of targets (max nMissiles) get one missile
       */
    int nEnemies = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) )
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            // GZ: You can only fire missiles on visible targets
            if (GetObjectSeen(oTarget,OBJECT_SELF))
            {
                nEnemies++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }

     if (nEnemies == 0) return; // * Exit if no enemies to hit
     int nExtraMissiles = nMissiles / nEnemies;

     // April 2003
     // * if more enemies than missiles, need to make sure that at least
     // * one missile will hit each of the enemies
     if (nExtraMissiles <= 0)
     {
        nExtraMissiles = 1;
     }

     // by default the Remainder will be 0 (if more than enough enemies for all the missiles)
     int nRemainder = 0;

     if (nExtraMissiles >0)
        nRemainder = nMissiles % nEnemies;

     if (nEnemies > nMissiles)
        nEnemies = nMissiles;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

                // * recalculate appropriate distances
                fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
                fDelay = fDist/(3.0 * log(fDist) + 2.0);

                // Firebrand.
                // It means that once the target has taken damage this round from the
                // spell it won't take subsequent damage
                if (nONEHIT == TRUE)
                {
                    nExtraMissiles = 1;
                    nRemainder = 0;
                }

                int i = 0;
                //--------------------------------------------------------------
                // GZ: Moved SR check out of loop to have 1 check per target
                //     not one check per missile, which would rip spell mantels
                //     apart
                //--------------------------------------------------------------
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    for (i=1; i <= nExtraMissiles + nRemainder; i++)
                    {
                        //Roll damage
                        int nDam = d6(nD6Dice);
                        //Enter Metamagic conditions
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                             nDam = nD6Dice*6;//Damage is at max
                        }
                        if (nMetaMagic == METAMAGIC_EMPOWER)
                        {
                              nDam = nDam + nDam/2; //Damage/Healing is +50%
                        }
                        fTime = fDelay;
                        fDelay2 += 0.1;
                        fTime += fDelay2;

						// Adjust damage for reflex save / evasion / imp evasion
						nDam = GetReflexAdjustedDamage(nDam, oTarget, 
							GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF), SAVING_THROW_TYPE_FIRE);

						// Always apply missle but only apply impact/damage if we really have damage.							
						DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
						if (nDam > 0)
						{
							//Set damage effect
							effect eDam = EffectDamage(nDam, nDAMAGETYPE);
							//Apply the MIRV and damage effect
							DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
							DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        }
                    }
                } // for
                else
                {  // * apply a dummy visual effect
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
                }
                nCnt++;// * increment count of missiles fired
                nRemainder = 0;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

}
