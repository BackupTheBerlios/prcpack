//::///////////////////////////////////////////////
//:: [Item Property Function]
//:: [inc_item_props.nss]
//:://////////////////////////////////////////////
//:: This file defines several functions used to
//:: simulate melee combat through scripting.
//:: This is useful for creating spells or feats
//:: which work in combat, such as the Smite Feats.
//:: The only problem at the moment is that the functions
//:: cannot determine bonuses derieved from Magical
//:: effects on creatures.  Other than that, these
//:: will behave exactly like normal combat.
//::
//:: Example: Creating a Smite Neutral feat
//:: In the spell script attached to the feat, check
//:: the alignment of the target, and run DoMeleeAttack
//:: entering the appropriate Smite bonus into iMod
//:: On a hit, call GetMeleeWeaponDamage and add the
//:: bonus damage from the feat.
//::
//:: Finally, simulate the rest of the combat round
//:: by calling DoMeleeAttack/GetMeleeWeaponDamage
//:: once for each remaining attack that the player
//:: should get.  Adding a -5 to iMod for each consecutive
//:: attack.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 19, 2003
//:://////////////////////////////////////////////
//:: Update: Jan 4 2002
//::    - Extended Composite bonus function to handle pretty much
//::      every property that can possibly be composited.

// * Returns an integer amount of damage from a constant
// * iDamageConst = DAMAGE_BONUS_* or IP_CONST_DAMAGEBONUS_*
int GetDamageByConstant(int iDamageConst, int iItemProp);

// * Returns the appropriate weapon feat given a weapon type
// * iType = BASE_ITEM_*
// * sFeat = "Focus", "Specialization", EpicFocus", "EpicSpecialization", "ImprovedCrit"
int GetFeatByWeaponType(int iType, string sFeat);

// * Returns the low end of oWeap's critical threat range
// * Accounts for Keen and Improved Critical bonuses
int GetMeleeWeaponCriticalRange(object oPC, object oWeap);

// * Performs a melee attack roll by oPC against oTarget.
// * Begins with BAB; to simulate multiple attacks in one round,
// * use iMod to add a -5 modifier for each consecutive attack.
// * If bShowFeedback is TRUE, display the attack roll in oPC's
// * message window after a delay of fDelay seconds.
// * Caveat: Cannot account for ATTACK_BONUS effects on oPC
int DoMeleeAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0);

// * Returns an integer amount of damage done by oPC with oWeap
// * Caveat: Cannot account for DAMAGE_BONUS effects on oPC
int GetMeleeWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0);

// * Returns the Enhancement Bonus of oWeap as DAMAGE_POWER_*
int GetWeaponEnhancement(object oWeap);

// * Oddly enough, Damage Types by weapon don't seem to appear in baseitems.2da
// * This funciton runs a switch that returns the appropriate damage type.
int GetWeaponDamageType(object oWeap);

