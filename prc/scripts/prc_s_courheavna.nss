//::///////////////////////////////////////////////
//:: [Censure Daemons]
//:: [prc_s_censuredm.nss]
//:://////////////////////////////////////////////
//:: All allies in the area are immune to fear
//:: and other mind effects created by outsiders
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
    object oTarget = GetEnteringObject();
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //Declare major variables
        int nDuration = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
        //effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
        effect eIFear = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_FEAR), RACIAL_TYPE_OUTSIDER);
        effect eICharm = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_CHARM), RACIAL_TYPE_OUTSIDER);
        effect eIConf = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_CONFUSED), RACIAL_TYPE_OUTSIDER);
        effect eIDaze = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_DAZED), RACIAL_TYPE_OUTSIDER);
        effect eIDomin = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_DOMINATE), RACIAL_TYPE_OUTSIDER);
        effect eIMind = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), RACIAL_TYPE_OUTSIDER);
        effect eISleep = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_SLEEP), RACIAL_TYPE_OUTSIDER);
        effect eIStun = VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_STUN), RACIAL_TYPE_OUTSIDER);
        effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);

        effect eLink = EffectLinkEffects(eIFear, eICharm);
               eLink = EffectLinkEffects(eLink, eIConf);
               eLink = EffectLinkEffects(eLink, eIDaze);
               eLink = EffectLinkEffects(eLink, eIDomin);
               eLink = EffectLinkEffects(eLink, eIMind);
               eLink = EffectLinkEffects(eLink, eISleep);
               eLink = EffectLinkEffects(eLink, eIStun);
               eLink = EffectLinkEffects(eLink, eDur);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
     }
}
