/////////////////////////////////////////////////////////////////////
//
// Conviction - Give the target a +2 to +5 bonus to saving throws.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_ABJURATION);

	// Get the target and raise the spell cast event.
	object oTarget = GetSpellTargetObject();
	SPRaiseSpellCastAt(oTarget, FALSE);

	// Determine the spell's duration, taking metamagic feats into account.
	float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(SPGetCasterLevel()));

	// Determine the save bonus.
	int nBonus = 2 + (SPGetCasterLevel() / 6);
	if (nBonus > 5) nBonus = 5;

	// Apply the buff and vfx.
	effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_LESSER), oTarget);

	SPSetSchool();
}
