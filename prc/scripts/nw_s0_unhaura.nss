//::///////////////////////////////////////////////
//:: Unholy Aura
//:: NW_S0_UnhAura.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The cleric casting this spell gains +4 AC and
    +4 to saves. Is immune to Mind-Affecting Spells
    used by Good creatures and gains an SR of 25
    versus the spells of Good Creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"

#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    RemoveSpellEffects(GetSpellId(),OBJECT_SELF,GetSpellTargetObject());

    doAura(ALIGNMENT_GOOD, VFX_DUR_PROTECTION_EVIL_MAJOR, VFX_DUR_PROTECTION_EVIL_MAJOR, DAMAGE_TYPE_NEGATIVE);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

