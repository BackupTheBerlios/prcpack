#include "spinc_common"
#include "x2_i0_spells"

//
// This function runs the burning blood effect for a round, then recursing itself one
// round later to do the effect again.  It relies on a dummy visual effect to act 
// as the spell's timer, expiring itself when the effect expires.
//
void RunSpell(object oCaster, object oTarget, int nMetaMagic, int nSpellID,
	float fDuration)
{
	// If our timer spell effect has worn off (or been dispelled) then we are 
	// done, just exit.
    if (GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)) return;

	// If the target is dead then there is no point in going any further.
    if (GetIsDead(oTarget)) return;

	if (MySavingThrow(SAVING_THROW_FORT, oTarget, SPGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
	{
		// Give feedback that a save was made.
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
			EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE), oTarget);
	}
	else
	{
		// The bad thing happens, 1d8 acid and fire damage, and slowed for 1 round.
		int nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_FIRE, 1, 8, 0, 0, nMetaMagic);
		effect eDamage = SPEffectDamage(nDamage, DAMAGE_TYPE_FIRE);
		eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_FLAME_S));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		
		nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_ACID, 1, 8, 0, 0, nMetaMagic);
		eDamage = SPEffectDamage(nDamage, DAMAGE_TYPE_ACID);
		eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_ACID_S));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		
		eDamage = EffectSlow();
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oTarget, RoundsToSeconds(1));
	}
	
	// Decrement our duration counter by a round and if we still have time left keep
	// going.
	fDuration -= RoundsToSeconds(1);
	if (fDuration > 0.0)
		DelayCommand(RoundsToSeconds(1), RunSpell(oCaster, oTarget, nMetaMagic, nSpellID, fDuration));
}


void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_NECROMANCY);

	object oTarget = GetSpellTargetObject();
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Get the target and raise the spell cast event.
		SPRaiseSpellCastAt(oTarget);

		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			// Determine the spell's duration, taking metamagic feats into account.
			float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(SPGetCasterLevel()));

			// Apply a persistent vfx to the target.
			// RunSpell uses our persistant vfx to determine it's duration.
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
				EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, fDuration);
			
			// Stick OBJECT_SELF into a local because it's a function under the hood,
			// and we need a real object reference.
			object oCaster = OBJECT_SELF;
			DelayCommand(0.5, RunSpell(oCaster, oTarget, SPGetMetaMagic(), GetSpellId(), fDuration));
		}
	}

	SPSetSchool();
}
