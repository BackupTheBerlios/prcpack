#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
    object oTarget = GetSpellTargetObject();
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);

	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        // Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget);
        
        // Let the target attempte to make a fort save. (good luck since there is a penalty equal to the 
        // caster's level on the save).
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, SPGetSpellSaveDC() + nCasterLvl, SAVING_THROW_TYPE_SPELL))
        {
			// Calculate the duration of the spell.
			float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(nCasterLvl));
    
			// Generate a SR decrease for the caster level, up to a max of 15.    
			int nSRReduction = nCasterLvl;
			if (nSRReduction > 15) nSRReduction = 15;
		    effect eSR = EffectLinkEffects(
				EffectSpellResistanceDecrease(nSRReduction),
				EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    
            //Apply the VFX impact and effects
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSR, oTarget, fDuration);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
        }
    }
    
	SPSetSchool();
}

