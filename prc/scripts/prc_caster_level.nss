/*
New function
Split in different logical places. All scripts should be in their logical spot
for optimum performance.

Usually, you only need to add things in 1 of 2 places. These are marked
by a lot of green stuff around them

Heavily modified by Kaltor, mar 30 2004
*/


#include "prc_feat_const"
#include "prc_class_const"
#include "lookup_2da_spell"


int IsArcaneClass(int nClass);
int IsDivineClass(int nClass);


void main()
{
    if(GetSpellCastItem() != OBJECT_INVALID)
        return;

    int nPrevious = GetLocalInt(OBJECT_SELF, "LastCalcuAddonCL");
    if(nPrevious>0){
        SetLocalInt(OBJECT_SELF,"X2_L_LAST_RETVAR", nPrevious);
        return;
        }



    //------------------------------------------------------------------
    //FEW VARIABLES WELL NEED
    object oCaster = OBJECT_SELF;
    int nCastingClass = GetLastSpellCastClass();
    int nFirstClass = GetClassByPosition(1, oCaster);
    int nArcaneAddon = 0;
    int nDivineAddon = 0;





    //------------------------------------------------------------------
    //IF ARCANE SPELL HAS BEEN CAST
    if( IsArcaneClass(nCastingClass)){

        if( nFirstClass != nCastingClass && IsArcaneClass(nFirstClass))
            return;

        nArcaneAddon+=
            GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster)/2+
            GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCaster)+
            GetLevelByClass(CLASS_TYPE_MAGEKILLER, oCaster)+
            GetLevelByClass(CLASS_TYPE_HARPERMAGE, oCaster)+
            GetLevelByClass(CLASS_TYPE_SPELLSWORD, oCaster) / 2+
            GetLevelByClass(CLASS_TYPE_ACOLYTE, oCaster) / 2+
            GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster)+
            GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster)+
            GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oCaster)+
            GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster)/2+
            GetHasFeat(FEAT_FIRE_ADEPT, oCaster);


            /*///////////////////////////////////////////////
            /////////////////////////////////////////////////
            /////////////////////////////////////////////////
            THIS IS WHERE YOU ADD ARCANE CLASSES

            simply modify the above with something looking like this:

            from:

            GetHasFeat(FEAT_FIRE_ADEPT, oCaster);

            to:

            GetHasFeat(FEAT_FIRE_ADEPT, oCaster)+
            GetLevelByClass(MY_NEW_CLASS_TYPE, oCaster);

            /////////////////////////////////////////////////
            /////////////////////////////////////////////////
            ///////////////////////////////////////////////*/






        // area for CLASS-specific code. Avoid if possible

        if(GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster)){
            if(IsArcaneClass(nFirstClass) ||
               (!IsDivineClass(nFirstClass) && IsArcaneClass(GetClassByPosition(2, oCaster))))
                nArcaneAddon+=GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) / 2;
        }
        if (GetHasFeat(FEAT_SPELL_POWER_I)){
            nArcaneAddon+=1;
            if (GetHasFeat(FEAT_SPELL_POWER_II)){
                nArcaneAddon+=1;
                if (GetHasFeat(FEAT_SPELL_POWER_III)){
                    nArcaneAddon+=1;
                    if (GetHasFeat(FEAT_SPELL_POWER_IV)){
                        nArcaneAddon+=1;
                        if (GetHasFeat(FEAT_SPELL_POWER_V)){
                            nArcaneAddon+=1;
                        }}}}
        }
        if(GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster)){
            nArcaneAddon+=GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);
            if(lookup_spell_school(GetSpellId()) == "N")
                nArcaneAddon+=GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
        }
    }//end of arcane spell part



    //------------------------------------------------------------------
    //IF DIVINE SPELL HAS BEEN CAST
    else if( IsDivineClass(nCastingClass)){

        if( nFirstClass != nCastingClass && IsDivineClass(nFirstClass))
            return;

        nDivineAddon+=
            GetLevelByClass(CLASS_TYPE_HEARTWARDER, oCaster)+
            GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster)+
            GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)+
            GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster)+
            GetLevelByClass(CLASS_TYPE_HOSPITALER, oCaster)+
            GetLevelByClass(CLASS_TYPE_TEMPUS, oCaster)/2+
            GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);

            /*///////////////////////////////////////////////
            /////////////////////////////////////////////////
            /////////////////////////////////////////////////
            THIS IS WHERE YOU ADD DIVINE CLASSES

            simply modify the above with something looking like this:

            from:

            GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster);

            to:

            GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oCaster)+
            GetLevelByClass(MY_NEW_CLASS_TYPE, oCaster);

            /////////////////////////////////////////////////
            /////////////////////////////////////////////////
            ///////////////////////////////////////////////*/

        //class-specific code. Avoid if at all possible

        if(GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster)){
            if(IsDivineClass(nFirstClass) ||
               (!IsArcaneClass(nFirstClass) && IsDivineClass(GetClassByPosition(2, oCaster))))
                nArcaneAddon+=GetLevelByClass(CLASS_TYPE_OOZEMASTER, oCaster) / 2;
        }
        if(GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster)){
            if(lookup_spell_school(GetSpellId()) == "N")
                nDivineAddon+=GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
                nDivineAddon+=GetLevelByClass(CLASS_TYPE_TRUENECRO, oCaster);
        }

    }//end of divine spell part
    else{
        //to fix a weird hierophant bug
        if(GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster) > 0)
            nDivineAddon+= GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
    }



    //------------------------------------------------------------------
    //FINISH THE JOB

    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", nArcaneAddon+nDivineAddon);
    SetLocalInt(oCaster, "LastCalcuAddonCL", nArcaneAddon+nDivineAddon);
    DelayCommand(6.0, DeleteLocalInt(oCaster, "LastCalcuAddonCL"));
    return;
}



int IsArcaneClass(int nClass){
    return (    nClass==CLASS_TYPE_WIZARD ||
                nClass==CLASS_TYPE_SORCERER ||
                nClass==CLASS_TYPE_BARD);
}

int IsDivineClass(int nClass){
    return (    nClass==CLASS_TYPE_CLERIC ||
                nClass==CLASS_TYPE_DRUID);
}
