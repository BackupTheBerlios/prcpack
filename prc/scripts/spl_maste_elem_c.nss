#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(VFX_IMP_AC_BONUS);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(40));

    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", DAMAGE_TYPE_COLD);
    FloatingTextStringOnCreature("Mastery of Elements: Spells damage to cold.", OBJECT_SELF, FALSE);
}
