
void DoOrb(effect eVis, effect eFailSave, int nSaveType, int nDamageType, int nSpellID = -1)
{
	SPSetSchool(SPELL_SCHOOL_EVOCATION);

	object oTarget = GetSpellTargetObject();
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);

	int nDice = nCasterLvl;
	if (nDice > 15) nDice = 15;

	// Get the spell ID if it was not given.
	if (-1 == nSpellID) nSpellID = GetSpellId();
	
	// Adjust the damage type of necessary.
	nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

	effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);

		//Make SR Check
		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			//Roll damage for each target
			int nDamage = SPGetMetaMagicDamage(nDamageType, nDice, 6);

			// Let the target make a fort save, if they succeed half damage and no bad effect, if they fail
			// then full damage and the bad effect.
			int nSaved = 0;
			if (FortitudeSave(oTarget, SPGetSpellSaveDC(), nSaveType))
			{
				nSaved = 1;
				nDamage /= 2;
			}

			// Apply the damage and the damage visible effect to the target.				
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, nDamageType), oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

			// If the target failed it's save then apply the failed save effect as well for 1 round.
			if (!nSaved)
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFailSave, oTarget, RoundsToSeconds(1));
		}
	}
	
	SPSetSchool();
}
