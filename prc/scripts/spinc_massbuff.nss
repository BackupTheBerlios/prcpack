/////////////////////////////////////////////////////////////////////////////////
//
// DoMassBuff - Casts a mass buff spell on the specified target location, buffing
// all friendly creatures within a huge radius.
//		nBuffType - The type of buff to do, one of the MASSBUFF_xxx defines.
//		nSubBuffType - Depends on the value of nBuffType, for stat buffs this
//		is ABILITY_xxx to buff, for vision buffs it's unused.
//		nVfx - The visual effect to apply at cast time.
//		nDurVfx - The visual effect to apply during the spell's duration.
//
/////////////////////////////////////////////////////////////////////////////////

const int MASSBUFF_STAT =			0;
const int MASSBUFF_VISION =			1;

void DoMassBuff (int nBuffType, int nBuffSubType, int nSpellID = -1)
{
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = GetSpellTargetLocation();

	// Get the spell ID if it was not given.
	if (-1 == nSpellID) nSpellID = GetSpellId();
	
	// Get the effective caster level.
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);

	// Load the visual effects.
    effect eVis;
    effect eDur;
	switch (nBuffType)
	{
	case MASSBUFF_STAT:
	    eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
	    eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		break;
	case MASSBUFF_VISION:
		// No visible effect for this?
		eDur = EffectVisualEffect(VFX_DUR_ULTRAVISION);
		eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
		eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
		break;
	}

	float fDelay;

	// Determine the spell's duration.
	float fDuration = SPGetMetaMagicDuration(HoursToSeconds(SPGetCasterLevel(OBJECT_SELF)));
	
	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
//		if (GetIsReactionTypeFriendly(oTarget))
		{
			//Fire cast spell at event for the specified target
			SPRaiseSpellCastAt(oTarget, FALSE);

			fDelay = GetSpellEffectDelay(lTarget, oTarget);

			// Calculate stat mod and adjust for metamagic.			
			int nStatMod = SPGetMetaMagicDamage(-1, 1, 4, 0, 1);

			// Create the appropriate buff effect and link the duration visual fx to it.
			effect eBuff;			
			switch (nBuffType)
			{
			case MASSBUFF_STAT:
				eBuff = EffectLinkEffects (EffectAbilityIncrease(nBuffSubType, nStatMod), eDur);
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration));
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				break;
			case MASSBUFF_VISION:
				eBuff = EffectLinkEffects (EffectUltravision(), eDur);
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration));
				break;
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

	SPSetSchool();
}
