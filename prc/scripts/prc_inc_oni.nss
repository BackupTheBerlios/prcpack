///////////////////////////////////////////////////////////////
// Oni's PrC's
// Created: Feb 26, 2004
// Updated: Mar 05, 2004
// Frenzied Berserker, Tempest, Foe Hunter
///////////////////////////////////////////////////////////////

#include "x2_inc_itemprop"

///////////////////////////////////////////////////////////////
//New Prestige Classes
///////////////////////////////////////////////////////////////
const int CLASS_TYPE_FRE_BERSERKER = 177; //CONSTANT
const int CLASS_TYPE_TEMPEST = 178;       //CONSTANT
const int CLASS_TYPE_FOE_HUNTER = 179;    //CONSTANT

///////////////////////////////////////////////////////////////
// Frenzied Berserker Feats
///////////////////////////////////////////////////////////////
const int FEAT_FRENZY = 4300;         //CONSTANT
const int FEAT_REMOVE_FRENZY = 4309;  //CONSTANT
const int FEAT_GREATER_FRENZY = 4305; //CONSTANT
const int FEAT_INSPIRE_FRENZY = 4306; //CONSTANT

const int FEAT_REMAIN_CONSCIOUS = 4313; //CONSTANT
const int FEAT_DEATHLESS_FRENZY = 4314; //CONSTANT

const int FEAT_REMOVE_S_POWER_ATTACK = 4310;//CONSTANT
const int FEAT_SUPREME_POWER_ATTACK = 4311; //CONSTANT
const int FEAT_INTIMIDATING_RAGE = 4312;    //CONSTANT

///////////////////////////////////////////////////////////////
// Frenzied Berserker Spells
///////////////////////////////////////////////////////////////
const int SPELL_FRENZY = 2700;               //CONSTANT
const int SPELL_INSPIRE_FRENZY = 2701;       //CONSTANT
const int SPELL_SUPREME_POWER_ATTACK = 2702; //CONSTANT
const int SPELL_REMOVE_FRENZY = 2703;        //CONSTANT
// const int SPELL_REMOVE_S_POWER_ATTACK = 2704;//CONSTANT

///////////////////////////////////////////////////////////////
// Tempest Feats
///////////////////////////////////////////////////////////////
const int FEAT_GREATER_TWO_WEAPON_FIGHTING = 4315;   //CONSTANT
const int FEAT_SUPREME_TWO_WEAPON_FIGHTING = 4316;   //CONSTANT

const int FEAT_TWO_WEAPON_DEFENSE = 4317;         //CONSTANT
const int FEAT_ABSOLUTE_AMBIDEX = 4321;          //CONSTANT
// const int FEAT_REMOVE_OFF_HAND_PARRY = 4320;  //CONSTANT 

///////////////////////////////////////////////////////////////
// Tempest Spells
///////////////////////////////////////////////////////////////
const int SPELL_T_TWO_WEAPON_FIGHTING = 2705;      //CONSTANT
// const int SPELL_REMOVE_OFF_HAND_PARRY = 2706;   //CONSTANT

///////////////////////////////////////////////////////////////
// Foe Hunter Feats
///////////////////////////////////////////////////////////////
const int FEAT_RANCOR = 0000;
const int FEAT_HATED_ENEMY_DR = 0000;
const int FEAT_HATED_ENEMY_SR = 0000;
const int FEAT_DEATH_ATTACK = 0000;

const int FEAT_HATED_ENEMY_DWARF = 0000;
const int FEAT_HATED_ENEMY_ELF = 0000;
const int FEAT_HATED_ENEMY_GNOME = 0000;
const int FEAT_HATED_ENEMY_HALFLING = 0000;
const int FEAT_HATED_ENEMY_HALFELF = 0000;
const int FEAT_HATED_ENEMY_HALFORC = 0000;
const int FEAT_HATED_ENEMY_HUMAN = 0000;
const int FEAT_HATED_ENEMY_ABERRATION = 0000;
const int FEAT_HATED_ENEMY_ANIMAL = 0000;
const int FEAT_HATED_ENEMY_BEAST = 0000;
const int FEAT_HATED_ENEMY_CONSTRUCT = 0000;
const int FEAT_HATED_ENEMY_DRAGON = 0000;
const int FEAT_HATED_ENEMY_GOBLINOID = 0000;
const int FEAT_HATED_ENEMY_MONSTROUS = 0000;
const int FEAT_HATED_ENEMY_ORC = 0000;
const int FEAT_HATED_ENEMY_REPTILIAN = 0000;
const int FEAT_HATED_ENEMY_ELEMENTAL = 0000;
const int FEAT_HATED_ENEMY_FEY = 0000;
const int FEAT_HATED_ENEMY_GIANT = 0000;
const int FEAT_HATED_ENEMY_MAGICAL_BEAST = 0000;
const int FEAT_HATED_ENEMY_OUTSIDER = 0000;
const int FEAT_HATED_ENEMY_SHAPECHANGER = 0000;
const int FEAT_HATED_ENEMY_UNDEAD = 0000;
const int FEAT_HATED_ENEMY_VERMIN = 0000;


