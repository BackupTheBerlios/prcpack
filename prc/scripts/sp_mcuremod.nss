#include "spinc_common"
#include "spinc_masscure"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoMassCure (2, 30, VFX_IMP_HEALING_M);
}
