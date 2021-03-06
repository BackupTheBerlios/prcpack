#include "spinc_common"
#include "spinc_burst"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	// Get the damage dice.
	int nDice = (SPGetCasterLevel() + 1) / 2;
	if (nDice > 5) nDice = 5;

	// Ice burst is a colossal radius burst doing 1d4+10/level (cap at 10) cold damage.
	DoBurst (6, 0, nDice, 
		VFX_IMP_FROST_L, VFX_IMP_FROST_S, 
		RADIUS_SIZE_MEDIUM, DAMAGE_TYPE_COLD, SAVING_THROW_TYPE_COLD);
}
