/////////////////////////////////////////////////////////////////////
//
// Divine Protection - +1 to AC and saves to allies in a huge burst.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = GetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);

	// Determine the save bonus.
	int nBonus = 2 + (SPGetCasterLevel() / 6);
	if (nBonus > 5) nBonus = 5;

	// Determine the spell's duration, taking metamagic feats into account.
	float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(nCasterLvl));

	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SPRaiseSpellCastAt(oTarget, FALSE);

			float fDelay = GetSpellEffectDelay(lTarget, oTarget);

			// Apply the curse and vfx.
			effect eCurse = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
			eCurse = EffectLinkEffects(eCurse, EffectACIncrease(1));
			eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
			eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, fDuration));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget));
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

	SPSetSchool();
}