int GetDamageByConstant(int iDamageConst, int iItemProp)
{
    if(iItemProp)
    {
        switch(iDamageConst)
        {
            case IP_CONST_DAMAGEBONUS_1:
                return 1;
            case IP_CONST_DAMAGEBONUS_2:
                return 2;
            case IP_CONST_DAMAGEBONUS_3:
                return 3;
            case IP_CONST_DAMAGEBONUS_4:
                return 4;
            case IP_CONST_DAMAGEBONUS_5:
                return 5;
            case IP_CONST_DAMAGEBONUS_6:
                return 6;
            case IP_CONST_DAMAGEBONUS_7:
                return 7;
            case IP_CONST_DAMAGEBONUS_8:
                return 8;
            case IP_CONST_DAMAGEBONUS_9:
                return 9;
            case IP_CONST_DAMAGEBONUS_10:
                return 10;
            case IP_CONST_DAMAGEBONUS_1d4:
                return d4(1);
            case IP_CONST_DAMAGEBONUS_1d6:
                return d6(1);
            case IP_CONST_DAMAGEBONUS_1d8:
                return d8(1);
            case IP_CONST_DAMAGEBONUS_1d10:
                return d10(1);
            case IP_CONST_DAMAGEBONUS_1d12:
                return d12(1);
            case IP_CONST_DAMAGEBONUS_2d4:
                return d4(2);
            case IP_CONST_DAMAGEBONUS_2d6:
                return d6(2);
            case IP_CONST_DAMAGEBONUS_2d8:
                return d8(2);
            case IP_CONST_DAMAGEBONUS_2d10:
                return d10(2);
            case IP_CONST_DAMAGEBONUS_2d12:
                return d12(2);
        }
    }
    else
    {
        switch(iDamageConst)
        {
            case DAMAGE_BONUS_1:
                return 1;
            case DAMAGE_BONUS_2:
                return 2;
            case DAMAGE_BONUS_3:
                return 3;
            case DAMAGE_BONUS_4:
                return 4;
            case DAMAGE_BONUS_5:
                return 5;
            case DAMAGE_BONUS_6:
                return 6;
            case DAMAGE_BONUS_7:
                return 7;
            case DAMAGE_BONUS_8:
                return 8;
            case DAMAGE_BONUS_9:
                return 9;
            case DAMAGE_BONUS_10:
                return 10;
            case DAMAGE_BONUS_11:
                return 10;
            case DAMAGE_BONUS_12:
                return 10;
            case DAMAGE_BONUS_13:
                return 10;
            case DAMAGE_BONUS_14:
                return 10;
            case DAMAGE_BONUS_15:
                return 10;
            case DAMAGE_BONUS_16:
                return 10;
            case DAMAGE_BONUS_17:
                return 10;
            case DAMAGE_BONUS_18:
                return 10;
            case DAMAGE_BONUS_19:
                return 10;
            case DAMAGE_BONUS_20:
                return 10;
            case DAMAGE_BONUS_1d4:
                return d4(1);
            case DAMAGE_BONUS_1d6:
                return d6(1);
            case DAMAGE_BONUS_1d8:
                return d8(1);
            case DAMAGE_BONUS_1d10:
                return d10(1);
            case DAMAGE_BONUS_1d12:
                return d12(1);
            case DAMAGE_BONUS_2d4:
                return d4(2);
            case DAMAGE_BONUS_2d6:
                return d6(2);
            case DAMAGE_BONUS_2d8:
                return d8(2);
            case DAMAGE_BONUS_2d10:
                return d10(2);
            case DAMAGE_BONUS_2d12:
                return d12(2);
        }
    }
    return 0;
}

