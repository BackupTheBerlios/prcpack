//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_level
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Makes a phylactery, or upgrades it and allows the user
// to select the lich template class

#include "inc_item_props"
#include "pnp_shifter"
#include "strat_prc_inc"

void LichSkills(object oHide, int iLevel)
{
    SetCompositeBonus(oHide, "LichSkillHide", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    SetCompositeBonus(oHide, "LichSkillListen", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oHide, "LichSkillPersuade", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    SetCompositeBonus(oHide, "LichSkillSilent", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    SetCompositeBonus(oHide, "LichSkillSearch", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oHide, "LichSkillSpot", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
}

int GetAmuletLevel(object oAmulet)
{
    //object oPC = GetFirstPC();
    //SendMessageToPC(oPC,"Amulet level func");
    itemproperty iProp = GetFirstItemProperty(oAmulet);
    while (GetIsItemPropertyValid(iProp))
    {
        if (GetItemPropertyType(iProp) == ITEM_PROPERTY_AC_BONUS)
        {
            //SendMessageToPC(oPC," AC bonus found");
            int nAC = GetItemPropertyCostTableValue(iProp);
            //SendMessageToPC(oPC, "AC = " + IntToString(nAC));
            switch (nAC)
            {
            case 2:
                return 1;
            case 3:
                return 2;
            case 4:
                return 3;
            case 5:
                return 4;
            default:
                return 0;
            }
        }
        iProp = GetNextItemProperty(oAmulet);
    }
    return 0;
}

int GetHideLevel(object oHide)
{
    itemproperty iProp = GetFirstItemProperty(oHide);
    while (GetIsItemPropertyValid(iProp))
    {
        if (GetItemPropertyType(iProp) == ITEM_PROPERTY_SKILL_BONUS)
        {
            int nSkill = GetItemPropertySubType(iProp);
            int nSkillAdd = GetItemPropertyCostTableValue(iProp);
            if (nSkill == SKILL_HIDE)
            {
                if (nSkillAdd == 2)
                    return 1;
            }

        }
        if (GetItemPropertyType(iProp) == ITEM_PROPERTY_DAMAGE_REDUCTION)
        {
            int nEncht = GetItemPropertySubType(iProp);
            int nDR = GetItemPropertyCostTableValue(iProp);
            // lich hide is always +1
            if (nEncht == IP_CONST_DAMAGEREDUCTION_1)
            {
                switch (nDR)
                {
                case IP_CONST_DAMAGESOAK_5_HP:
                    return 2;
                case IP_CONST_DAMAGESOAK_10_HP:
                    return 3;
                case IP_CONST_DAMAGESOAK_15_HP:
                    return 4;
                }
            }
            else
            {
                switch (nDR)
                {
                case IP_CONST_DAMAGESOAK_10_HP:
                    return 5;
                case IP_CONST_DAMAGESOAK_15_HP:
                    return 6;
                case IP_CONST_DAMAGESOAK_20_HP:
                    return 7;
                case IP_CONST_DAMAGESOAK_30_HP:
                    return 8;
                }
            }
        }
        iProp = GetNextItemProperty(oHide);
    }
    // A level 0 hide wont have any lich powers
    if (GetIsObjectValid(oHide))
    {
        return 0;
    }

    return -1;
}

void LevelUpHide(object oPC, object oHide, int nLevel)
{
    //Remove All Props doesn't play nicely with other classes
    //Use composites and RemoveSpecificProperty Instead
    //RemoveAllItemProperties(oHide);
    itemproperty iprop;

    // Level 1 hide
    if (nLevel == 1)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichInt", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);

        //Lich skills +2
        LichSkills(oHide, 2);

        //Damage reduction 5/- cold
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_5);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 5/- electric
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGERESIST_5);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
    // Level 2
    if (nLevel == 2)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichInt", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);

        //Lich skills +4
        LichSkills(oHide, 4);

        //Clear out non-composite properties from last level
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5, 1, "");

        //Damage reduction 5/+1
        iprop = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,IP_CONST_DAMAGESOAK_5_HP);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 10/- cold
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_10);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 10/- electric
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGERESIST_10);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
    if (nLevel == 3)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichWis", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
        //Lich skills +6
        LichSkills(oHide, 6);

        //Clear out non-composite properties from last level
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10, 1, "");

        //Damage reduction 10/1
        iprop = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,IP_CONST_DAMAGESOAK_10_HP);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 20/- cold
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_20);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 20/- electric
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGERESIST_20);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
    // Common things for being undead and a lich
    if (nLevel >= 4)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichCon", 12, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
        //Lich skills +8
        LichSkills(oHide, 8);

        // Remove all immunities
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS,IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_BACKSTAB);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_DEATH_MAGIC);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_DISEASE);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_MINDSPELLS);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_PARALYSIS);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_POISON);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
        RemoveSpecificProperty(oHide,ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);


        // Undead abilities
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        iprop = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        // 100 % immune to cold
        iprop = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        // 100 % immune to electric
        iprop = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);

    }
    if (nLevel == 4)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichCha", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

        //Clear out non-composite properties from last level
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_20, 1, "");

        //Damage reduction 15/1
        iprop = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,IP_CONST_DAMAGESOAK_15_HP);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
    if (nLevel == 5)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichInt", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        SetCompositeBonus(oHide, "LichWis", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
        SetCompositeBonus(oHide, "LichCha", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

        //Clear out non-composite properties from last level
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP, 1, "");

        //Damage reduction 10/+5
        iprop = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_10_HP);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 5/- ACID
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_5);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 5/- fire
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_5);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 5/- sonic
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGERESIST_5);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        // Spell level immune to 2 and lower
        iprop = ItemPropertyImmunityToSpellLevel(3);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
    if (nLevel == 6)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichInt", 6, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        SetCompositeBonus(oHide, "LichWis", 6, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
        SetCompositeBonus(oHide, "LichCha", 6, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

        //Clear out non-composite properties from last level
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_10_HP, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_5, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_5, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 3, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 2, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 1, 1, "");

        //Damage reduction 15/+10
        iprop = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_10,IP_CONST_DAMAGESOAK_15_HP);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 10/- ACID
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_10);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 10/- fire
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_10);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 10/- sonic
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGERESIST_10);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        // Spell level immune to 4 and lower
        iprop = ItemPropertyImmunityToSpellLevel(5);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
    if (nLevel == 7)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichInt", 8, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        SetCompositeBonus(oHide, "LichWis", 8, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
        SetCompositeBonus(oHide, "LichCha", 8, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

        //Clear out non-composite properties from last level
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGEREDUCTION_10, IP_CONST_DAMAGESOAK_15_HP, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_10, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_10, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 5, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 4, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 3, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 2, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 1, 1, "");

        //Damage reduction 20/+15
        iprop = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_15,IP_CONST_DAMAGESOAK_20_HP);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 15/- ACID
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_15);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 15/- fire
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_15);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 15/- sonic
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGERESIST_15);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        // Spell level immune to 6 and lower
        iprop = ItemPropertyImmunityToSpellLevel(7);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
    if (nLevel == 8)
    {
        // Ability bonus
        SetCompositeBonus(oHide, "LichInt", 10, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        SetCompositeBonus(oHide, "LichWis", 10, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
        SetCompositeBonus(oHide, "LichCha", 10, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

        //Clear out non-composite properties from last level
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGEREDUCTION_15, IP_CONST_DAMAGESOAK_20_HP, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_15, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_15, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_15, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 7, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 6, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 5, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 4, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 3, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 2, 1, "");
        RemoveSpecificProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL, -1, 1, 1, "");

        //Damage reduction 30/+20
        iprop = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_30_HP);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 20/- ACID
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_20);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 20/- fire
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_20);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        //Damage reduction 20/- sonic
        iprop = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC,IP_CONST_DAMAGERESIST_20);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
        // Spell level immune to 9 and lower
        iprop = ItemPropertyImmunityToSpellLevel(10);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oHide);
    }
}

