#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(460);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(1));

    if (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 0)
    {
        SetLocalInt(OBJECT_SELF, "archmage_mastery_shaping", 1);
        FloatingTextStringOnCreature("Mastery of Shaping: friends protection enabled.", OBJECT_SELF, FALSE);
    }
    else
    {
        SetLocalInt(OBJECT_SELF, "archmage_mastery_shaping", 0);
        FloatingTextStringOnCreature("Mastery of Shaping: friends protection disabled.", OBJECT_SELF, FALSE);
    }
}
