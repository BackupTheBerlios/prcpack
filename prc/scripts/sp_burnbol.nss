/////////////////////////////////////////////////////////////////////
//
// Burning Bolt, fires 1 rta fire bolt doing 1d4+1 damage, +1 bolt
// for ever 2 levels above first.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oTarget = GetSpellTargetObject();
	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
		int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);
		int nCnt;
		effect eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
		effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
		int nMissiles = (nCasterLvl + 1)/2;
		float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
		float fDelay = fDist/(3.0 * log(fDist) + 2.0);
		float fDelay2, fTime;
		
		//Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget);

		// Get the proper damage type adjusted for classes/feats.
		int nDamageType = SPGetElementalDamageType(DAMAGE_TYPE_FIRE);
		
		//Make SR Check
		if (!SPResistSpell(OBJECT_SELF, oTarget, fDelay))
		{
			//Apply a single damage hit for each missile instead of as a single mass
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				int nDamage = 0;
				int nTouchAttack = TouchAttackRanged(oTarget);
				if (nTouchAttack > 0)
					nDamage = SPGetMetaMagicDamage(nDamageType, 1 == nTouchAttack ? 1 : 2, 4, 1);
				
				fTime = fDelay;
				fDelay2 += 0.1;
				fTime += fDelay2;

				// If the touch attack hit apply the damage and the damage visual effect.
				if (nDamage > 0)
				{
					effect eDamage = SPEffectDamage(nDamage, SPGetElementalDamageType(nDamageType, OBJECT_SELF));
					DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
					DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
				
				// Always apply the MIRV effect because we're trying to hit the target whether we
				// actually succeed or not.
				DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
			}
		}
		else
		{
			// SR check failed, have to make animation for missiles but no damage.
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
			}
		}
	}
	
	SPSetSchool();
}
