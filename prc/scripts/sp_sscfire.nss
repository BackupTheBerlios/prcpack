#include "spinc_common"
#include "spinc_cone"
#include "spinc_serpsigh"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoCone (6, 0, 10, -1, VFX_IMP_FLAME_S, 
		DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE, 
		SPELL_SCHOOL_EVOCATION, SPELL_SERPENTS_SIGH);
		
	DamageSelf (10, VFX_IMP_FLAME_S);
}
