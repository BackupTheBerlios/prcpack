#include "spinc_common"
#include "spinc_burst"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	// Get the number of damage dice.    
    int nDice = SPGetCasterLevel();
    if (nDice > 15) nDice = 15;
    
	// Acid storm is a huge burst doing 1d6 / lvl acid damage (15 cap)
	DoBurst (6, 0, nDice, 
		AOE_PER_STORM, VFX_IMP_ACID_S, 
		RADIUS_SIZE_HUGE, DAMAGE_TYPE_ACID, SAVING_THROW_TYPE_ACID,
		FALSE, SPELL_SCHOOL_EVOCATION, GetSpellId(), 6.0);

	// Add some extra sfx.		
	PlaySound("sco_swar3blue");
}
