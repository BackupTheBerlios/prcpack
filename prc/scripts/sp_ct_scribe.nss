#include "spinc_common"

void main()
{
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Get the tatoo data from the local variables.
	int nSpellID = GetLocalInt(OBJECT_SELF, "SP_CREATETATOO_SPELLID");
	int nMetaMagic = GetLocalInt(OBJECT_SELF, "SP_CREATETATOO_METAMAGIC");
	object oTarget = GetLocalObject(OBJECT_SELF, "SP_CREATETATOO_TARGET");
	int nEffect = GetLocalInt(OBJECT_SELF, "SP_CREATETATOO_EFFECT");
	
	// Delete the local variables, we don't need them any more.
	DeleteLocalInt(OBJECT_SELF, "SP_CREATETATOO_LEVEL");
	DeleteLocalInt(OBJECT_SELF, "SP_CREATETATOO_SPELLID");
	DeleteLocalInt(OBJECT_SELF, "SP_CREATETATOO_METAMAGIC");
	DeleteLocalInt(OBJECT_SELF, "SP_CREATETATOO_EFFECT");
	DeleteLocalObject(OBJECT_SELF, "SP_CREATETATOO_TARGET");

	int nCasterLevel = SPGetCasterLevel();
	
	int nDC = 0;
	string message = "";
	effect eBuff;
	switch(nEffect)
	{
		case 1:		// SR 10 + CL / 6
		{
			// This tatoo is supposed to give the creature SR x.  But the effects
			// add to any existing SR, so we have to check to see what the current
			// SR is and increase it as appropriate.
			nDC = 20;
			int nSR = 10 + nCasterLevel / 6;
			int nCurrentSR = GetSpellResistance(oTarget);
			if (nSR > nCurrentSR)
			{
				eBuff = EffectSpellResistanceIncrease(nSR - nCurrentSR);
				message = "Scribing spell resistance " + IntToString(nSR) + " tatoo.";
			}
			break;
		}
		case 2:		// +2 STR
			nDC = 20;
			eBuff = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
			message = "Scribing +2 strength tatoo.";
			break;
		case 3:		// +2 DEX
			nDC = 20;
			eBuff = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
			message = "Scribing +2 dexterity tatoo.";
			break;
		case 4:		// +2 CON
			nDC = 20;
			eBuff = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
			message = "Scribing +2 constitution tatoo.";
			break;
		case 5:		// +2 INT
			nDC = 20;
			eBuff = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2);
			message = "Scribing +2 intelligence tatoo.";
			break;
		case 6:		// +2 WIS
			nDC = 20;
			eBuff = EffectAbilityIncrease(ABILITY_WISDOM, 2);
			message = "Scribing +2 wisdom tatoo.";
			break;
		case 7:		// +2 CHA
			nDC = 20;
			eBuff = EffectAbilityIncrease(ABILITY_CHARISMA, 2);
			message = "Scribing +2 charisma tatoo.";
			break;
		case 8:		// +2 all saves
			nDC = 15;
			eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
			message = "Scribing +2 to all saves tatoo.";
			break;
		case 9:		// +2 attacks
			nDC = 15;
			eBuff = EffectAttackIncrease(2);
			message = "Scribing +2 to attacks tatoo.";
			break;
		case 10:	// +2 FORT
			nDC = 10;
			eBuff = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);
			message = "Scribing +2 to fortitude saves tatoo.";
			break;
		case 11:	// +2 REF
			nDC = 10;
			eBuff = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2);
			message = "Scribing +2 to reflex saves tatoo.";
			break;
		case 12:	// +2 WIL
			nDC = 10;
			eBuff = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);
			message = "Scribing +2 to will saves tatoo.";
			break;
		case 13:	// +1 attack
			nDC = 10;
			eBuff = EffectAttackIncrease(1);
			message = "Scribing +1 to attacks tatoo.";
			break;
		case 14:	// +1 deflection to AC
			nDC = 10;
			eBuff = EffectACIncrease(1, AC_DEFLECTION_BONUS);
			message = "Scribing +1 deflection bonus to AC tatoo.";
			break;
	}

	// If we have a valid tatoo then scribe it.
	if ("" != message)
	{
		// Make a lore skill check at the given DC, if successful then scribe
		// the tatoo, if not let the caster know he failed.
		if (GetIsSkillSuccessful(OBJECT_SELF, SKILL_LORE, nDC))
		{
			// Let the caster know what tatoo we are scribing.
			SendMessageToPC(OBJECT_SELF, message);
			
			// Get the duration of the tatoo, taking meta magic into account, and apply
			// the buff to the target.
			float fDuration = SPGetMetaMagicDuration(HoursToSeconds(24), nMetaMagic);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,
				TRUE, nSpellID, nCasterLevel);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
				EffectVisualEffect(VFX_IMP_RESTORATION_LESSER), oTarget);
		}
		else
			SendMessageToPC(OBJECT_SELF, "You failed to scribe the tatoo.");
	}

	SPSetSchool();
}
