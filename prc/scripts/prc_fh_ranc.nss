//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Foe Hunter Rancor Attack
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

#include "inc_combat"       // for DoMeleeAttack
#include "x2_inc_itemprop"  // for IPGetIsMeleeWeapon

#include "NW_I0_GENERIC"

int GetRancorDice(object oPC)
{
     int iFHLevel = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC);
     int iRancorDice = FloatToInt( (( iFHLevel + 1.0 ) /2) );
     
     return iRancorDice;
}

int GetRancorDamage(int iNumDice)
{
     int rDam = d6(iNumDice);
     
     return rDam;
}

int GetIsDeniedDexBonusToAC(object oPC, object oTarget)
{
     int isDenied = 0;

     if( GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget) )     isDenied = 1;
     if( GetHasEffect(EFFECT_TYPE_DAZED, oTarget) )         isDenied = 1;
     if( GetHasEffect(EFFECT_TYPE_ENTANGLE, oTarget) )      isDenied = 1;
     if( GetHasEffect(EFFECT_TYPE_FRIGHTENED, oTarget) )    isDenied = 1;
     if( GetHasEffect(EFFECT_TYPE_PARALYZE, oTarget) )      isDenied = 1;
     if( GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) )       isDenied = 1;
     if( GetHasEffect(EFFECT_TYPE_SLEEP, oTarget) )         isDenied = 1;
     if( GetHasEffect(EFFECT_TYPE_STUNNED, oTarget) )       isDenied = 1;
     
     if(GetFlankingRightLocation(oTarget) == GetLocation(oPC) || GetFlankingLeftLocation(oTarget) == GetLocation(oPC) || GetBehindLocation(oTarget) == GetLocation(oPC) )
     {
          isDenied = 1;
     }
     
     return isDenied;
}

