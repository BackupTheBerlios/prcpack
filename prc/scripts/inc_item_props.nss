//::///////////////////////////////////////////////
//:: [Item Property Function]
//:: [inc_item_props.nss]
//:://////////////////////////////////////////////
//:: This file defines several functions used to
//:: manipulate item properties.  In particular,
//:: It defines functions used in the prc_* files
//:: to apply passive feat bonuses.
//::
//:: Take special note of SetCompositeBonus.  This
//:: function is crucial for allowing bonuses of the
//:: same type from different PRCs to stack.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 19, 2003
//:://////////////////////////////////////////////
//:: Update: Jan 4 2002
//::    - Extended Composite bonus function to handle pretty much
//::      every property that can possibly be composited.

// * Checks to see if oPC has an item created by sRes in his/her inventory
int GetHasItem(object oPC, string sRes);

// * Sets up the pcskin object on oPC
// * If it already exists, simply return it
// * Otherwise, create and equip it
object GetPCSkin(object oPC);

// * Checks oItem for all properties matching iType and iSubType
// * Removes all these properties and returns their total CostTableVal.
// * This function should only be used for Item Properties that have
// * simple integer CostTableVals, such as AC, Save/Skill Bonuses, etc.
// * iType = ITEM_PROPERTY_* of bonus
// * iSubType = IP_CONST_* of bonus SubType if applicable
int TotalAndRemoveProperty(object oItem, int iType, int iSubType = -1);

// * Used to roll bonuses from multiple sources into a single property
// * Only supports properties which have simple integer CostTableVals.
// * See the switch for a list of supported types.  Some important properties
// * that CANNOT be composited are SpellResistance, DamageBonus, DamageReduction
// * DamageResistance and MassiveCritical, as these use constants instead of
// * integers for CostTableVals.
// *
// * oPC = Object wearing / using the item
// * oItem = Object to apply bonus to
// * sBonus = String name of the source for this bonus
// * iVal = Integer value to set this bonus to
// * iType: ITEM_PROPERTY_* of bonus
// * iSubType: IP_CONST_* of bonus SubType if applicable
void SetCompositeBonus(object oItem, string sBonus, int iVal, int iType, int iSubType = -1);

// * Returns the total Bonus AC of oItem
int GetACBonus(object oItem);

// * Returns the Base AC (i.e. AC without bonuses) of oItem
int GetBaseAC(object oItem);

// * Removes a Presice Strike bonus from oWeap.
// * Existing bonuses are determined by reading LocalInt "PStrkBonus" on oWeap
void DuelistRemovePreciseStrike(object oWeap);

// * Returns the opposite element from iElem or -1 if iElem is not valid
// * Can be useful for determining elemental strengths and weaknesses
// * iElem = IP_CONST_DAMAGETYPE_*
int GetOppositeElement(int iElem);

int GetHasItem(object oPC, string sRes)
{
    object oItem = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oItem) && GetResRef(oItem) != sRes)
        oItem = GetNextItemInInventory(oPC);

    return GetResRef(oItem) == sRes;
}

object GetPCSkin(object oPC)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    //Added GetHasItem check to prevent creation of extra skins on module entry
    if(!GetIsObjectValid(oSkin) && !GetHasItem(oPC, "base_prc_skin")){
        oSkin = CreateItemOnObject("base_prc_skin", oPC);
        AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
    }
    return oSkin;
}

int TotalAndRemoveProperty(object oItem, int iType, int iSubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int total = 0;

    while(GetIsItemPropertyValid(ip)){
        if(GetItemPropertyType(ip) == iType && (GetItemPropertySubType(ip) == iSubType || iSubType == -1)){
            total += GetItemPropertyCostTableValue(ip);
            RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
    return total;
}

void RemoveSpecificProperty(object oItem, int iType, int iSubType = -1, int iCostVal = -1, int iNum = 1, string sFlag = "", int iParam1 = -1)
{
    int iRemoved = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip) && iRemoved < iNum){
        int bMatch = GetItemPropertyType(ip) == iType;
            bMatch = GetItemPropertySubType(ip) == iSubType || iSubType == -1 ? bMatch : FALSE;
            bMatch = GetItemPropertyCostTableValue(ip) == iCostVal || iCostVal == -1 ? bMatch : FALSE;
            bMatch = GetItemPropertyParam1Value(ip) == iParam1 || iParam1 == -1 ? bMatch : FALSE;

        if(bMatch){
            RemoveItemProperty(oItem, ip);
            iRemoved++;
        }
        ip = GetNextItemProperty(oItem);
    }
    SetLocalInt(oItem, sFlag, 0);
}

