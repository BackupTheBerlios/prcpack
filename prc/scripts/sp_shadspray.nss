#include "spinc_common"

//School: Illusion
//Area of Effect / Target: Small
//Save: Fortitude negates
//Spell Resistance: Yes
//You cause a multitude of ribbonlike shadows to explode outward in the 
//target area.  Creatures in the area take 2 points of strength 
//damage, are dazed for 1 round, and suffer a -2 penalty to saves vs. 
//fear effects.  The fear penalty lasts for 1 round / level.
void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_ILLUSION);

	// Apply a burst visual effect at the target location.    
	location lTarget = GetSpellTargetLocation();
//TODO: NEED VFX
	effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

	// Determine the spell's duration.    
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(SPGetCasterLevel()));

	// Build all of the detrimental effectsd, any target that fails its save takes
	// 2 points of strength damage, is dazed for 1 round, and has it's save against
	// fear effects lowered by 2.
	effect eDamage = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
	effect eDaze = EffectDazed();
	effect eFear = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SPRaiseSpellCastAt(oTarget);

			// Let the creature make a fort save, if it fails it's apply the
			// detrimental effects.
			if (!MySavingThrow(SAVING_THROW_FORT, oTarget, SPGetSpellSaveDC()))
			{
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1));
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration);
			}
		}
	    
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);
	}

	SPSetSchool();
}
