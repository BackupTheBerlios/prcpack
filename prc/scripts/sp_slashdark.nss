/////////////////////////////////////////////////////////////////////
//
// Slashing Darkness - Project a damaging ray of negative energy.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	SPSetSchool(SPELL_SCHOOL_EVOCATION);

	// Determine the dice of damage.
	int nDice = (SPGetCasterLevel(OBJECT_SELF) + 1) / 2;
	if (nDice > 5) nDice = 5;

	// Adjust the damage type if necessary.
	int nDamageType = SPGetElementalDamageType(DAMAGE_TYPE_NEGATIVE, OBJECT_SELF);

	object oTarget = GetSpellTargetObject();
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget);

		//Make SR Check
		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			// Make the touch attack and roll damage if it hits.
			int nDamage = 0;
			int nTouchAttack = TouchAttackRanged(oTarget);
			if (nTouchAttack > 0)
				nDamage = SPGetMetaMagicDamage(nDamageType, 1 == nTouchAttack ? nDice : (nDice * 2), 8);

			// Apply the damage and the vfx to the target.
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
				EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND, 0 == nTouchAttack), oTarget, 1.0);
			if (nDamage)
			{
				effect eEffect = RACIAL_TYPE_UNDEAD == GetRacialType(oTarget) ?
					EffectHeal(nDamage) : SPEffectDamage(nDamage, nDamageType);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
			}
		}
	}

	SPSetSchool();
}
