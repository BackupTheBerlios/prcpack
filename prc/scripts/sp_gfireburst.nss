/////////////////////////////////////////////////////////////////////
//
// Greater Firestorm - Burst of fire centered on the caster doing 
// 1d8/lvl, max 15d8
//
/////////////////////////////////////////////////////////////////////

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
	DoBurst (8, 0, nDice, 
		VFX_FNF_FIREBALL, VFX_IMP_FLAME_M, 
		RADIUS_SIZE_MEDIUM, DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE);
}
