#include "spinc_common"

//
// Get the number of tatoo effects currently on the target.
//
int GetTatooCount(object oTarget, int nSpellID)
{
	// Loop through all of the effects on the target, counting
	// the number of them that have this spell ID.
	int nTatoos = 0;
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		if (nSpellID == GetEffectSpellId(eEffect)) nTatoos++;
		eEffect = GetNextEffect(oTarget);
	}
		
	return nTatoos;
}


void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	object oTarget = GetSpellTargetObject();

	// The real scribe tatoo spell is the next spell in the 2da file after us, so
	// get it's spell ID.
	int nTatooSpellID = GetSpellId() + 1;
	
	if (GetIsPC(OBJECT_SELF))
	{
		// A creature is only allowed 3 tatoos, check the number they have to make
		// sure we have room to add another.
		int nTatoo = GetTatooCount(oTarget, nTatooSpellID);
		if (nTatoo >= 3)
		{
			// Let the caster know they cannot add another tatoo to the target.
			SendMessageToPC(OBJECT_SELF, GetName(oTarget) + " already has 3 tatoos.");
		}
		else
		{
			// Raise the spell cast event.
			SPRaiseSpellCastAt(oTarget, FALSE);

			// Save the ID of the tatoo spell (so the conversation scripts can cast it),
			// and save the metamagic and target.  Then invoke the conversation to
			// let the caster pick what tatoo to scribe.
			SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_LEVEL", SPGetCasterLevel());
			SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_SPELLID", nTatooSpellID);
			SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_METAMAGIC", SPGetMetaMagic());
			SetLocalObject(OBJECT_SELF, "SP_CREATETATOO_TARGET", oTarget);
			ActionStartConversation(OBJECT_SELF, "sp_createtatoo", FALSE, FALSE);
		}
	}
	
	SPSetSchool();
}
