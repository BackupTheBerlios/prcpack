/////////////////////////////////////////////////////////////////////////
//
// DoBolt - Function to apply an elemental bolt damage effect given
// the following arguments:
//
//		nDieSize - die size to roll (d4, d6, or d8)
//		nBonusDam - bonus damage per die, or 0 for none
//		nDice = number of dice to roll.
//		nBoltEffect - visual effect to use for bolt(s)
//		nVictimEffect - visual effect to apply to target(s)
//		nDamageType - elemental damage type of the cone (DAMAGE_TYPE_xxx)
//		nSaveType - save type used for cone (SAVING_THROW_TYPE_xxx)
//		nSchool - spell school, defaults to SPELL_SCHOOL_EVOCATION.
//		fDoKnockdown - flag indicating whether spell does knockdown, defaults to FALSE.
//		nSpellID - spell ID to use for events
//
/////////////////////////////////////////////////////////////////////////

void DoBolt(int nDieSize, int nBonusDam, int nDice, int nBoltEffect,
	int nVictimEffect, int nDamageType, int nSaveType, 
	int nSchool = SPELL_SCHOOL_EVOCATION, int fDoKnockdown = FALSE, int nSpellID = -1)
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(nSchool);
	
	// Get the spell ID if it was not given.
	if (-1 == nSpellID) nSpellID = GetSpellId();
	
	// Adjust the damage type of necessary.
	nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

    int nDamage;
    
    // Set the lightning stream to start at the caster's hands
    effect eBolt = EffectBeam(nBoltEffect, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(nVictimEffect);
	effect eKnockdown = EffectKnockdown();
    effect eDamage;
    
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
    int fKnockdownTarget = FALSE;
    
    int nSaveDC = SPGetSpellSaveDC();
    
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        while (GetIsObjectValid(oTarget))
        {
			// Reset the knockdown target flag.
			fKnockdownTarget = FALSE;
			
			// Exclude the caster from the damage effects
			if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
			{
            	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
                   //Fire cast spell at event for the specified target
                   SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);
                   
                   //Make an SR check
                   if (!SPResistSpell(OBJECT_SELF, oTarget))
        	       {
						// Roll damage for each target
						int nDamage = SPGetMetaMagicDamage(nDamageType, nDice, nDieSize, nBonusDam);
						
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        int nFullDamage = nDamage;
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, nSaveType);

                        //Set damage effect
                        eDamage = SPEffectDamage(nDamage, nDamageType);
                        if(nDamage > 0)
                        {
                            // Apply VFX, damage effect and lightning effect
                            //fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }

						// Determine if the target needs to be knocked down.  The target is knocked down
						// if all of the following criteria are met:
						//    - Knockdown is enabled.
						//    - The damage from the spell didn't kill the creature
						//    - The creature is large or smaller
						//    - The creature failed it's reflex save.
						// If the spell does knockdown we need to figure out whether the target made or failed
						// the reflex save.  If the target doesn't have improved evasion this is easy, if the
						// damage is the same as the original damage then the target failed it's save.  If the
						// target has improved evasion then it's harder as the damage is halved even on a failed
						// save, so we have to catch that case.
						fKnockdownTarget = fDoKnockdown && !GetIsDead(oTarget) &&
							GetCreatureSize(oTarget) <= CREATURE_SIZE_LARGE &&
							(nFullDamage == nDamage || (0 != nDamage && GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)));
					}
                    
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0);
                    
					// If we're supposed to apply knockdown then do so for 1 round.
					if (fKnockdownTarget)
						SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(1));
					
					//Set the currect target as the holder of the lightning effect
					oNextTarget = oTarget;
					eBolt = EffectBeam(nBoltEffect, oNextTarget, BODY_NODE_CHEST);
				}
			}
           
			//Get the next object in the lightning cylinder
			oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		}
        
		nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
	}
	
	SPSetSchool();
}