void SetCompositeBonus(object oItem, string sBonus, int iVal, int iType, int iSubType = -1)
{
    int iOldVal = GetLocalInt(oItem, sBonus);
    int iChange = iVal - iOldVal;
    int iCurVal = 0;

    if(iChange == 0) return;

    //Moved TotalAndRemoveProperty into switch to prevent
    //accidental deletion of unsupported property types
    switch(iType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 12)
            {
                iCurVal = 12;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsDmgType(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsRace(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsSAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonusVsAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonusVsRace(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonusVsSAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAbility(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_AC:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 5)
            {
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAC(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 5)
            {
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackPenalty(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 5)
            {
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementPenalty(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyReducedSavingThrowVsX(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyReducedSavingThrow(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 10)
            {
                iCurVal = 10;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseSkill(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsRace(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsSAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_MIGHTY:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMaxRangeStrengthMod(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_REGENERATION:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyRegeneration(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_SKILL_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 50)
            {
                iCurVal = 50;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(iSubType, iCurVal + iChange), oItem);
            break;
    }
    SetLocalInt(oItem, sBonus, iVal);
}

int GetACBonus(object oItem)
{
    if(!GetIsObjectValid(oItem)) return 0;

    itemproperty ip = GetFirstItemProperty(oItem);
    int iTotal = 0;

    while(GetIsItemPropertyValid(ip)){
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS)
            iTotal += GetItemPropertyCostTableValue(ip);
        ip = GetNextItemProperty(oItem);
    }
    return iTotal;
}

int GetBaseAC(object oItem){ return GetItemACValue(oItem) - GetACBonus(oItem); }

//Added a flag to make sure bonus is only removed once
void DuelistRemovePreciseStrike(object oWeap)
{
    int iPStrkBonus = GetLocalInt(oWeap, "PStrkBonus");
    if(iPStrkBonus != 0)
        RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_SLASHING, iPStrkBonus, 1, "PStrkBonus");
}

void KnightRemoveDaemonslaying(object oWeap)
{
    int iDivineBonus = GetLocalInt(oWeap, "DSlayBonusDiv");
    int iPositiveBonus = GetLocalInt(oWeap, "DSlayBonusPos");
    if(iDivineBonus != 0)
        RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_OUTSIDER, iDivineBonus, 1, "DSlayBonusDiv", IP_CONST_DAMAGETYPE_DIVINE);
    if(iPositiveBonus != 0)
        RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_OUTSIDER, iPositiveBonus, 1, "DSlayBonusPos", IP_CONST_DAMAGETYPE_POSITIVE);
    SetCompositeBonus(oWeap, "DSlayingAttackBonus", 0, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_OUTSIDER);
}

int GetOppositeElement(int iElem)
{
    switch(iElem){
        case IP_CONST_DAMAGETYPE_ACID:
            return DAMAGE_TYPE_ELECTRICAL;
        case IP_CONST_DAMAGETYPE_COLD:
            return IP_CONST_DAMAGETYPE_FIRE;
        case IP_CONST_DAMAGETYPE_DIVINE:
            return IP_CONST_DAMAGETYPE_NEGATIVE;
        case IP_CONST_DAMAGETYPE_ELECTRICAL:
            return IP_CONST_DAMAGETYPE_ACID;
        case IP_CONST_DAMAGETYPE_FIRE:
            return IP_CONST_DAMAGETYPE_COLD;
        case IP_CONST_DAMAGETYPE_NEGATIVE:
            return IP_CONST_DAMAGETYPE_POSITIVE;
     }
     return -1;
}


