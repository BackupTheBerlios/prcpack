#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"

//function prototypes
int MyPRCResistSpell(object oCaster, object oTarget, float fDelay = 0.0);
int ChangedElementalDamage(object oCaster, int nDamageType);
int GetChangesToCasterLevel(object oCaster);
int GetChangesToSaveDC(object oCaster);
int MyPRCGetRacialType(object oTarget);
// * Generic reputation wrapper
// * definition of constants:
// * SPELL_TARGET_ALLALLIES = Will affect all allies, even those in my faction who don't like me
// * SPELL_TARGET_STANDARDHOSTILE: 90% of offensive area spells will work
//   this way. They will never hurt NEUTRAL or FRIENDLY NPCs.
//   They will never hurt FRIENDLY PCs
//   They WILL hurt NEUTRAL PCs
// * SPELL_TARGET_SELECTIVEHOSTILE: Will only ever hurt enemies
int spellsIsTarget(object oTarget, int nTargetType, object oSource);



// * Constants
// * see spellsIsTarget for a definition of these constants
const int SPELL_TARGET_ALLALLIES = 1;
const int SPELL_TARGET_STANDARDHOSTILE = 2;
const int SPELL_TARGET_SELECTIVEHOSTILE = 3;
const int SAVING_THROW_NONE = 4;





int MyPRCResistSpell(object oCaster, object oTarget, float fDelay = 0.0){

    int nTargetSR = GetSpellResistance(oTarget);
    if(nTargetSR < 1)
        return 0;

    int nResist = 0;

    //preliminary checks that can avoid the heavy calculations
    //if(!GetIsReactionTypeHostile(oTarget, oCaster)){
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
        if(GetLocalInt(oCaster, "archmage_mastery_shaping") == 1){
            if(GetHasFeat(FEAT_MASTERY_SHAPES, oCaster)){
                nResist = 3;
            }
        }
    }

    //heavy calculations done here
    if(nResist==0){

        int nCasterLevel = GetLocalInt(OBJECT_SELF, "LastCalcuAddonSRDC");

        if(nCasterLevel<1){
            //base DC value
            nCasterLevel =  GetCasterLevel(oCaster) +
                                ExecuteScriptAndReturnInt("prc_caster_level", oCaster);

            //modifiers
            if(GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
                nCasterLevel += 6;
            else if(GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster))
                nCasterLevel += 4;
            else if(GetHasFeat(FEAT_SPELL_PENETRATION, oCaster))
                nCasterLevel += 2;
            nCasterLevel += ExecuteScriptAndReturnInt("prc_add_spl_pen", oCaster);
            SetLocalInt(oCaster, "LastCalcuAddonSRDC", nCasterLevel);
            DelayCommand(2.0, DeleteLocalInt(oCaster, "LastCalcuAddonSRDC"));
        }
        //the test
        int nRolled = d20(1);
        if(nCasterLevel + nRolled <  nTargetSR)
            nResist = 1;
        else{
            nResist = ResistSpell(oCaster, oTarget);
                  if(nResist == 1)
                  {
                   nResist = 0;
                  }
            }
    }

    //if resisted, apply visual effect
    if(nResist>0){

        effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
        effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
        effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);

        if(nResist == 1) //Spell Resistance
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
        else if(nResist == 2) //Globe
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
        else if(nResist == 3) //Spell Mantle
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
    }

    return nResist;
}




int GetChangesToCasterLevel(object oCaster){
    return ExecuteScriptAndReturnInt("prc_caster_level", oCaster);
}




int GetChangesToSaveDC(object oCaster){
    return ExecuteScriptAndReturnInt("prc_add_spell_dc", oCaster);
}




int ChangedElementalDamage(object oCaster, int nDamageType){
    int nNewType = ExecuteScriptAndReturnInt("prc_set_dmg_type", oCaster);
    if(nNewType != 0){
        nDamageType = nNewType;
    }
    return nDamageType;
}




int MyPRCGetRacialType(object oCreature)
{
    if (GetLevelByClass(CLASS_TYPE_LICH,oCreature) >= 4)
        return RACIAL_TYPE_UNDEAD;
    if (GetLevelByClass(CLASS_TYPE_MONK,oCreature) >= 20)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_OOZEMASTER,oCreature) >= 10)
        return RACIAL_TYPE_OOZE;
    if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE,oCreature) >= 10)
        return RACIAL_TYPE_DRAGON;
    if (GetLevelByClass(CLASS_TYPE_ACOLYTE,oCreature) >= 10)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_ES_FIRE,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_COLD,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ELEC,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ACID,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_HEARTWARDER,oCreature) >= 10)
        return RACIAL_TYPE_FEY;
    // check for a local variable that overrides the race
    // the shifter will use this everytime they change
    // the racial types are zero based, use 1 based to ensure the variable is set
    int nRace = GetLocalInt(oCreature,"RACIAL_TYPE");
    if (nRace)
        return (nRace-1);
    return GetRacialType(oCreature);
}

