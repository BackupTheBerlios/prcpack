//////////////////////////////////////////////////////////////
//
// Rewrite of Mage Armor to follow pnp rules of +4 armor bonus.
//
//////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_CONJURATION);

	// Declare major variables
	object oTarget = GetSpellTargetObject();

	// Signal the spell cast at event
	SPRaiseSpellCastAt(oTarget, FALSE);

	// Boost AC.
    effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
    eAC = EffectLinkEffects(eAC, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

	// Get duration, 1 hour / level unless extended.
	float fDuration = SPGetMetaMagicDuration(HoursToSeconds(SPGetCasterLevel(OBJECT_SELF)));
	
	// Build the list of fancy visual effects to apply when the spell goes off.
	effect eVFX = EffectVisualEffect(VFX_IMP_AC_BONUS);

	// Remove existing effect, if any.	
    RemoveEffectsFromSpell(oTarget, GetSpellId());

	// Apply effects and VFX to target
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, fDuration);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
	
	SPSetSchool();
}
