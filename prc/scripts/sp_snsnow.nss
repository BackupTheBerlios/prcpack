#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_EVOCATION);

	object oTarget = GetSpellTargetObject();
	
	// Determine damage dice.
	int nCasterLvl = SPGetCasterLevel();
	int nDice = nCasterLvl;
	if (nDice > 5) nDice = 5;

	// Adjust the damage type of necessary.
	int nDamageType = SPGetElementalDamageType(DAMAGE_TYPE_COLD, OBJECT_SELF);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget);

		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			// Make touch attack, saving result for possible critical
			int nTouchAttack = TouchAttackRanged(oTarget);
			if (nTouchAttack > 0)
			{
				// Roll the damage of (1d6+1) / level, doing double damage on a crit.
				int nDamage = SPGetMetaMagicDamage(nDamageType, 
					1 == nTouchAttack ? nDice : (nDice * 2), 6, 1);

				// Apply the damage and the damage visible effect to the target.				
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
					SPEffectDamage(nDamage, nDamageType), oTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
					EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
			}
		}
	}
	
	SPSetSchool();
}