int GetFeatByWeaponType(int iType, string sFeat)
{
        if(sFeat == "Focus")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_WEAPON_FOCUS_BASTARD_SWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_WEAPON_FOCUS_BATTLE_AXE;
                case BASE_ITEM_CLUB: return FEAT_WEAPON_FOCUS_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_WEAPON_FOCUS_DAGGER;
                case BASE_ITEM_DART: return FEAT_WEAPON_FOCUS_DART;
                case BASE_ITEM_DIREMACE: return FEAT_WEAPON_FOCUS_DIRE_MACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_WEAPON_FOCUS_DOUBLE_AXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_WEAPON_FOCUS_DWAXE;
                case BASE_ITEM_GREATAXE: return FEAT_WEAPON_FOCUS_GREAT_AXE;
                case BASE_ITEM_GREATSWORD: return FEAT_WEAPON_FOCUS_GREAT_SWORD;
                case BASE_ITEM_HALBERD: return FEAT_WEAPON_FOCUS_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_WEAPON_FOCUS_HAND_AXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_WEAPON_FOCUS_HEAVY_FLAIL;
                case BASE_ITEM_KAMA: return FEAT_WEAPON_FOCUS_KAMA;
                case BASE_ITEM_KATANA: return FEAT_WEAPON_FOCUS_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_WEAPON_FOCUS_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_WEAPON_FOCUS_LIGHT_FLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_WEAPON_FOCUS_LIGHT_HAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_WEAPON_FOCUS_LIGHT_MACE;
                case BASE_ITEM_LONGBOW: return FEAT_WEAPON_FOCUS_LONG_SWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_WEAPON_FOCUS_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_WEAPON_FOCUS_MORNING_STAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_WEAPON_FOCUS_STAFF;
                case BASE_ITEM_RAPIER: return FEAT_WEAPON_FOCUS_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_WEAPON_FOCUS_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_WEAPON_FOCUS_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_WEAPON_FOCUS_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_WEAPON_FOCUS_SPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_WEAPON_FOCUS_SHORT_SWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_WEAPON_FOCUS_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_WEAPON_FOCUS_SICKLE;
                case BASE_ITEM_SLING: return FEAT_WEAPON_FOCUS_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_WEAPON_FOCUS_THROWING_AXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_WEAPON_FOCUS_WAR_HAMMER;
                case BASE_ITEM_WHIP: return -1; //No constant (?)
            }

        else if(sFeat == "Specialization")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE;
                case BASE_ITEM_CLUB: return FEAT_WEAPON_SPECIALIZATION_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_WEAPON_SPECIALIZATION_DAGGER;
                case BASE_ITEM_DART: return FEAT_WEAPON_SPECIALIZATION_DART;
                case BASE_ITEM_DIREMACE: return FEAT_WEAPON_SPECIALIZATION_DIRE_MACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_WEAPON_SPECIALIZATION_DWAXE ;
                case BASE_ITEM_GREATAXE: return FEAT_WEAPON_SPECIALIZATION_GREAT_AXE;
                case BASE_ITEM_GREATSWORD: return FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD;
                case BASE_ITEM_HALBERD: return FEAT_WEAPON_SPECIALIZATION_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_WEAPON_SPECIALIZATION_HAND_AXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL;
                case BASE_ITEM_KAMA: return FEAT_WEAPON_SPECIALIZATION_KAMA;
                case BASE_ITEM_KATANA: return FEAT_WEAPON_SPECIALIZATION_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_WEAPON_SPECIALIZATION_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE;
                case BASE_ITEM_LONGBOW: return FEAT_WEAPON_SPECIALIZATION_LONG_SWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_WEAPON_SPECIALIZATION_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_WEAPON_SPECIALIZATION_MORNING_STAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_WEAPON_SPECIALIZATION_STAFF;
                case BASE_ITEM_RAPIER: return FEAT_WEAPON_SPECIALIZATION_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_WEAPON_SPECIALIZATION_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_WEAPON_SPECIALIZATION_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_WEAPON_SPECIALIZATION_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_WEAPON_SPECIALIZATION_SPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_WEAPON_SPECIALIZATION_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_WEAPON_SPECIALIZATION_SICKLE;
                case BASE_ITEM_SLING: return FEAT_WEAPON_SPECIALIZATION_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_WEAPON_SPECIALIZATION_THROWING_AXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER;
            }

        else if(sFeat == "EpicFocus")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE;
                case BASE_ITEM_CLUB: return FEAT_EPIC_WEAPON_FOCUS_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_EPIC_WEAPON_FOCUS_DAGGER;
                case BASE_ITEM_DART: return FEAT_EPIC_WEAPON_FOCUS_DART;
                case BASE_ITEM_DIREMACE: return FEAT_EPIC_WEAPON_FOCUS_DIREMACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_EPIC_WEAPON_FOCUS_DWAXE;
                case BASE_ITEM_GREATAXE: return FEAT_EPIC_WEAPON_FOCUS_GREATAXE;
                case BASE_ITEM_GREATSWORD: return FEAT_EPIC_WEAPON_FOCUS_GREATSWORD;
                case BASE_ITEM_HALBERD: return FEAT_EPIC_WEAPON_FOCUS_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_EPIC_WEAPON_FOCUS_HANDAXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL;
                case BASE_ITEM_KAMA: return FEAT_EPIC_WEAPON_FOCUS_KAMA;
                case BASE_ITEM_KATANA: return FEAT_EPIC_WEAPON_FOCUS_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_EPIC_WEAPON_FOCUS_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE;
                case BASE_ITEM_LONGBOW: return FEAT_EPIC_WEAPON_FOCUS_LONGSWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_EPIC_WEAPON_FOCUS_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF;
                case BASE_ITEM_RAPIER: return FEAT_EPIC_WEAPON_FOCUS_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_EPIC_WEAPON_FOCUS_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_EPIC_WEAPON_FOCUS_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_EPIC_WEAPON_FOCUS_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_EPIC_WEAPON_FOCUS_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_EPIC_WEAPON_FOCUS_SICKLE;
                case BASE_ITEM_SLING: return FEAT_EPIC_WEAPON_FOCUS_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_EPIC_WEAPON_FOCUS_WARHAMMER;
                case BASE_ITEM_WHIP: return -1; //No constant (?)
            }

        else if(sFeat == "EpicSpecialization")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE;
                case BASE_ITEM_CLUB: return FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
                case BASE_ITEM_DART: return FEAT_EPIC_WEAPON_SPECIALIZATION_DART;
                case BASE_ITEM_DIREMACE: return FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE;
                case BASE_ITEM_GREATAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE;
                case BASE_ITEM_GREATSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD;
                case BASE_ITEM_HALBERD: return FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL;
                case BASE_ITEM_KAMA: return FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
                case BASE_ITEM_KATANA: return FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE;
                case BASE_ITEM_LONGBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF;
                case BASE_ITEM_RAPIER: return FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE;
                case BASE_ITEM_SLING: return FEAT_EPIC_WEAPON_SPECIALIZATION_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER;
                case BASE_ITEM_WHIP: return -1; //No constant (?)
            }

        else if(sFeat == "ImprovedCrit")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_IMPROVED_CRITICAL_BASTARD_SWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_IMPROVED_CRITICAL_BATTLE_AXE;
                case BASE_ITEM_CLUB: return FEAT_IMPROVED_CRITICAL_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_IMPROVED_CRITICAL_DAGGER;
                case BASE_ITEM_DART: return FEAT_IMPROVED_CRITICAL_DART;
                case BASE_ITEM_DIREMACE: return FEAT_IMPROVED_CRITICAL_DIRE_MACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_IMPROVED_CRITICAL_DOUBLE_AXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_IMPROVED_CRITICAL_DWAXE ;
                case BASE_ITEM_GREATAXE: return FEAT_IMPROVED_CRITICAL_GREAT_AXE;
                case BASE_ITEM_GREATSWORD: return FEAT_IMPROVED_CRITICAL_GREAT_SWORD;
                case BASE_ITEM_HALBERD: return FEAT_IMPROVED_CRITICAL_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_IMPROVED_CRITICAL_HAND_AXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL;
                case BASE_ITEM_KAMA: return FEAT_IMPROVED_CRITICAL_KAMA;
                case BASE_ITEM_KATANA: return FEAT_IMPROVED_CRITICAL_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_IMPROVED_CRITICAL_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_IMPROVED_CRITICAL_LIGHT_MACE;
                case BASE_ITEM_LONGBOW: return FEAT_IMPROVED_CRITICAL_LONG_SWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_IMPROVED_CRITICAL_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_IMPROVED_CRITICAL_MORNING_STAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_IMPROVED_CRITICAL_STAFF;
                case BASE_ITEM_RAPIER: return FEAT_IMPROVED_CRITICAL_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_IMPROVED_CRITICAL_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_IMPROVED_CRITICAL_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_IMPROVED_CRITICAL_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_IMPROVED_CRITICAL_SPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_IMPROVED_CRITICAL_SHORT_SWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_IMPROVED_CRITICAL_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_IMPROVED_CRITICAL_SICKLE;
                case BASE_ITEM_SLING: return FEAT_IMPROVED_CRITICAL_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_IMPROVED_CRITICAL_THROWING_AXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_IMPROVED_CRITICAL_WAR_HAMMER;
            }

    return -1;
}

