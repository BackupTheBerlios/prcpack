#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	// Get the target and raise the spell cast event.
	object oTarget = GetSpellTargetObject();
	SPRaiseSpellCastAt(oTarget, FALSE);
	
	// Determine the spell's duration, taking metamagic feats into account.
	int nCasterlvl= SPGetCasterLevel();
	float fDuration = SPGetMetaMagicDuration(TenMinutesToSeconds(nCasterlvl));
	
	// Create the chain of buffs to apply, including the vfx.
	effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
	eBuff = EffectLinkEffects (eBuff, EffectAttackIncrease(4, ATTACK_BONUS_MISC));
	eBuff = EffectLinkEffects (eBuff, EffectSkillIncrease(SKILL_ALL_SKILLS, 4));
	eBuff = EffectLinkEffects (eBuff, EffectImmunity(IMMUNITY_TYPE_FEAR));
	eBuff = EffectLinkEffects (eBuff, SPEffectTemporaryHitpoints(nCasterlvl > 20 ? 20 : nCasterlvl));

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
}
