/////////////////////////////////////////////////////////////////////
//
// Panacea - Heals 1d8+1/lvl (max 1d8+20) hp, cures the following
// conditions: blinded, confused, dazed, deafened, diseased, 
// frightened, paralyzed, poisoned, sleep, and stunned.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_CONJURATION);

	// Get the target and raise the spell cast event.
	object oTarget = GetSpellTargetObject();

	// Compute the damage to add to the dice roll.
	int nAdd = SPGetCasterLevel();
	if (nAdd > 20) nAdd = 20;
	
	// If the target is not undead then heal it and remove all harmfull effects.  If
	// the target is undead then check for SR.
	if (RACIAL_TYPE_UNDEAD != GetRacialType(oTarget))
	{	
		SPRaiseSpellCastAt(oTarget, FALSE);
		
		// Look for detrimental effects and remove them.  Removes the following effects:
		// blinded, confused, dazed, deafened, diseased, frightened, paralyzed, 
		// poisoned, sleep, and stunned.
		effect eEffect = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eEffect))
		{
			// GetIsValidEffect() appears to be returning TRUE sometimes even for invalid effects so
			// catch that here.
			int nEffectType = GetEffectType(eEffect);
			if (EFFECT_TYPE_INVALIDEFFECT == nEffectType)
			{
				PrintString("****EFFECT_TYPE_INVALIDEFFECT returned but GetIsValidEffect() returns TRUE");
				break;
			}
			
			// catch all of the detrimental effects and remove them.
			if (EFFECT_TYPE_BLINDNESS == nEffectType || 
				EFFECT_TYPE_CONFUSED == nEffectType ||
				EFFECT_TYPE_DAZED == nEffectType || 
				EFFECT_TYPE_DEAF == nEffectType ||
				EFFECT_TYPE_DISEASE == nEffectType || 
				EFFECT_TYPE_FRIGHTENED == nEffectType ||
				EFFECT_TYPE_PARALYZE == nEffectType || 
				EFFECT_TYPE_POISON == nEffectType ||
				EFFECT_TYPE_SLEEP == nEffectType || 
				EFFECT_TYPE_STUNNED == nEffectType)
				RemoveEffect(oTarget, eEffect);
			
			GetNextEffect(oTarget);
		}
				
		// Roll the healing 'damage'.
		int nHeal = SPGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1, 8, 0, nAdd);

		// Apply the healing and VFX.
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget);
	}
	else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		SPRaiseSpellCastAt(oTarget);
		
		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			int nTouch = TouchAttackMelee(oTarget);
			if (nTouch > 0)
			{
				// Roll the damage (allowing for a critical) and let the target make a will save to
				// halve the damage.
				int nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1 == nTouch ? 1 : 2, 8, 0, nAdd);
				if (MySavingThrow(SAVING_THROW_WILL, oTarget, SPGetSpellSaveDC())) nDamage /= 2;
				
				// Apply damage and VFX.
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, DAMAGE_TYPE_POSITIVE), oTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget);
			}
		}
	}

	SPSetSchool();
}
