//::///////////////////////////////////////////////
//:: [Acrobatic Attack]
//:: [prc_s_acroatk.nss]
//:://////////////////////////////////////////////
//:: Leaps at a target. Inflicting d6 / 2 duelist
//:: levels + dex bonus damage and knockdown for
//:: 1 round.  Reflex save verus 10 + duelist
//:: level + dex bonus for half damage and no
//:: knockdown.
//::
//:: Attack/Damage bonus of +2 or +4 for 1 round
//::
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 21, 2003
//:://////////////////////////////////////////////

#include "nw_i0_spells"

void main()
{
    //Declare major variables
    int nWis = GetAbilityModifier(ABILITY_WISDOM);
    int nBonus = nWis;

    if(GetHasFeat(FEAT_FREE_KI_2, OBJECT_SELF))
        nBonus += nWis;
    if(GetHasFeat(FEAT_FREE_KI_3, OBJECT_SELF))
        nBonus += nWis;
    if(GetHasFeat(FEAT_FREE_KI_4, OBJECT_SELF))
        nBonus += nWis;

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
    effect eLink = EffectLinkEffects(eVis, eSkill);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(2));
}
