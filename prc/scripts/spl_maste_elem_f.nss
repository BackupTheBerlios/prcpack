#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(1));

    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", DAMAGE_TYPE_FIRE);
    FloatingTextStringOnCreature("Mastery of Elements: Spells damage to fire.", OBJECT_SELF, FALSE);
}