///////////////////////////////////////////////////////////////
// Foe Hunter Spells
///////////////////////////////////////////////////////////////
const int SPELL_RANCOR = 0000;
const int SPELL_DEATH_ATTACK = 0000;


///////////////////////////////////////////////////////////////
// Tempest Functions
///////////////////////////////////////////////////////////////

// returns 1 if true 0 if false
// no longer needed, but I left the code
// in case anyone could use it in the future
int GetIsSmallWeapon(object oWeap)
{
    int itemType = GetBaseItemType(oWeap);
    
    switch(itemType)
    {
         case BASE_ITEM_DAGGER:
	      return 1;
         case BASE_ITEM_SHORTSWORD:
	      return 1;
         case BASE_ITEM_KUKRI:
	      return 1;
         case BASE_ITEM_KAMA:
	      return 1;
         case BASE_ITEM_HANDAXE:
	      return 1;
         case BASE_ITEM_LIGHTMACE:
	      return 1;
         case BASE_ITEM_LIGHTHAMMER:
	      return 1;
         case BASE_ITEM_SICKLE:
	      return 1;
         case BASE_ITEM_RAPIER: // Technically "medium"
	      return 1;	    
         case BASE_ITEM_CLUB:   // Technically "medium"
	      return 0;
    }
    
    // if it is not one of the small weapons
    return 0;   
}


///////////////////////////////////////////////////////////////
//  GetArmorType
///////////////////////////////////////////////////////////////
const int ARMOR_TYPE_CLOTH      = 0;
const int ARMOR_TYPE_LIGHT      = 1;
const int ARMOR_TYPE_MEDIUM     = 2;
const int ARMOR_TYPE_HEAVY      = 3;
  
// returns -1 on error, or base AC of armor
int GetItemACBase(object oArmor)
{
    int nBonusAC = 0;
  
    // oItem is not armor then return an error
    if(GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
        return -1;
  
    // check each itemproperty for AC Bonus
    itemproperty ipAC = GetFirstItemProperty(oArmor);
    
    while(GetIsItemPropertyValid(ipAC))
    {
        int nType = GetItemPropertyType(ipAC);
  
        // check for ITEM_PROPERTY_AC_BONUS
        if(nType == ITEM_PROPERTY_AC_BONUS)
        {
            nBonusAC = GetItemPropertyCostTableValue(ipAC);
            break;
        }
  
        // get next itemproperty
        ipAC = GetNextItemProperty(oArmor);
    }
  
    // return base AC
    return GetItemACValue(oArmor) - nBonusAC;
}

// returns -1 on error, or the const int ARMOR_TYPE_*
int GetArmorType(object oArmor)
{
    int nType = -1;
  
    // get and check Base AC
    switch(GetItemACBase(oArmor) )
    {
        case 0: nType = ARMOR_TYPE_CLOTH;   break;
        case 1: nType = ARMOR_TYPE_LIGHT;   break;
        case 2: nType = ARMOR_TYPE_LIGHT;   break;
        case 3: nType = ARMOR_TYPE_LIGHT;   break;
        case 4: nType = ARMOR_TYPE_MEDIUM;  break;
        case 5: nType = ARMOR_TYPE_MEDIUM;  break;
        case 6: nType = ARMOR_TYPE_HEAVY;   break;
        case 7: nType = ARMOR_TYPE_HEAVY;   break;
        case 8: nType = ARMOR_TYPE_HEAVY;   break;
    }
    
    // return type
    return nType;
}