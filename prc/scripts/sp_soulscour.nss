#include "spinc_common"

//
// Does the secondary charisma drain that happens 1 minute after initial effect.
//
void DoSecondaryDrain(object oTarget, int nChaDrain)
{
	// Build the drain effect.
	effect eDebuff = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDrain);
	eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));
		
	// Apply the damage and the damage visible effect to the target.
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDebuff, oTarget);
}

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);

	object oTarget = GetSpellTargetObject();
	
	// Determine damage dice.
	int nCasterLvl = SPGetCasterLevel();
	int nDice = nCasterLvl;
	if (nDice > 5) nDice = 5;

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget);

		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			// Make touch attack, saving result for possible critical
			int nTouchAttack = TouchAttackMelee(oTarget);
			if (nTouchAttack > 0)
			{
				// 2da cha drain, 1d6 wis drain.
				int nChaDrain = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 
					1 == nTouchAttack ? 2 : 4, 6);
				int nWisDrain = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 
					1 == nTouchAttack ? 1 : 2, 6);

				// Build the drain effect.
				effect eDebuff = EffectAbilityDecrease(ABILITY_CHARISMA, nChaDrain);
				eDebuff = EffectLinkEffects(eDebuff, 
					EffectAbilityDecrease(ABILITY_WISDOM, nWisDrain));
				eDebuff = EffectLinkEffects(eDebuff,
					EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));
					
				// Apply the damage and the damage visible effect to the target.
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDebuff, oTarget);
				
				// Target takes secondary 1d6 cha drain 1 minute later.
				nChaDrain = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 
					1 == nTouchAttack ? 1 : 2, 6);
				DelayCommand(MinutesToSeconds(1), DoSecondaryDrain(oTarget, nChaDrain));
			}
		}
	}
	
	SPSetSchool();
}
