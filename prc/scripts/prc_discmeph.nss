//::///////////////////////////////////////////////
//:: [Disciple of Mephistopheles Feats]
//:: [prc_elemsavant.nss]
//:://////////////////////////////////////////////
//:: Check to see which Disciple of Mephistopheles feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Attilla.  Modified by Aaon Graywolf
//:: Created On: Jan 8, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

// * Applies the Disciple of Mephistopheles's resistances on the object's skin.
// * iLevel = IP_CONST_DAMAGERESIST_*
void ElemSavantResist(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "DiscMephResist") == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_RESISTANCE,IP_CONST_DAMAGETYPE_FIRE, iLevel, 1, "DiscMephResist");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, iLevel), oSkin);
    SetLocalInt(oSkin, "DiscMephResist", iLevel);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iResist = GetHasFeat(FEAT_FIRE_RESISTANCE_10, oPC) ? IP_CONST_DAMAGERESIST_10 : -1;
        iResist = GetHasFeat(FEAT_FIRE_RESISTANCE_10, oPC) ? IP_CONST_DAMAGERESIST_20 : iResist;

    //Apply bonuses accordingly
    if(iResist > -1) ElemSavantResist(oPC, oSkin, iResist);
}
