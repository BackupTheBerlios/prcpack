////////////////////////////////////////////////////////////////////////////////////
//
// DoBurst() - Do a damaging burst at the spell's target location.
//		nDieSize - size of die to roll.
//		nBonusDam - bonus damage per die.
//		nDice - number of dice to roll
//		nBurstEffect - VFX_xxx or AOE_xxx of burst vfx.
//		nVictimEffect - VFX_xxx of target impact.
//		nDamageType - DAMAGE_TYPE_xxx of the type of damage dealt
//		nSaveType - SAVING_THROW_xxx of type of save to use
//		bCasterImmune - Indicates whether the caster is immune to the spell
//		nSchool - SPELL_SCHOOL_xxx of the spell's school
//		nSpellID - ID # of the spell, if -1 GetSpellId() is used
//		fAOEDuration - if > 0, then nBurstEffect should be an AOE_xxx vfx, it
//			will be played at the target location for this duration.  If this is
//			0 then nBurstEffect should be a VFX_xxx vfx.
//
////////////////////////////////////////////////////////////////////////////////////

void DoBurst (int nDieSize, int nBonusDam, int nDice, int nBurstEffect, 
	int nVictimEffect, float fRadius, int nDamageType, int nSaveType,
	int bCasterImmune = FALSE,
	int nSchool = SPELL_SCHOOL_EVOCATION, int nSpellID = -1,
	float fAOEDuration = 0.0f)
{
	SPSetSchool(nSchool);
	
	// Get the spell ID if it was not given.
	if (-1 == nSpellID) nSpellID = GetSpellId();
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = GetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);

	// Adjust the damage type of necessary.
	nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

	// Apply the specified vfx to the location.  If we were given an aoe vfx then
	// fAOEDuration will be > 0.
	if (fAOEDuration > 0.0)
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
			EffectAreaOfEffect(nBurstEffect, "****", "****", "****"), lTarget, fAOEDuration);
	else
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nBurstEffect), lTarget);
	
	int nSaveDC = SPGetSpellSaveDC();
	
	effect eVis = EffectVisualEffect(nVictimEffect);
	effect eDamage;
	float fDelay;
	
	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oTarget))
	{
		// Filter out the caster if he is supposed to be immune to the burst.
		if (bCasterImmune && OBJECT_SELF == oTarget) continue;
		
     	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);

			fDelay = GetSpellEffectDelay(lTarget, oTarget);
			if (!SPResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
				// Roll damage for each target
				int nDam = SPGetMetaMagicDamage(nDamageType, nDice, nDieSize, nBonusDam);
					
				// Adjust damage for reflex save / evasion / imp evasion
				nDam = GetReflexAdjustedDamage(nDam, oTarget, nSaveDC, nSaveType);

				//Set the damage effect
				if(nDam > 0)
				{
					eDamage = SPEffectDamage(nDam, nDamageType);
					
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
					
					// This visual effect is applied to the target object not the location as above.
					DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}

			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	SPSetSchool();
}
