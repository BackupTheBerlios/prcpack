#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

/*
 * This is the spellhook code, called when the Spell-Like feat is activated
 */
void main()
{
    object focus = GetItemPossessedBy(OBJECT_SELF, "ArchmagesFocusofPower");
    int nMetaMagic = GetMetaMagicFeat();
    string nSpellLevel = Get2DAString("spells", "Wiz_Sorc", GetSpellId());
    string nEpicSpell = Get2DAString("spells", "Innate", GetSpellId());

    /* Whatever happens next we must restore the hook */
    SetModuleOverrideSpellscript(GetLocalString(GetModule(), "spelllike_save_overridespellscript"));

    /* Tell to not execute the original spell */
    SetModuleOverrideSpellScriptFinished();

    /* Paranoia -- should never happen */
    if (!GetHasFeat(FEAT_SPELL_LIKE, OBJECT_SELF)) return;

    /* Only wizard/sorc spells */
    if ((nSpellLevel == "") && (nEpicSpell != "10" ))
    {
        FloatingTextStringOnCreature("Spell-Like can only use arcane spells.", OBJECT_SELF, FALSE);
        return;
    }

    /* No item casting */
    if (GetIsObjectValid(GetSpellCastItem()))
    {
        FloatingTextStringOnCreature("Spell-Like may not be used with scrolls.", OBJECT_SELF, FALSE);
        return;
    }

    /* Setup is done */
    SetLocalInt(focus, "spell_like_setup", 0);

    /* Store all the info needed */
    SetLocalInt(focus, "spell_like_spell", GetSpellId());
    SetLocalInt(focus, "spell_like_meta", nMetaMagic);

    FloatingTextStringOnCreature("Spell-Like ability ready.", OBJECT_SELF, FALSE);
}
