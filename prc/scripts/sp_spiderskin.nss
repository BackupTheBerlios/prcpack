#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);

	// Get the target and raise the spell cast event.
	object oTarget = GetSpellTargetObject();
	SPRaiseSpellCastAt(oTarget, FALSE);

	// Determine the spell's duration, taking metamagic feats into account.
	int nCasterLevel = SPGetCasterLevel();
	float fDuration = SPGetMetaMagicDuration(TenMinutesToSeconds(nCasterLevel));

	// Calculate buff amount.
	int nBuff = 1 + nCasterLevel / 3;
	if (nBuff > 5) nBuff = 5;
	
	// Apply the buff and vfx.
	effect eBuff = EffectACIncrease(nBuff, AC_NATURAL_BONUS);
	eBuff = EffectLinkEffects(eBuff, EffectSkillIncrease(SKILL_HIDE, nBuff));
	eBuff = EffectLinkEffects(eBuff, 
		EffectSavingThrowIncrease(SAVING_THROW_ALL, nBuff, SAVING_THROW_TYPE_POISON));
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration);
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
		EffectVisualEffect(VFX_IMP_POLYMORPH), oTarget);

	SPSetSchool();
}
