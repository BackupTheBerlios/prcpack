//////////////////////////////////////////////////////////////
//
// Mangle of Egragious Might - +4 bonus to stats, attacks,
// saves, AC for 10 min / level.
//
//////////////////////////////////////////////////////////////

#include "spinc_common"

void main() 
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	//Declare major variables
	object oTarget = GetSpellTargetObject();

	//Signal the spell cast at event
	SPRaiseSpellCastAt(oTarget, FALSE);

	// Boost stats, AC, attacks, stats, and saves by 4, and add the buff visual effect.
	effect eList = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
	effect eMore = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
	eList = EffectLinkEffects (eList, eMore);
	eMore = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
	eList = EffectLinkEffects (eList, eMore);
	eMore = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4);
	eList = EffectLinkEffects (eList, eMore);
	eMore = EffectAbilityIncrease(ABILITY_WISDOM, 4);
	eList = EffectLinkEffects (eList, eMore);
	eMore = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
	eList = EffectLinkEffects (eList, eMore);
	eMore = EffectACIncrease (4);
	eList = EffectLinkEffects (eList, eMore);
	eMore = EffectSavingThrowIncrease (SAVING_THROW_ALL, 4);
	eList = EffectLinkEffects (eList, eMore);
	eMore = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	eList = EffectLinkEffects (eList, eMore);

	// Get duration, 10 min / level unless extended.
	float fDuration = SPGetMetaMagicDuration(TenMinutesToSeconds(SPGetCasterLevel()));
	
	// Build the list of fancy visual effects to apply when the spell goes off.
	effect eVisList = EffectVisualEffect(VFX_IMP_AC_BONUS);
	eMore = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
	eVisList = EffectLinkEffects (eVisList, eMore);
	
	// Apply effects and VFX to target
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eList, oTarget, fDuration);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisList, oTarget);
	
	SPSetSchool();
}
