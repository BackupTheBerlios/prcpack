#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_EVOCATION);

	// Apply a burst visual effect at the target location.    
	location lTarget = GetSpellTargetLocation();
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WORD), lTarget);

	// Build effects
	effect eDeath = EffectDeath();
	eDeath = EffectLinkEffects(eDeath, EffectVisualEffect(VFX_IMP_DEATH_L));
	effect eParalyzed = EffectParalyze();
	eParalyzed = EffectLinkEffects(eParalyzed, EffectVisualEffect(VFX_DUR_PARALYZED));
	
	// Determine the spell's duration.
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(SPGetCasterLevel()));
	
	int nCasterLevel = SPGetCasterLevel();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SPRaiseSpellCastAt(oTarget);
			
			// Apply effects as follows, based on differences between caster's level
			// and target creature's hit dice.
			// up to caster level : slowed 1 round
			// up to caster level - 1 : 2d6 str drain for 2d4 rounds
			// up to caster level - 5 : paralyzed for 1d10 minutes
			// up to caster level - 10 : killed
			// effects are cumulative.
			int nHitDice = GetHitDice(oTarget);
			if (nHitDice <= nCasterLevel - 10)
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);

			// No point in doing anything else if we killed the target, but even
			// if we apply the effect they could be immune.
			if (!GetIsDead(oTarget))
			{
				if (nHitDice <= nCasterLevel - 5)
				{
					// Determine duration (base 1d10 minutes) taking metamagic into
					// account.
					int nMinutes = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 1, 10);
					float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(nMinutes));
					
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyzed, oTarget, fDuration);
				}
				
				if (nHitDice <= nCasterLevel - 1)
				{
					// Determine duration (base 1d10 minutes) taking metamagic into
					// account.
					int nRounds = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 2, 4);
					float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nRounds));

					// Roll 2d6 str drain and apply it to the target, along with impact
					// vfx.					
					int nStrDrain = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 2, 6);
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
						EffectAbilityDecrease(ABILITY_STRENGTH, nStrDrain), oTarget, fDuration);
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
						EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
				}
				
				if (nHitDice <= nCasterLevel)
				{
					// Slow the target for 1 round.
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oTarget, 
						RoundsToSeconds(1));
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
						EffectVisualEffect(VFX_IMP_SLOW), oTarget);
				}
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget);
	}

	SPSetSchool();
}
