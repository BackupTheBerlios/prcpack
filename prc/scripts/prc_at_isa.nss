//::///////////////////////////////////////////////
//:: Arcane Trickster
//:://////////////////////////////////////////////
/*
    Script to Simulate the Impromptu Sneak Attack
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 11, 2004
//:://////////////////////////////////////////////

#include "inc_addragebonus" // for determining weapon damage type
#include "inc_combat"       // for DoMeleeAttack
#include "x2_inc_itemprop"  // for IPGetIsMeleeWeapon

// Includes for PrC's
#include "prc_inc_oni"
#include "strat_prc_inc"

int GetTotalSneakAttackDice(object oPC)
{
     int iRogueDice = 0;
     int iBlackGuardDice = 0;
     int iAssassinDice = 0;
     int iSneakAttackDice = 0;
     
     int iRogueLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
     int iBlackGuardLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
     int iAssassinLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
     
     // Place other PrC's here
     int iArcaneTricksterLevel = GetLevelByClass(CLASS_TYPE_ARCTRICK, oPC);
     int iArcaneTricksterDice = 0;
     
     // Use template to add checks for other PrC's
     // int iXXXXXXLevel = GetLevelByClass(CLASS_TYPE_*, oPC);
     // int iXXXXDice = 0;
     
     // Every other rogue level starting at one
     if( (iRogueLevel%2) != 0)
     {
          // is odd number, so add +1
          iRogueDice = (iRogueLevel/2) + 1;
     }
     else
     {
          iRogueDice = iRogueLevel/2;
     }
 
     // Every 3rd black guard level starting at 4
     if( (iBlackGuardLevel%3) != 0 && iBlackGuardLevel > 3)
     {
          // is odd number, so add +1
          iBlackGuardDice = (iBlackGuardLevel/3) + 1;
     }
     else
     {
          iBlackGuardDice = iBlackGuardLevel/3;
     }
 
     // Every other level starting at one
     if( (iAssassinLevel%2) != 0)
     {
          // is odd number, so add +1
          iAssassinDice = (iAssassinLevel/2) + 1;
     }
     else
     {
          iAssassinDice = iAssassinLevel/2;
     }
     
     // For Arcane Trickster 
     // Every other level starting at 2
     iArcaneTricksterDice = iArcaneTricksterLevel/2;
 
     // checks for epic feats that add sneak damage
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10) )
     {
         iSneakAttackDice = iSneakAttackDice + 1;
     }
     
     iSneakAttackDice = iSneakAttackDice + iRogueDice + iBlackGuardDice + iAssassinDice;
     iSneakAttackDice = iSneakAttackDice + iArcaneTricksterDice;
     
     // use template to add any additional PrC's that have sneak attack
     //iSneakAttackDice = iSneakAttackDice + iXXXXDice;
     
     return iSneakAttackDice;
}

int GetSneakAttackDamage(int iSneakAttackDice)
{
     int iSneakAttackDamage = d6(iSneakAttackDice);     
     return iSneakAttackDamage;
}

void main()
{
     object oTarget = GetSpellTargetObject();
     int iEnemydexBonus = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
     
     object oPC = OBJECT_SELF;
     int nDamageBonusType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, oPC);
     int iSneakAttackDice = GetTotalSneakAttackDice(oPC);
     
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
     
     string nMes = "";
     int iWeapDamage = 0;
     int iSneakDamage = 0;
     int iAttack = 0;
     
     int isMeleeWeapon = IPGetIsMeleeWeapon(oWeap);
     
     // adds the enemies dex bonus to attack to simulate enemy not having 
     // their dex bonus to AC
     if(isMeleeWeapon)
     {
     	  iAttack = DoMeleeAttack(oPC, oWeap, oTarget, iEnemydexBonus, TRUE, 0.0);
     }
     else
     {
          iAttack = DoRangedAttack(oPC, oWeap, oTarget, iEnemydexBonus, TRUE, 0.0);
     }
     
     if(iAttack > 0)
     {
          if(isMeleeWeapon)
          {
              if(iAttack == 2)  // Critical
              {
                   iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, TRUE, 0);
              }
              else
              {
                   iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, FALSE, 0);
              }
          }
          else
          {
              if(iAttack == 2)  // Critical
              {
                   iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, TRUE, 0);
              }
              else
              {
                   iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, FALSE, 0);
              }          
          }
               
          iSneakDamage = GetSneakAttackDamage(iSneakAttackDice);
          
          int itotDam = iWeapDamage + iSneakDamage;
          
          effect eTotalDamage = EffectDamage(itotDam, nDamageBonusType, DAMAGE_POWER_NORMAL);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eTotalDamage, oTarget);
          
          string damage = "Impromtu Sneak Attack Damage: " + IntToString(iSneakDamage);
          SendMessageToPC(oPC, damage);
          nMes = "*Impromptu Sneak Attack Hit*";
     }
     else
     {
          nMes = "*Impromptu Sneak Attack Missed*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
     
     
     // Other main hand attacks for the round
     int iBaB = GetBaseAttackBonus(oPC);
     int iNumAttacks = FloatToInt( (iBaB + 0.5)/5 );
     int attPenalty = -5;
     
     int i;
     
     for(i = 1; i < iNumAttacks; i++)
     {
          if(isMeleeWeapon)
          {
               iAttack = DoMeleeAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);               
               if(iAttack == 2)
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, FALSE, 0);
               }
          }
          else
          {
               iAttack = DoRangedAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);
               if(iAttack == 2)
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, FALSE, 0);
               }
          }

          effect eDam = EffectDamage(iWeapDamage, nDamageBonusType, DAMAGE_POWER_NORMAL);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
          
          attPenalty += -5;
     }
     
     // Off-hand Attacks
     if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING) && oWeapL != OBJECT_INVALID)
     {
          iNumAttacks = 2;
     }
     else if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING) && oWeapL != OBJECT_INVALID)
     {
          iNumAttacks = 1;
     }
     else if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING) && oWeapL != OBJECT_INVALID)
     {
          iNumAttacks = 3;    
     }
     
     attPenalty = 0;
     
     // Perform the off-hand attacks
     for(i = 0; i < iNumAttacks; i++)
     {
          if(isMeleeWeapon)
          {
               iAttack = DoMeleeAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);               
               if(iAttack == 2)
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapL, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapL, FALSE, 0);
               }
          }
          else
          {
               iAttack = DoRangedAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);
               if(iAttack == 2)
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeapL, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeapL, FALSE, 0);
               }
          }

          effect eDam = EffectDamage(iWeapDamage, nDamageBonusType, DAMAGE_POWER_NORMAL);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
          
          attPenalty += -5;
     }     
}