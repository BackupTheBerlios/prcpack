//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oTarget = GetEnteringObject();
    int nHD = GetHitDice(oTarget);
    effect eDeath = EffectDeath();
    effect eVis =   EffectVisualEffect(VFX_IMP_DEATH);
    effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eSpeed = EffectMovementSpeedDecrease(50);
    effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eSpeed, eVis2);

    float fDelay= GetRandomDelay(0.5, 1.5);
    effect eDam;
    int nDam = d8(2);
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        int nDam = 16;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        int nDam =  nDam + (nDam/2); //Damage/Healing is +50%
    }
    eDam = EffectDamage(nDam, ChangedElementalDamage(GetAreaOfEffectCreator(), DAMAGE_TYPE_ACID));
    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator()) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));
        //Make SR Check
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
            //Determine spell effect based on the targets HD
            if (nHD <= 3)
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                }
            }
            else if (nHD >= 4 && nHD <= 6)
            {
                //Make a save or die
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(GetAreaOfEffectCreator())), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(GetAreaOfEffectCreator())), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
                    }
                }
            }
            else
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);

            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}