#include "spinc_common"
#include "spinc_burst"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	// Get the number of damage dice.    
    int nDice = SPGetCasterLevel();
    if (nDice > 10) nDice = 10;
    
	// Ice burst is a colossal radius burst doing 1d4+10/level (cap at 10) cold damage.
	DoBurst (4, 1, nDice, 
		VFX_FNF_ICESTORM, VFX_IMP_FROST_S, 
		RADIUS_SIZE_GARGANTUAN, DAMAGE_TYPE_COLD, SAVING_THROW_TYPE_COLD);
}
