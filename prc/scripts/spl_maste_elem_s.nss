#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(VFX_FNF_SOUND_BURST);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(1));

    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", DAMAGE_TYPE_SONIC);
    FloatingTextStringOnCreature("Mastery of Elements: Spells damage to sonic.", OBJECT_SELF, FALSE);
}
