/////////////////////////////////////////////////////////////////////
//
// DoTransposition - Function to transpose transpose the spellcaster
// with a target creature.
//		bAllowHostile - If this flag is FALSE then the target creature
//		must be a member of the caster's party (have the same faction
//		leader).  If this flag is false then it may be a party member
//		or a hostile creature.
//
/////////////////////////////////////////////////////////////////////


//
// Displays transposition VFX.
//

void TransposeVFX(object o1, object o2)
{
	// Apply vfx to the creatures moving.
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_X);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o1);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o2);
}


//
// Transposes the 2 creatures.
//

void Transpose(object o1, object o2)
{
	// Get the locations of the 2 creatures to swap, keeping the facings
	// the same.
	location loc1 = Location(GetArea(o1), GetPosition(o1), GetFacing(o2));
	location loc2 = Location(GetArea(o2), GetPosition(o2), GetFacing(o1));
	
	// Swap the creatures.
	AssignCommand(o2, JumpToLocation(loc1));
	AssignCommand(o1, JumpToLocation(loc2));
	
	DelayCommand(0.1, TransposeVFX(o1, o2));
}


void DoTransposition(int bAllowHostile)
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_CONJURATION);

	// TODO: check SR and save for baleful targets.
	
	object oTarget = GetSpellTargetObject();
	if (!GetIsDead(oTarget))
	{
		// Get the spell target.  If he has the same faction leader we do (i.e. he's in the party)
		// or he's a hostile target and hostiles are allowed then we will do the switch.
		int bParty = GetFactionLeader(oTarget) == GetFactionLeader(OBJECT_SELF);
		if (bParty || (bAllowHostile && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)))
		{
			// Targets outside the party get a will save and SR to resist.
			if (bParty || 
				(!SPResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, SPGetSpellSaveDC())))
			{
				//Fire cast spell at event for the specified target
				SPRaiseSpellCastAt(oTarget, !bParty);

				// Move the creatures.
				DelayCommand(0.1, Transpose(OBJECT_SELF, oTarget));
			}
		}		
	}
		
	SPSetSchool();
}
