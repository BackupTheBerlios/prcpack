#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = GetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);

	// Apply the area vfx.
//	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(), lTarget);
	
	// Build the bonus/penalty effect chains.
	effect ePositive = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	ePositive = EffectLinkEffects (ePositive, EffectAttackIncrease(2));
	ePositive = EffectLinkEffects (ePositive, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));
	ePositive = EffectLinkEffects (ePositive, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
	effect eNegative = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	eNegative = EffectLinkEffects (eNegative, EffectAttackDecrease(2));
	eNegative = EffectLinkEffects (eNegative, EffectSkillDecrease(SKILL_ALL_SKILLS, 2));
	eNegative = EffectLinkEffects (eNegative, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
	
	// Calculate the spell duration.
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));
	
	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	float fDelay;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		// Apply a bonus/penalty effect to the target depending on it's reaction to the caster.
		// If the object is neutral it gets neither a bonus nor a penalty.
		int nFriendly = GetIsReactionTypeFriendly(oTarget);
		int nHostile = GetIsReactionTypeHostile (oTarget);
		if (nFriendly || nHostile)
		{
			// Determine which effect chain to use.
			effect eTarget = nFriendly ? ePositive : eNegative;
			
			// Fire cast spell at event for the specified target
			SPRaiseSpellCastAt(oTarget, nHostile);
			
			// Check for SR vs. hostile targets before applying effects.
			fDelay = GetSpellEffectDelay(lTarget, oTarget);
			if (nFriendly || !SPResistSpell(OBJECT_SELF, oTarget, fDelay))
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTarget, oTarget, fDuration));
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	SPSetSchool();
}
