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
		if (!SPResistSpell(OBJECT_SELF, oTarget) &&
			!MySavingThrow(SAVING_THROW_FORT, oTarget, SPGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
		{
			// Determine the spell's duration, taking metamagic feats into account.
			float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(SPGetCasterLevel()));

			// Target is dazed for 1 round.
			effect eDazed = EffectDazed();
			eDazed = EffectLinkEffects(eDazed, EffectVisualEffect(VFX_IMP_DAZED_S));
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazed, oTarget, 
				RoundsToSeconds(1));
			
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
	
	SPSetSchool();
}
