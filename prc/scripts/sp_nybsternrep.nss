#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oTarget = GetSpellTargetObject();
	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget);

		// Make SR check
		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			// Fort save or die, if the fort save is successful will save or dazed for
			// 1d4 rounds.
			if (!MySavingThrow(SAVING_THROW_FORT, oTarget, SPGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
			{
				// Target dies if it fails fort save.
				effect eDead = EffectDeath();
				eDead = EffectLinkEffects(eDead, EffectVisualEffect(VFX_IMP_DEATH));
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDead, oTarget);
			}
			else if (!MySavingThrow(SAVING_THROW_WILL, oTarget, SPGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
			{
				// Apply metamagic to the 1d4 rounds duration.
				int nRounds = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 1, 4);
				float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nRounds));
				
				effect eDazed = EffectDazed();
				eDazed = EffectLinkEffects(eDazed, EffectVisualEffect(VFX_IMP_DAZED_S));
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazed, oTarget, fDuration);
			}
			
			// The target always takes a -2 penalty to saves, attacks, and skill checks,
			// we do it out here in case the target is immune to death effects (it could
			// then still be alive even if it fails it's fort save).
			if (!GetIsDead(oTarget))
			{
				// Determine the spell's duration, taking metamagic feats into account.
				float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(SPGetCasterLevel()));

				// Target's saves, attack rolls, and skill checks are reduced by 2 for the
				// spell's duration.
				effect eDebuff = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
				eDebuff = EffectLinkEffects(eDebuff, EffectAttackDecrease(2));
				eDebuff = EffectLinkEffects(eDebuff, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
				eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
				eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, fDuration);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
					EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
			}
		}
	}
	
	SPSetSchool();
}
