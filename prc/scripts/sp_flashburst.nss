#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_EVOCATION);

	// Apply a burst visual effect at the target location.    
	location lTarget = GetSpellTargetLocation();
	effect eImpact = EffectVisualEffect(VFX_FNF_BLINDDEAF);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

	// Create needed effects.
	effect eDazzle = EffectLinkEffects(EffectAttackDecrease(1),
		EffectVisualEffect(VFX_IMP_STUN));
	effect eBlindness = EffectLinkEffects(EffectBlindness(), 
		EffectVisualEffect(VFX_DUR_BLIND));
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SPRaiseSpellCastAt(oTarget);

			// Apply impact vfx.			
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
				EffectVisualEffect(VFX_IMP_SONIC), oTarget);

			// Creatures are dazzled whether they save or not.
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, RoundsToSeconds(1));
	        
			// Let the creature make a will save, if it fails it's blinded.
			if (!SPResistSpell(OBJECT_SELF, oTarget) &&
				!MySavingThrow(SAVING_THROW_WILL, oTarget, SPGetSpellSaveDC()))
			{
				// Determine the spell's duration, the duration can be empower,
				// maximized, or extended (since it's variable, empower/maximize
				// apply.
				int nRounds = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 2, 8);
				float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nRounds));

				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDuration);
			}
		}
	    
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	}

	SPSetSchool();
}
