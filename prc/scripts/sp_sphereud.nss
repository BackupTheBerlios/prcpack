#include "spinc_common"

void main()
{
	if (!X2PreSpellCastCode()) return;

	// Calculate spell duration.
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(SPGetCasterLevel()));

	// Apply summon and vfx at target location.	
	location lTarget = GetSpellTargetLocation();
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
		EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
		EffectSummonCreature("sp_sphereofud"), lTarget, fDuration);
	
	// Save the spell DC for the spell so the sphere can use it.
	int nSaveDC = SPGetSpellSaveDC();
	SetLocalInt(OBJECT_SELF, "SP_SPHEREOFUD_DC", nSaveDC);
}
