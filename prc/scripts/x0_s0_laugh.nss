//::///////////////////////////////////////////////
//:: Tasha's Hideous Laughter
//:: [x0_s0_laugh.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target is held, laughing for the duration
    of the spell (1d3 rounds)

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"

#include "X0_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
    effect eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);


    int nDuration = d3(1);


    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }


    int nModifier = 0;

    // * creatures of different race find different things funny
    if (MyPRCGetRacialType(oTarget) != MyPRCGetRacialType(OBJECT_SELF))
    {
        nModifier = 4;
    }
    if(!GetIsReactionTypeFriendly(oTarget) && spellsIsMindless(oTarget) == FALSE)
    {
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget) && !/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, ((GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF))-nModifier), SAVING_THROW_TYPE_MIND_SPELLS))
        {
            effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TASHAS_HIDEOUS_LAUGHTER));
            float fDur = RoundsToSeconds(nDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDur);

        /*    string szLaughMale = "as_pl_laughingm2";
            string szLaughFemale = "as_pl_laughingf3";

            if (GetGender(oTarget) == GENDER_FEMALE)
            {
                PlaySound(szLaughFemale);
            }
            else
            {
                PlaySound(szLaughMale);
            }      */
            AssignCommand(oTarget, ClearAllActions());
            AssignCommand(oTarget, PlayVoiceChat(VOICE_CHAT_LAUGH));
            AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
            effect eLaugh = EffectKnockdown();
            DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLaugh, oTarget, fDur));
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}




