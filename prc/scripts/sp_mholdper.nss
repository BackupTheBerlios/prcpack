#include "spinc_common"


int BiowareHoldPerson (int nCasterLvl, int nMeta, object oTarget, float fDelay);

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = GetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = SPGetCasterLevel(OBJECT_SELF);

	// Apply a fancy effect for such a high level spell.
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), lTarget);
	
	int nMetaMagic = GetMetaMagicFeat();
	float fDelay;
	
	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	int nTargets = 0;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		fDelay = GetSpellEffectDelay(lTarget, oTarget);
		
		// Run the Bioware hold person script on the target, if the target is a valid target for the script increment
		// our target count and check to see if we've used up all our targets, if we have then exit out of the loop.
		if (BiowareHoldPerson (nCasterLvl, nMetaMagic, oTarget, fDelay)) nTargets++;
		if (nTargets >= nCasterLvl) break;
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	SPSetSchool();
}



//::///////////////////////////////////////////////
//:: This function is a cut and past of the bioware hold person logic, with the 
//:: changes of having it's effect delayed by fDelay and returning whether the target
//:: was a valid target or not.
//:://////////////////////////////////////////////

int BiowareHoldPerson (int nCasterLvl, int nMeta, object oTarget, float fDelay)
{
	int nValidTarget = 0;
	
    //Declare major variables
//    int nDuration = nCasterLvl;
//    nDuration = GetScaledDuration(nDuration, oTarget);
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(GetScaledDuration(nCasterLvl, oTarget)));
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(82);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    
    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur3);

	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SPRaiseSpellCastAt(oTarget);
        
        //Make sure the target is a humanoid
        if (GetIsPlayableRacialType(oTarget) ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN)
        {
			nValidTarget = 1;
			
            //Make SR Check
            if (!SPResistSpell(OBJECT_SELF, oTarget))
    	    {
                //Make Will save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, SPGetSpellSaveDC()))
                {
                    //Make metamagic extend check
//                    if (nMeta == METAMAGIC_EXTEND)
//                    {
//                        nDuration = nDuration * 2;
//                    }
                    //Apply paralyze effect and VFX impact
//                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                }
            }
        }
    }
    
    return nValidTarget;
}