//::///////////////////////////////////////////////
//:: spellsIsTarget
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the reputation wrapper.
    It performs the check to see if, based on the
    constant provided
    it is okay to target this target with the
    spell effect.


    MODIFIED APRIL 2003
    - Other player's associates will now be harmed in
       Standard Hostile mode
    - Will ignore dead people in all target attempts

    MODIFIED AUG 2003 - GZ
    - Multiple henchmen support: made sure that
      AoE spells cast by one henchmen do not
      affect other henchmen in the party

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: March 6 2003
//:://////////////////////////////////////////////

int spellsIsTarget(object oTarget, int nTargetType, object oSource)
{
    int nReturnValue = FALSE;

    // * if dead, not a valid target
    if (GetIsDead(oTarget) == TRUE)
    {
        return FALSE;
    }

    switch (nTargetType)
    {
        // * this kind of spell will affect all friendlies and anyone in my
        // * party, even if we are upset with each other currently.
        case SPELL_TARGET_ALLALLIES:
        {
            if(GetIsReactionTypeFriendly(oTarget,oSource) || GetFactionEqual(oTarget,oSource))
            {
                nReturnValue = TRUE;
            }
            break;
        }
        case SPELL_TARGET_STANDARDHOSTILE:
        {
            //SpawnScriptDebugger();
            int bPC = GetIsPC(oTarget);
            int bNotAFriend = FALSE;
            int bReactionType = GetIsReactionTypeFriendly(oTarget, oSource);
            if (bReactionType == FALSE)
            {
                bNotAFriend = TRUE;
            }

            // * Local Override is just an out for end users who want
            // * the area effect spells to hurt 'neutrals'
            if (GetLocalInt(GetModule(), "X0_G_ALLOWSPELLSTOHURT") == 10)
            {
                bPC = TRUE;
            }

            int bSelfTarget = FALSE;
            object oMaster = GetMaster(oTarget);

            // March 25 2003. The player itself can be harmed
            // by their own area of effect spells if in Hardcore mode...
            if (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL)
            {
                // Have I hit myself with my spell?
                if (oTarget == oSource)
                {
                    bSelfTarget = TRUE;
                }
                else
                // * Is the target an associate of the spellcaster
                if (oMaster == oSource)
                {
                    bSelfTarget = TRUE;
                }
            }

            // April 9 2003
            // Hurt the associates of a hostile player
            if (bSelfTarget == FALSE && GetIsObjectValid(oMaster) == TRUE)
            {
                // * I am an associate
                // * of someone
                if ( (GetIsReactionTypeFriendly(oMaster,oSource) == FALSE && GetIsPC(oMaster) == TRUE)
                || GetIsReactionTypeHostile(oMaster,oSource) == TRUE)
                {
                    bSelfTarget = TRUE;
                }
            }


            // Assumption: In Full PvP players, even if in same party, are Neutral
            // * GZ: 2003-08-30: Patch to make creatures hurt each other in hardcore mode...

            if (GetIsReactionTypeHostile(oTarget,oSource))
            {
                nReturnValue = TRUE;         // Hostile creatures are always a target
            }
            else if (bSelfTarget == TRUE)
            {
                nReturnValue = TRUE;         // Targetting Self (set above)?
            }
            else if (bPC && bNotAFriend)
            {
                nReturnValue = TRUE;         // Enemy PC
            }
            else if (bNotAFriend && (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL))
            {
                if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES) == TRUE)
                {
                    nReturnValue = TRUE;        // Hostile Creature and Difficulty > Normal
                }                               // note that in hardcore mode any creature is hostile
            }
            break;
        }
        // * only harms enemies, ever
        // * current list:call lightning, isaac missiles, firebrand, chain lightning, dirge, Nature's balance,
        // * Word of Faith
        case SPELL_TARGET_SELECTIVEHOSTILE:
        {
            if(GetIsEnemy(oTarget,oSource))
            {
                nReturnValue = TRUE;
            }
            break;
        }
    }

    // GZ: Creatures with the same master will never damage each other
    if (GetMaster(oTarget) != OBJECT_INVALID && GetMaster(oSource) != OBJECT_INVALID )
    {
        if (GetMaster(oTarget) == GetMaster(oSource))
        {
            if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE) == 0 )
            {
                nReturnValue = FALSE;
            }
        }
    }

    return nReturnValue;
}



