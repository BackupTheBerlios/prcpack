//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

#include "heartward_inc"
// shaken   -2 attack,weapon dmg,save.
// panicked -2 save + flee away ,50 % drop object holding
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    if (GetRacialType(oTarget)==IP_CONST_RACIALTYPE_DRAGON || MyPRCGetRacialType(oTarget)== IP_CONST_RACIALTYPE_DRAGON )
      return;

    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eFear = EffectFrightened();
    effect eAttackD = EffectAttackDecrease(2);
    effect eDmgD = EffectDamageDecrease(2,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
    effect SaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eAttackD);
    eLink = EffectLinkEffects(eLink, eDmgD);
    effect eLink2 = EffectLinkEffects(eLink, SaveD);
    eLink = EffectLinkEffects(eLink, eFear);


    int nHD = GetHitDice(GetAreaOfEffectCreator());
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC,GetAreaOfEffectCreator())+ GetAbilityModifier(ABILITY_CHARISMA,GetAreaOfEffectCreator());
    int nDuration = d6(2);
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator())&& GetHitDice(oTarget)<=GetHitDice(GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
        {
            int HD=GetHitDice(oTarget);

            if (HD<5)
            //Apply the VFX impact and effects
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            else
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
