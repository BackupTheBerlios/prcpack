#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"

//function prototypes
int MyPRCResistSpell(object oCaster, object oTarget, float fDelay = 0.0);
int ChangedElementalDamage(object oCaster, int nDamageType);
int GetChangesToCasterLevel(object oCaster);
int GetChangesToSaveDC(object oCaster);
int MyPRCGetRacialType(object oTarget);





int MyPRCResistSpell(object oCaster, object oTarget, float fDelay = 0.0){

    int nTargetSR = GetSpellResistance(oTarget);
    if(nTargetSR < 1)
        return 0;

    int nResist = 0;

    //preliminary checks that can avoid the heavy calculations
    if(!GetIsReactionTypeHostile(oTarget, oCaster)){
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
    return GetRacialType(oCreature);
}