int GetMeleeWeaponCriticalRange(object oPC, object oWeap)
{
    int iType = GetBaseItemType(oWeap);
    int nThreat = StringToInt(Get2DAString("baseitems", "CritThreat", iType));
    int bKeen = GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN);
    int bImpCrit = GetHasFeat(GetFeatByWeaponType(iType, "ImprovedCrit"), oPC);

    nThreat *= bKeen ? 2 : 1;
    nThreat *= bImpCrit ? 2 : 1;

    return 21 - nThreat;
}

int DoMeleeAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0)
{
    //Declare in instantiate major variables
    int iDiceRoll = d20();
    int iBAB = GetBaseAttackBonus(oPC);
    int iAC = GetAC(oTarget);
    int iType = GetBaseItemType(oWeap);
    int iCritThreat = GetMeleeWeaponCriticalRange(oPC, oWeap);
    int bFinesse = GetHasFeat(FEAT_WEAPON_FINESSE, oPC);
    int bLight = StringToInt(Get2DAString("baseitems", "WeaponSize", iType)) <= 2 || iType == BASE_ITEM_RAPIER;
    int iEnhancement = GetWeaponEnhancement(oWeap);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;
    int bFocus = GetHasFeat(GetFeatByWeaponType(iType, "Focus"), oPC);
    int bEFocus = GetHasFeat(GetFeatByWeaponType(iType, "EpicFocus"), oPC);
    int bProwess = GetHasFeat(FEAT_EPIC_PROWESS, oPC);
    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iStr = iStr < 0 ? 0 : iStr;
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        iDex = iStr < 0 ? 0 : iDex;
    string sFeedback = GetName(oPC) + " attacks " + GetName(oTarget) + ": ";
    int iReturn = 0;

    //Add up total attack bonus
    int iAttackBonus = iBAB;
        iAttackBonus += bFinesse && bLight ? iDex : iStr;
        iAttackBonus += bFocus ? 1 : 0;
        iAttackBonus += bEFocus ? 2 : 0;
        iAttackBonus += bProwess ? 1 : 0;
        iAttackBonus += iEnhancement;
        iAttackBonus += iMod;

    //Include ATTACK_BONUS properties from the weapon
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS)
            iAttackBonus += GetItemPropertyCostTableValue(ip);
        ip = GetNextItemProperty(oWeap);
    }

    //Check for a critical threat
    if(iDiceRoll >= iCritThreat && iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*critical hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + "): ";
        //Roll again to see if we scored a critical hit
        iDiceRoll = d20();

        sFeedback += "*threat roll*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        if(iDiceRoll + iAttackBonus > iAC)
            iReturn = 2;
        else
            iReturn = 1;
    }

    //Just a regular hit
    else if(iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 1;
    }

    //Missed
    else
    {
        sFeedback += "*miss*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 0;
    }

    if(bShowFeedback) DelayCommand(fDelay, SendMessageToPC(oPC, sFeedback));
    return iReturn;
}

int GetMeleeWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0)
{
    //Declare in instantiate major variables
    int iType = GetBaseItemType(oWeap);
    int nSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iType));
    int nDice = StringToInt(Get2DAString("baseitems", "NumDice", iType));
    int nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", iType));
    int nMassiveCrit;
    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iStr = iStr < 0 ? 0 : iStr;
    int bSpec = GetHasFeat(GetFeatByWeaponType(iType, "Specialization"), oPC);
    int bESpec = GetHasFeat(GetFeatByWeaponType(iType, "EpicSpecialization"), oPC);
//    int iDamage = 0;
    int iBonus = 0;
    int iEnhancement = GetWeaponEnhancement(oWeap);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;

    //Get Damage Bonus and Massive Critical Properties from oWeap
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int tempConst = -1;
        int iCostVal = GetItemPropertyCostTableValue(ip);

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS){
            if(iCostVal > tempConst){
                nMassiveCrit = GetDamageByConstant(iCostVal, TRUE);
                tempConst = iCostVal;
             }
        }

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS){
            iBonus += GetDamageByConstant(iCostVal, TRUE);
        }
        ip = GetNextItemProperty(oWeap);
    }

    //Roll the base damage dice.
    if(nSides == 2) iDamage += d2(nDice);
    if(nSides == 4) iDamage += d4(nDice);
    if(nSides == 6) iDamage += d6(nDice);
    if(nSides == 8) iDamage += d8(nDice);
    if(nSides == 10) iDamage += d10(nDice);
    if(nSides == 12) iDamage += d12(nDice);

    //Add any applicable bonuses
    if(bSpec) iDamage += 2;
    if(bESpec) iDamage += 4;
    iDamage += iStr;
    iDamage += iEnhancement;
    iDamage += iBonus;

    //Add critical bonuses
    if(bCrit){
        iDamage *= nCritMult;
        iDamage += nMassiveCrit;
    }

    return iDamage;
}

int GetWeaponEnhancement(object oWeap)
{
    int iBonus = -1;
    int iTemp;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            iTemp += GetDamageByConstant(GetItemPropertyCostTableValue(ip), TRUE);
            iBonus = iTemp > iBonus ? iBonus : iTemp;
        ip = GetNextItemProperty(oWeap);
    }
    return iBonus;
}

int GetWeaponDamageType(object oWeap)
{
    int iType = GetBaseItemType(oWeap);

    switch(iType)
    {
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WHIP:
            return DAMAGE_TYPE_SLASHING;

        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DART:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
            return DAMAGE_TYPE_PIERCING;

        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_DIREMACE:
            return DAMAGE_TYPE_BLUDGEONING;
    }

    return -1;
}
