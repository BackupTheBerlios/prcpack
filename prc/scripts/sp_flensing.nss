#include "spinc_common"
#include "x2_i0_spells"

//
// This function runs the flensing effect for a round, then recursing itself one
// round later to do the effect again.  It relies on a dummy VFX_DUR_CESSAGE_NEGATIVE
// visual effect to act as the spell's timer, expiring itself when the effect
// expires.
//
void RunFlensing(object oCaster, object oTarget, int nMetaMagic, int nSpellID,
	float fDuration)
{
	// If our timer spell effect has worn off (or been dispelled) then we are 
	// done, just exit.
    if (GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)) return;

	// If the target is dead then there is no point in going any further.
    if (GetIsDead(oTarget)) return;

	// Figure out what blood color to use.  This is just guessing in my part.
	int nChunkVfx = VFX_COM_CHUNK_RED_MEDIUM;
	switch(GetRacialType(oTarget))
	{
		case RACIAL_TYPE_ABERRATION:
		case RACIAL_TYPE_HUMANOID_GOBLINOID:
		case RACIAL_TYPE_HUMANOID_ORC:
		case RACIAL_TYPE_OUTSIDER:
			nChunkVfx = VFX_COM_CHUNK_GREEN_MEDIUM;
			break;
		case RACIAL_TYPE_OOZE:
		case RACIAL_TYPE_CONSTRUCT:
		case RACIAL_TYPE_UNDEAD:
			nChunkVfx = VFX_COM_CHUNK_YELLOW_MEDIUM;
			break;
	}

	// The nasty stuff, 2d6 damage, 1d6 cha/con damage, fort save to
	// half damage and negate stat damage.
	int nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 2, 6, 0, 0, nMetaMagic);
	int nConDrain = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 1, 8, 0, 0, nMetaMagic);
	int nChaDrain = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 1, 8, 0, 0, nMetaMagic);
	effect eDamage;
	if (MySavingThrow(SAVING_THROW_FORT, oTarget, SPGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
		eDamage = SPEffectDamage(nDamage / 2);
	else
	{
		eDamage = SPEffectDamage(nDamage);
		eDamage = EffectLinkEffects(eDamage, 
			EffectAbilityDecrease(ABILITY_CONSTITUTION, nConDrain));
		eDamage = EffectLinkEffects(eDamage,
			EffectAbilityDecrease(ABILITY_CHARISMA, nChaDrain));
	}
	
	// Add vfx to the damage effect chain.
	eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY));
	eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(nChunkVfx));
	
	// Apply the damage and vfx to the target.
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	
	// Decrement our duration counter by a round and if we still have time left keep
	// going.
	fDuration -= RoundsToSeconds(1);
	if (fDuration > 0.0)
		DelayCommand(RoundsToSeconds(1), RunFlensing(oCaster, oTarget, nMetaMagic, nSpellID, fDuration));
}


void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_EVOCATION);

	object oTarget = GetSpellTargetObject();
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Get the target and raise the spell cast event.
		SPRaiseSpellCastAt(oTarget);

		if (!SPResistSpell(OBJECT_SELF, oTarget))
		{
			// Determine the spell's duration, taking metamagic feats into account.
			float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(4));

			// Apply a persistent vfx to the target, we make him glow red.
			// RunFlensing uses our persistant vfx to determine it's duration.
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
				EffectVisualEffect(VFX_DUR_GLOW_RED), oTarget, fDuration);
			
			// Apply impact vfx.
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
				EffectVisualEffect(VFX_IMP_DEATH), oTarget);
						
			// Stick OBJECT_SELF into a local because it's a function under the hood,
			// and we need a real object reference.
			object oCaster = OBJECT_SELF;
			DelayCommand(1.0, RunFlensing(oCaster, oTarget, SPGetMetaMagic(), GetSpellId(), fDuration));
		}
	}

	SPSetSchool();
}