void LevelUpAmulet(object oAmulet,int nLevel)
{
    RemoveAllItemProperties(oAmulet);
    itemproperty iprop;

    // Level 2
    if (nLevel == 2)
    {
        // Ac bonus
        iprop = ItemPropertyACBonus(3);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oAmulet);
    }
    if (nLevel == 3)
    {
        // Ac bonus
        iprop = ItemPropertyACBonus(4);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oAmulet);
    }
    if (nLevel == 4)
    {
        // Ac bonus
        iprop = ItemPropertyACBonus(5);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oAmulet);
        // Extra so the amulet is useful til 20th level
        iprop = ItemPropertyRegeneration(1);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oAmulet);
        iprop = ItemPropertyCastSpell(IP_CONST_CASTSPELL_ANIMATE_DEAD_15,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oAmulet);
        iprop = ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSNEC);
        AddItemProperty(DURATION_TYPE_PERMANENT,iprop,oAmulet);
    }
}

void RemoveAllGold(object oObject)
{
    //Destroy everthing
    object oItem = GetFirstItemInInventory();
    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory();
    }
}

void main()
{
    int nGold = GetGold();
    object oPC = GetLastUsedBy();
    int nLichLevel = GetLevelByClass(CLASS_TYPE_LICH,oPC);

    // Lich items
    object oAmulet = GetItemPossessedBy(oPC,"lichamulet");
    //SendMessageToPC(oPC,"Amulet " + GetName(oAmulet));
    int nPaidAmount = 0;
    object oHide = GetPCSkin(oPC);
    //CopyItem(oHide,oPC,TRUE);
    //SendMessageToPC(oPC,"Hide " + GetName(oHide));

    if (nGold >= 40000)
    {
        // increase the paidamount
        nPaidAmount = 40000;
    }

    int nHideLevel = GetHideLevel(oHide);
    //SendMessageToPC(oPC,"hide = " + IntToString(nHideLevel));

    // if they have an amulet and the hide is level 0
    // this can happen if they (in the future) created the phylactery before
    // they gain any lich levels.
    if ((nLichLevel >= 1) && GetIsObjectValid(oAmulet) && (nHideLevel == 0))
    {
        //Apply a vfx to the PC
        effect eFx = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
        eFx = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
        LevelUpHide(oPC, oHide,1);
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nHD = GetHitDice(oPC);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = GetXP(oPC) - 1600;
    // -------------------------------------------------------------------------
    // check for sufficient XP to create phylactery
    // -------------------------------------------------------------------------
    if (nMinXPForLevel > nNewXP || nNewXP == 0 )
    {
        FloatingTextStrRefOnCreature(3785, oPC); // Item Creation Failed - Not enough XP
        DestroyObject(OBJECT_SELF);
        return;
    }

    // If they dont have the amulet create it
    if (!GetIsObjectValid(oAmulet) && (nPaidAmount >= 40000))
    {
        // Give them the level 1 phylactery
        oAmulet = CreateItemOnObject("lichamulet",oPC);
        SetIdentified(oAmulet,TRUE);
        // Allow them to become a lich
        SetLocalInt(oPC,"PNP_AllowLich", 0);
        // pay for it
        int xp = GetXP(oPC);
        xp -= 1600;
        SetXP(oPC,xp);
        RemoveAllGold(OBJECT_SELF);
        // If they are already a lich level up the hide to one.
        if (nLichLevel == 1)
        {
            // Apply a vfx to the PC
            effect eFx = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
            eFx = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
            eFx = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);

            LevelUpHide(oPC, oHide,1);
        }
        else
        {
            FloatingTextStringOnCreature("After you level up in the lich class, use this object again",oPC);
        }
        DestroyObject(OBJECT_SELF);
        return;
    }


    int nAmuletLevel = GetAmuletLevel(oAmulet);
    //SendMessageToPC(oPC,"amulet = " + IntToString(nAmuletLevel));


    // Need to be caster level 21 before you can become a demilich
    if (nLichLevel > 4)
    {
        int iWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
        int iSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
        int iClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
        int iCasterLevel = iWizardLevel > iSorcererLevel ? iWizardLevel : iSorcererLevel;
            iCasterLevel = iClericLevel > iCasterLevel ? iClericLevel : iCasterLevel;

        if (iCasterLevel < 21)
        {
            FloatingTextStringOnCreature("You must have 21 levels as a caster before you can proceed in your research as a Demilich",oPC);
            DestroyObject(OBJECT_SELF);
            return;
        }
    }

    if (nPaidAmount >= 40000)
    {
        // Level up the hide by 1
        if (nHideLevel < nLichLevel)
        {
            int xp = GetXP(oPC);
            xp -= 1600;
            SetXP(oPC,xp);
            FloatingTextStringOnCreature("Your soul has been accepted",oPC);
            RemoveAllGold(OBJECT_SELF);

            // Apply a vfx to the PC
            effect eFx = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
            eFx = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
            eFx = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);

            LevelUpHide(oPC, oHide,nHideLevel+1);
            // Modify the look at level 4 and 8
            if (nLichLevel == 4)
            {
                eFx = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
                SetCreatureAppearanceType(oPC,APPEARANCE_TYPE_LICH);
            }
            if (nLichLevel == 8)
            {
                eFx = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
                SetCreatureAppearanceType(oPC,430);
            }
        }
        else
        {
            if (nLichLevel < 8)
                FloatingTextStringOnCreature("You need to gain another Lich level before you can increase your Powers",oPC);
            else
                FloatingTextStringOnCreature("You have advanced as far as possible",oPC);
        }
        // Level up the amulet, but it stops improving at level 4
        if ((nAmuletLevel < nLichLevel) && (nAmuletLevel < 4))
        {
            LevelUpAmulet(oAmulet,nAmuletLevel+1);
        }
        DestroyObject(OBJECT_SELF);
    }
    // tell the PC they need to pay in order to advance
    else if (nHideLevel < nLichLevel)
    {
        FloatingTextStringOnCreature("You must upgrade your phylactery before you can attain more power.  The cost to upgrade is 40000 gp, and 1600 exp",oPC);
    }
}
