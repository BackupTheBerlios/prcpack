//::///////////////////////////////////////////////
//:: [Master Harper Feat]
//:: [prc_masterh.nss]
//:://////////////////////////////////////////////
//:: Check to see which Master Harper feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On: Feb 6, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "mh_constante"

void MasterHarperBonusFeat(object oPC, object oSkin, string sFlag, int iItemProp, int iSubProp, int iValue)
{
    //SpawnScriptDebugger();
    if(GetLocalInt(oSkin,sFlag) == TRUE) return;

    SetCompositeBonus(oSkin, sFlag, iValue,
                        iItemProp,iSubProp);
}


void main()
{
    //SpawnScriptDebugger();
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iLycanbane = GetHasFeat(FEAT_LYCANBANE,oPC);
    int iMililEar = GetHasFeat(FEAT_MILILS_EAR,oPC);
    int iDeneirsOrel = GetHasFeat(FEAT_DENEIRS_OREL,oPC);

    if (iLycanbane > 0) MasterHarperBonusFeat(oPC, oSkin, "MHLycanbane",
                                                ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP,
                                                IP_CONST_RACIALTYPE_SHAPECHANGER, 5);
    if (iMililEar > 0) MasterHarperBonusFeat(oPC, oSkin, "MHMililEar",
                                                ITEM_PROPERTY_SKILL_BONUS,
                                                SKILL_LISTEN, 4);
    if (iDeneirsOrel > 0) MasterHarperBonusFeat(oPC, oSkin, "MHDeneirsOrel",
                                                ITEM_PROPERTY_SKILL_BONUS,
                                                SKILL_SPELLCRAFT, 4);

}

