#include "spinc_common"
#include "spinc_massbuff"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoMassBuff (MASSBUFF_STAT, ABILITY_INTELLIGENCE);
}
