///////////////////////////////////////////////////////////////////////////
//
// DoEnergyImmunity - Apply a 24 hour immunity to one element to the
// target.
//		nDamageType - the damage type (DAMAGE_TYPE_xxx) to be immune to
//		nVfx - The visual effect to use at cast time.
//
///////////////////////////////////////////////////////////////////////////

void DoEnergyImmunity (int nDamageType, int nVfx)
{
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oTarget = GetSpellTargetObject();
	
	// Determine the duration
	float fDuration = SPGetMetaMagicDuration(HoursToSeconds(24));

	// Build a list of the duration effects which includes the actually immunity
	// effect and all visual effects.	
	effect eList = EffectDamageResistance(nDamageType, 9999, 0);
	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
	eList = EffectLinkEffects(eList, eDur);
	eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	eList = EffectLinkEffects(eList, eDur);
	
	// Fire cast spell at event for the specified target
	SPRaiseSpellCastAt(oTarget, FALSE, SPELL_ENERGY_IMMUNITY);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eList, oTarget, fDuration);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), oTarget);
	
	SPSetSchool();
}
