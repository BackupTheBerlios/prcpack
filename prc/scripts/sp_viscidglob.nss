#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_CONJURATION);

	object oTarget = GetSpellTargetObject();
	
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
				// Impact vfx.
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
					EffectVisualEffect(VFX_IMP_ACID_S), oTarget);
						
				if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, SPGetSpellSaveDC(), 
					SAVING_THROW_TYPE_SPELL))
				{
					float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(SPGetCasterLevel()));
					
					// Target cannot move no matter what.
					effect eEffect = EffectCutsceneImmobilize();
					eEffect = EffectLinkEffects(eEffect,
						EffectVisualEffect(VFX_DUR_GLOW_LIGHT_GREEN));
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);

					// If target is medium or smaller may not take any actions either.						
					if (GetCreatureSize(oTarget) <= CREATURE_SIZE_MEDIUM)
						SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), 
							oTarget, fDuration);
				}
				else
				{
					// Show that the target made it's save.
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
						EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE), oTarget);
				}
			}
		}
	}
	
	SPSetSchool();
}
