#include "spinc_common"
#include "nw_i0_generic"
#include "x0_inc_generic"

//
// Does the disintegrate logic.
//
void DoDisintegrate(object oCaster, object oTarget, int nSpellSaveDC)
{
	// Make SR check
	if (!SPResistSpell(oCaster, oTarget))
	{
		// Make the touch attack.	            
		int nTouchAttack = TouchAttackMelee(oTarget);
		if (nTouchAttack > 0)
		{
			// Generate the RTA beam.	
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
				EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_CHEST), oTarget, 1.0);

			// Fort save or die time, but we implement death by doing massive damage
			// since disintegrate works on constructs, undead, etc.  At some point EffectDie()
			// should be tested to see if it works on non-living targets, and if it does it should
			// be used instead.
			int nDamage = 9999;
			if (MySavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, 
				SAVING_THROW_TYPE_SPELL, oCaster))
				nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 
					1 == nTouchAttack ? 5 : 10, 6, 0, 0, 0); 
			
			// Apply damage effect and VFX impact, and if the target is dead then apply
			// the fancy rune circle too.
			if (nDamage >= GetCurrentHitPoints (oTarget)) 
				DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), oTarget));
			DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, DAMAGE_TYPE_MAGICAL), oTarget));
			DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget));
		}
	}
}


//
// Returns TRUE if we are in our busy state.
//
int IsBusy()
{
	return GetLocalInt(OBJECT_SELF, "SP_BUSY");
}

//
// Sets/clears the busy state.
//
void SetBusy(int value)
{
	SetLocalInt(OBJECT_SELF, "SP_BUSY", value);
}


//
// Main AI function.  This is invoked by DetermineCombatRound() as it is provided
// as an override to the AI in the sphere's creature template.
//
// Known issues: The sphere still takes AOO's, when it shouldn't.
//
void main()
{
	object oCaster = GetFactionLeader(OBJECT_SELF);
	//SendMessageToPC(oCaster, "sp_ai_sphereofud entering");
	
	// Get the intruder object, the NWN AI saves it in a local variable for us.
	object oIntruder = GetCreatureOverrideAIScriptTarget();
	ClearCreatureOverrideAIScriptTarget();

	// If we don't have a valid enemy then try to find one to pick on.
    if (!GetIsObjectValid(oIntruder) || GetIsDead(oIntruder)) 
		oIntruder = bkAcquireTarget();
	//SendMessageToPC(oCaster, "sp_ai_sphereofud ENEMY = " + GetName(oIntruder));

	// If we don't have an intruder or he's dead then just exit.
    if (!GetIsObjectValid(oIntruder) || GetIsDead(oIntruder)) return;

	// Call AI finished at this point to prevent the default combat AI from running,
	// once we aquire a valid target our AI takes over (we just want to run around
	// and disintegrate things).
	SetCreatureOverrideAIScriptFinished();

	// If we are busy then do nothing.  This is expected behavior because our
	// disintegrate attack is not an action, and thus takes 0 time from the AI's
	// point of view.  We put ourselves in a busy state to wait a round before
	// attacking again.
	if (IsBusy()) 
	{
		//SendMessageToPC(oCaster, "sp_ai_sphereofud BUSY");
		return;
	}

	// Set our busy state.    
	SetBusy(TRUE);
	
	// We have an enemy see if we are in touch attach range.  This range varies
	// depending on the enemie's size, currently it's a fudge number that seems to
	// work ok.
	float fDistance = GetDistanceBetween(OBJECT_SELF, oIntruder);
	//SendMessageToPC(oCaster, "sp_ai_sphereofud range to ENEMEY " + FloatToString(fDistance));
	if (fDistance > 3.0)
	{
		// We are too far for a touch attack, close to the enemy if we aren't already.
		// Once we start closing it is pointless to spam the action queue with close
		// requests.
		if (ACTION_MOVETOPOINT != GetCurrentAction(OBJECT_SELF))
		{
			//SendMessageToPC(oCaster, "sp_ai_sphereofud closing with ENEMY");
			ActionForceMoveToObject(oIntruder, TRUE);
		}
		//else
		//SendMessageToPC(oCaster, "sp_ai_sphereofud waiting to close");

		// Clear the busy state so we can handle more actions.  Ideally we should
		// remain busy until we close, but there is no way to know when this happens.
		SetBusy(FALSE);
	}
	else
	{
		// Clear our action list of any other actions just in case.
		ClearAllActions();

		// Attempty to disintegrate the current target.
		//SendMessageToPC(oCaster, "Disintegrating, BUSY for 1 round");
		object oSphere = OBJECT_SELF;
		DoDisintegrate(oCaster, oIntruder, GetLocalInt(oCaster, "SP_SPHEREOFUD_DC"));
		
		// Wait a round to clear our busy state which will keep our attacks
		// to 1 per round.
		DelayCommand(RoundsToSeconds(1), SetBusy(FALSE));
	}
}
