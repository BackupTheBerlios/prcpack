#include "spinc_common"
#include "spinc_bolt"
#include "spinc_serpsigh"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	// Get the number of damage dice.    
    int nCasterLevel = SPGetCasterLevel(OBJECT_SELF);
    int nDice = nCasterLevel > 10 ? 10 : nCasterLevel;
    
	DoBolt (6, 0, nDice, 447 /* VFX_BEAM_DISINTEGRATE */, VFX_IMP_ACID_S,
		DAMAGE_TYPE_ACID, SAVING_THROW_TYPE_ACID,
		SPELL_SCHOOL_EVOCATION, FALSE, SPELL_SERPENTS_SIGH);
		
	DamageSelf (10, VFX_IMP_ACID_S);
}

