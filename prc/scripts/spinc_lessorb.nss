
void DoLesserOrb(effect eVis, int nDamageType, int nSpellID = -1)
{
	SPSetSchool(SPELL_SCHOOL_CONJURATION);

	object oTarget = GetSpellTargetObject();
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);
	int nMetaMagic = GetMetaMagicFeat();

	int nDice = (nCasterLvl + 1)/2;
	if (nDice > 5) nDice = 5;

	// Get the spell ID if it was not given.
	if (-1 == nSpellID) nSpellID = GetSpellId();
	
	// Adjust the damage type of necessary.
	nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);

		// Note that this spell has no spell resistance intentionally in the WotC Miniatures
		// Handbook, bit powerful but that's how it is in the PnP book.
		
		// Make touch attack, saving result for possible critical
		int nTouchAttack = TouchAttackRanged(oTarget);
		if (nTouchAttack > 0)
		{
			// Roll the damage, doing double damage on a crit.
			int nDamage = SPGetMetaMagicDamage(nDamageType, 1 == nTouchAttack ? nDice : (nDice * 2), 8);

			// Apply the damage and the damage visible effect to the target.				
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, nDamageType), oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
	
	SPSetSchool();
}