void main()
{
     object oTarget = GetSpellTargetObject();
     
     object oPC = OBJECT_SELF;
     object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
     
     int iWeapRDamageType = GetWeaponDamageType(oWeapR);
     int iWeapLDamageType = GetWeaponDamageType(oWeapL);
     
     // vars for attack rolls
     int iBaB = GetBaseAttackBonus(oPC);
     int iAttackPenalty = 0;
     int iAttack = 0;
     int iMainHandAttacks =  FloatToInt( (iBaB + 0.5)/5 );
     int iOffHandAttacks = 0;
     int isMeleeWeapon = IPGetIsMeleeWeapon(oWeapR);
     int isEnemyDeniedDex = GetIsDeniedDexBonusToAC(oPC, oTarget);
     
     // damage vars
     int iRancorDamage;
     int iWeapDamage;     
     
     // Adjusts the number of off-hand attacks based on feats
     if(oWeapR != oWeapL && oWeapL != OBJECT_INVALID  && isMeleeWeapon)
     {
          // they are wielding two weapons so at least 1 off-hand attack
          iOffHandAttacks = 1;
          
          if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING) )	iOffHandAttacks = 2;
          if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING) )	iOffHandAttacks = 3;
          if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING) )	iOffHandAttacks = 4;
          
          if(iOffHandAttacks > iMainHandAttacks)
          {
               iOffHandAttacks = iMainHandAttacks;
          }
     }
     
     int i;
     
     if(isMeleeWeapon)
     {
          for(i = 0; i < iMainHandAttacks; i++)
          {
               if(GetCurrentHitPoints(oTarget) > 0 )
               {
                    iAttack = DoMeleeAttack(oPC, oWeapR, oTarget, iAttackPenalty, TRUE, 0.0);
                    iRancorDamage = 0;
                    iWeapDamage = 0;
               
                    // Perform Death attack on first attack if they have the feat
                    if( i == 0 && GetHasFeat(FEAT_DEATH_ATTACK) && isEnemyDeniedDex  && iAttack != 0)
                    {
                         int iSaveDC = 10 + GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC) + GetAbilityModifier(ABILITY_INTELLIGENCE);
                         int iFortSave = FortitudeSave(oTarget, iSaveDC, SAVING_THROW_TYPE_DEATH, oPC);
                    
                         if(iFortSave == 0)    // Failed save
                         {
                             effect eDeath = EffectDeath();
                             ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                        
                             FloatingTextStringOnCreature("*Death Attack Hit*", oPC, FALSE);  
                         }
                    }
                    else if( i == 0 && GetHasFeat(FEAT_RANCOR)  && iAttack != 0)  // else use Rancor
                    {
                         iRancorDamage = GetRancorDamage(GetRancorDice(oPC) );
          
                         string damage = "Rancor Attack Damage: " + IntToString(iRancorDamage);
                         SendMessageToPC(oPC, damage);
                         FloatingTextStringOnCreature("*Rancor Attack Hit*", oPC, FALSE);
                    }
          
                    // If they have death attack, use Rancor on second attack
                    if(i == 1 && GetHasFeat(FEAT_DEATH_ATTACK) && iAttack !=0)
                    {
                         iRancorDamage = GetRancorDamage(GetRancorDice(oPC) );   
          
                         string damage = "Rancor Attack Damage: " + IntToString(iRancorDamage);
                         SendMessageToPC(oPC, damage);
                         FloatingTextStringOnCreature("*Rancor Attack Hit*", oPC, FALSE);                    
                    }
                          
                    if(iAttack == 2)       // Critical Hit
                    {
                         iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapR, TRUE, 0);
                    }
                    else                   // Normal Hit
                    {
                         iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapR, FALSE, 0);
                    }
                    
                    int iTotDam = iWeapDamage + iRancorDamage;
                    effect eTotalDamage = EffectDamage(iTotDam, iWeapRDamageType, DAMAGE_POWER_NORMAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eTotalDamage, oTarget);
               
                    iAttackPenalty += -5;
               }
          }
          
          iAttackPenalty = 0;
          
          // runs off-hand attacks
          for(i = 0; i < iOffHandAttacks; i++)
          {
               if(GetCurrentHitPoints(oTarget) > 0 )
               {
                    iAttack = DoMeleeAttack(oPC, oWeapR, oTarget, iAttackPenalty, TRUE, 0.0);
                    iWeapDamage = 0;               

                    if(iAttack == 2)       // Critical Hit
                    {
                         iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapL, TRUE, 0);
                    }
                    else                   // Normal Hit
                    {
                         iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapL, FALSE, 0);
                    }
                    
                    effect eTotalDamage = EffectDamage(iWeapDamage, iWeapLDamageType, DAMAGE_POWER_NORMAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eTotalDamage, oTarget);
               
                    iAttackPenalty += -5;
               }
          }
     }
     else  // For ranged attacks
     {
          for(i = 0; i < iMainHandAttacks; i++)
          {
               if(GetCurrentHitPoints(oTarget) > 0 )
               {
                    iAttack = DoRangedAttack(oPC, oWeapR, oTarget, iAttackPenalty, TRUE, 0.0);
                    iRancorDamage = 0;
                    iWeapDamage = 0;
               
                    // Perform Death attack on first attack if they have the feat
                    if( i == 0 && GetHasFeat(FEAT_DEATH_ATTACK) && isEnemyDeniedDex  && iAttack != 0)
                    {
                         int iSaveDC = 10 + GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC) + GetAbilityModifier(ABILITY_INTELLIGENCE);
                         int iFortSave = FortitudeSave(oTarget, iSaveDC, SAVING_THROW_TYPE_DEATH, oPC);
                    
                         if(iFortSave == 0)    // Failed save
                         {
                             effect eDeath = EffectDeath();
                             ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                        
                             FloatingTextStringOnCreature("*Death Attack Hit*", oPC, FALSE);  
                         }
                    }
                    else if( i == 0 && GetHasFeat(FEAT_RANCOR)  && iAttack != 0)  // else use Rancor
                    {
                         iRancorDamage = GetRancorDamage(GetRancorDice(oPC) );
          
                         string damage = "Rancor Attack Damage: " + IntToString(iRancorDamage);
                         SendMessageToPC(oPC, damage);
                         FloatingTextStringOnCreature("*Rancor Attack Hit*", oPC, FALSE);
                    }
          
                    // If they have death attack, use Rancor on second attack
                    if(i == 1 && GetHasFeat(FEAT_DEATH_ATTACK) && iAttack !=0)
                    {
                         iRancorDamage = GetRancorDamage(GetRancorDice(oPC) );   
          
                         string damage = "Rancor Attack Damage: " + IntToString(iRancorDamage);
                         SendMessageToPC(oPC, damage);
                         FloatingTextStringOnCreature("*Rancor Attack Hit*", oPC, FALSE);                    
                    }
                          
                    if(iAttack == 2)       // Critical Hit
                    {
                         iWeapDamage = GetRangedWeaponDamage(oPC, oWeapR, TRUE, 0);
                    }
                    else                   // Normal Hit
                    {
                         iWeapDamage = GetRangedWeaponDamage(oPC, oWeapR, FALSE, 0);
                    }
                    
                    int iTotDam = iWeapDamage + iRancorDamage;
                    effect eTotalDamage = EffectDamage(iTotDam, iWeapRDamageType, DAMAGE_POWER_NORMAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eTotalDamage, oTarget);
               
                    iAttackPenalty += -5;
               }
          }
          
          iAttackPenalty = 0;
          
          // runs off-hand attacks
          for(i = 0; i < iOffHandAttacks; i++)
          {
               if(GetCurrentHitPoints(oTarget) > 0 )
               {
                    iAttack = DoRangedAttack(oPC, oWeapR, oTarget, iAttackPenalty, TRUE, 0.0);
                    iWeapDamage = 0;               

                    if(iAttack == 2)       // Critical Hit
                    {
                         iWeapDamage = GetRangedWeaponDamage(oPC, oWeapL, TRUE, 0);
                    }
                    else                   // Normal Hit
                    {
                         iWeapDamage = GetRangedWeaponDamage(oPC, oWeapL, FALSE, 0);
                    }
                    
                    effect eTotalDamage = EffectDamage(iWeapDamage, iWeapLDamageType, DAMAGE_POWER_NORMAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eTotalDamage, oTarget);
               
                    iAttackPenalty += -5;
               }
          }     
     }
}