#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(460);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(40));

    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", 0);
    FloatingTextStringOnCreature("Mastery of Elements: Spells damage set back to normal.", OBJECT_SELF, FALSE);
}
