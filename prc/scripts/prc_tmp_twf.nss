//::///////////////////////////////////////////////
//:: Tempest - Greater and Supreme Two Weapon Fighting
//:: Copyright (c) 2004 
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "nw_i0_spells"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING) )
     {    
          object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
          
          int armorType = GetArmorType(oArmor);
          int tempestLevel = GetLevelByClass(CLASS_TYPE_TEMPEST, oPC);
          int monkLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacks = 0;
          int attackPenalty = 0;
          
          if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC) )
          {
              numAddAttacks = 1;
              attackPenalty = 2;
              nMes = "*Greater Two Weapon Fighting Activated*";
          }
          if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING, oPC) )
          {
              numAddAttacks = 2;
              attackPenalty = 4;
              nMes = "*Supreme Two Weapon Fighting Activated*";
          }

          if(monkLevel > 0 && GetBaseItemType(oWeapL) == BASE_ITEM_KAMA)
          {
              numAddAttacks = 0;
              attackPenalty = 0;
              nMes = "*No Extra Attacks Gained by Dual Kama Monks!*";              
          }
          
          // If feat is on a tempest, check armor type
          if(tempestLevel > 4 && armorType < ARMOR_TYPE_MEDIUM)
          {
               if(oWeapR != OBJECT_INVALID  && oWeapL != OBJECT_INVALID && oWeapL != oWeapR)
              {
                   effect addAtt = SupernaturalEffect( EffectModifyAttacks(numAddAttacks) );
                   effect attPen = SupernaturalEffect( EffectAttackDecrease(attackPenalty) );
                   effect eLink = EffectLinkEffects(addAtt, attPen);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
                   SetLocalInt(oPC, "HasTwoWeapEffects", 2);            
              }
              else
              {
                   nMes = "*Invalid Weapon.  Ability Not Activated!*";
              }
          }
          else
          {
               if(oWeapR != OBJECT_INVALID  && oWeapL != OBJECT_INVALID && oWeapL != oWeapR)
              {
                   effect addAtt = SupernaturalEffect( EffectModifyAttacks(numAddAttacks) );
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, addAtt, oPC);
                   SetLocalInt(oPC, "HasTwoWeapEffects", 2);        
              }  
              else
              {
                   nMes = "*Invalid Weapon.  Ability Not Activated!*";
              }          
          }          

          FloatingTextStringOnCreature(nMes, oPC, FALSE);    
     }
     else
     {   
          // Removes effects
          RemoveSpellEffects(SPELL_T_TWO_WEAPON_FIGHTING, oPC, oPC);

          // Display message to player
          if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC) )
          {
              nMes = "*Greater Two Weapon Fighting Deactivated*";
          }
          if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING, oPC) )
          {
              nMes = "*Supreme Two Weapon Fighting Deactivated*";
          }
          FloatingTextStringOnCreature(nMes, oPC, FALSE);
     }  
}