#include "spinc_common"

//Duration: 1 round / level
//You cloak yourself in an aura that gives you a +1 bonus per 3 caster levels 
//(maximum +5) on saving throws against spells and spell like abilities, 
//and you gain electricity resistance 10.
void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_ABJURATION);

	// Declare major variables
	object oTarget = GetSpellTargetObject();

	// Signal the spell cast at event
	SPRaiseSpellCastAt(oTarget, FALSE);
	
	int nCasterLevel = SPGetCasterLevel();
	
	int nIncrease = nCasterLevel / 3;
	if (nIncrease > 5) nIncrease = 5;
	effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, nIncrease, 
		SAVING_THROW_TYPE_SPELL);
	eBuff = EffectLinkEffects(eBuff, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10));
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_GLOW_WHITE));
	
	// Get duration, 1 hour / level unless extended.
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nCasterLevel));
	
	// Build the list of fancy visual effects to apply when the spell goes off.
	effect eVFX = EffectVisualEffect(VFX_IMP_HEAD_ELECTRICITY);

	// Remove existing effect, if any.	
    RemoveEffectsFromSpell(oTarget, GetSpellId());

	// Apply effects and VFX to target
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
	
	SPSetSchool();
}
