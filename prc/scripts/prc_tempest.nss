//::///////////////////////////////////////////////
//:: Tempest
//:://////////////////////////////////////////////
/*
    Script to modify skin of Tempest
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 5, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "nw_i0_spells"
#include "x2_inc_itemprop"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void ApplyAbsAmbidex(object oPC)
{
     // former code that should have added it to the
     // player skin, but did not function...
     //itemproperty ipAB = ItemPropertyAttackBonus(2);
     //AddItemProperty(DURATION_TYPE_PERMANENT, ipAB, oSkin);

     effect eAB = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC);
     
     SetLocalInt(oPC, "HasAbsAmbidex", 2);
}

void RemoveAbsAmbidex(object oPC)
{
     RemoveSpecificEffect(EFFECT_TYPE_ATTACK_INCREASE, oPC);
     SetLocalInt(oPC, "HasAbsAmbidex", 1);
}

void ApplyTwoWeaponDefense(object oPC, object oSkin)
{       
     int ACBonus = 0;
     int tempestLevel = GetLevelByClass(CLASS_TYPE_TEMPEST, oPC);
               
     if(tempestLevel < 4)
     {
          ACBonus = 1; 
     }     
     else if(tempestLevel >= 4 && tempestLevel < 7)
     {
          ACBonus = 2;
     }          
     else if(tempestLevel >= 7)
     {
          ACBonus = 3;	
     }

     itemproperty ipACBonus = ItemPropertyACBonus(ACBonus);
     AddItemProperty(DURATION_TYPE_PERMANENT, ipACBonus, oSkin);
          
     SetLocalInt(oPC, "HasTWD", 2);
}

void RemoveTwoWeaponDefense(object oPC, object oSkin)
{
     itemproperty iprop = GetFirstItemProperty(oSkin);

     while (GetIsItemPropertyValid(iprop))
     {
          if(GetItemPropertyType(iprop) == ITEM_PROPERTY_AC_BONUS)
          {
               RemoveItemProperty(oSkin, iprop);
          }
          iprop = GetNextItemProperty(oSkin);
     }
     
     SetLocalInt(oPC, "HasTWD", 1);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    
    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    
    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    int armorType = GetArmorType(oArmor);
    
    string nMes = "";

    // On Error Remove effects
    // This typically occurs On Load
    // Because the variables are not yet set.
    if(GetLocalInt(oPC, "HasAbsAmbidex") == 0 && GetLocalInt(oPC, "HasTWD") == 0 )
    {
         RemoveAbsAmbidex(oPC);    
         RemoveTwoWeaponDefense(oPC, oSkin);
         
         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              RemoveSpellEffects(SPELL_T_TWO_WEAPON_FIGHTING, oPC, oPC); 
         }
    
         nMes = "*Removing Invallid Effects*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);    
    }
    else if( armorType > ARMOR_TYPE_LIGHT )
    {
         RemoveAbsAmbidex(oPC);    
         RemoveTwoWeaponDefense(oPC, oSkin);
         
         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              RemoveSpellEffects(SPELL_T_TWO_WEAPON_FIGHTING, oPC, oPC); 
         }

         nMes = "*Two-Weapon Fighting Abilities Disabled Due To Equipped Armor*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
    }
    else if(oWeapR == OBJECT_INVALID || oWeapL == OBJECT_INVALID || oWeapR == oWeapL)
    {
         RemoveAbsAmbidex(oPC);    
         RemoveTwoWeaponDefense(oPC, oSkin);
         
         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              RemoveSpellEffects(SPELL_T_TWO_WEAPON_FIGHTING, oPC, oPC); 
         }

         nMes = "*Two-Weapon Fighting Abilities Disabled Due To Invallid Weapon*";
         FloatingTextStringOnCreature(nMes, oPC, FALSE);
    }
    else
    {
          // Is only called if Absolute Ambidex has been previously removed
          if(GetLocalInt(oPC, "HasAbsAmbidex") == 1 && GetHasFeat(FEAT_ABSOLUTE_AMBIDEX, oPC) )
          {
               ApplyAbsAmbidex(oPC);

               nMes = "*Absolute Ambidexterity Activated*";
               FloatingTextStringOnCreature(nMes, oPC, FALSE);
          }

          // Is called anytime TWD might have been upgraded
          // specifically set this way for level up
          if(GetLocalInt(oPC, "HasTWD") != 0 && GetHasFeat(FEAT_TWO_WEAPON_DEFENSE, oPC) )
          {
               RemoveTwoWeaponDefense(oPC, oSkin);
               ApplyTwoWeaponDefense(oPC, oSkin);
          
               nMes = "*Two-Weapon Defense Activated*";
               FloatingTextStringOnCreature(nMes, oPC, FALSE);
          }
     }
}
