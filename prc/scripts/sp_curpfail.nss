/////////////////////////////////////////////////////////////////////
//
// Curse of Petty Failing - Target takes a -2 penalty to attacks
// and saves.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_NECROMANCY);

	object oTarget = GetSpellTargetObject();
	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Get the target and raise the spell cast event.
		SPRaiseSpellCastAt(oTarget);

		// Determine the spell's duration, taking metamagic feats into account.
		float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(SPGetCasterLevel()));

		// Determine the save bonus.
		int nBonus = 2 + (SPGetCasterLevel() / 6);
		if (nBonus > 5) nBonus = 5;

		// Apply the curse and vfx.
		effect eCurse = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
		eCurse = EffectLinkEffects(eCurse, EffectAttackDecrease(2));
		eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
		eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, fDuration);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
	}

	SPSetSchool();
}
