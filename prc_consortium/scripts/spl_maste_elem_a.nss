#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(448);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(1));

    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", DAMAGE_TYPE_ACID);
    FloatingTextStringOnCreature("Mastery of Elements: Spells damage to acid.", OBJECT_SELF, FALSE);
}
