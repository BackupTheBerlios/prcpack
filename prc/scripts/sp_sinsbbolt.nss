#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
    // Set the lightning stream to start at the caster's hands
    effect eBolt = EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;

	// Calculate bonus damage to the str/con drain.
	int nCasterLevel = SPGetCasterLevel();
	int nBonusDam = nCasterLevel / 4;
	if (nBonusDam > 3) nBonusDam = 3;
	
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        while (GetIsObjectValid(oTarget))
        {
			// Exclude the caster from the damage effects
			if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
			{
            	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
					//Fire cast spell at event for the specified target
					SPRaiseSpellCastAt(oTarget, TRUE);

					//Make an SR check
					if (!SPResistSpell(OBJECT_SELF, oTarget))
					{
						// Roll the drain damage and adjust for a reflex save/evasion.
						int nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 1, 3, nBonusDam);
						nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 
							SPGetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE);

						// Apply str/con drain if any.
						if(nDamage > 0)
						{
							effect eDamage = EffectAbilityDecrease(ABILITY_STRENGTH, nDamage);
							eDamage = EffectLinkEffects(eDamage,
								EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage));
								
							SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
							SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						}
					}

					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0);

					// Set the currect target as the holder of the lightning effect
					oNextTarget = oTarget;
					eBolt = EffectBeam(VFX_BEAM_BLACK, oNextTarget, BODY_NODE_CHEST);
				}
			}
           
			//Get the next object in the lightning cylinder
			oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
		}
        
		nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
	}
	
	SPSetSchool();
}
