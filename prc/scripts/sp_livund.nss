/////////////////////////////////////////////////////////////////////
//
// Living Undeath - Target becomes partially undead, gains immunity
// to critical hits and -4 CHA.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_NECROMANCY);

	// Get the target and raise the spell cast event.
	object oTarget = GetSpellTargetObject();
	SPRaiseSpellCastAt(oTarget, FALSE);

	// Determine the spell's duration, taking metamagic feats into account.
	float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(SPGetCasterLevel()));

	// Apply the buff and vfx.
	effect eEffect = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	eEffect = EffectLinkEffects(eEffect, EffectAbilityDecrease(ABILITY_CHARISMA, 4));
	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_PARALYZED));
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_L), oTarget);

	SPSetSchool();
}
