//::///////////////////////////////////////////////
//:: Frenzied Berserker - Supreme Power Attack
//:: NW_S1_frebzk
//:: Copyright (c) 2004 
//:: Special thanks to mr bumpkin for the GetWeaponDamageType function  :)
//:://////////////////////////////////////////////
/*
    Decreases attack by 10 and increases damage by 20
    Damage is based on weapon type (Slashing, peircing, etc.)
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "inc_addragebonus"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
     effect eDamage;
     effect eToHit;
     
     if(GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_POWER_ATTACK) == FALSE && !GetActionMode(OBJECT_SELF, ACTION_MODE_POWER_ATTACK == FALSE))
     {
          if(!GetHasFeatEffect(FEAT_SUPREME_POWER_ATTACK))
          {
               int nDamageBonusType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
               eDamage = EffectDamageIncrease(DAMAGE_BONUS_20, nDamageBonusType);               
               eToHit = EffectAttackDecrease(10);

               effect eLink = ExtraordinaryEffect(EffectLinkEffects(eDamage, eToHit));
               ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
               
               string nMes = "*Supreme Power Attack Mode Activated*";
               FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
          }
          else
          {          
               RemoveSpecificEffect(EFFECT_TYPE_DAMAGE_INCREASE, OBJECT_SELF);
               RemoveSpecificEffect(EFFECT_TYPE_ATTACK_DECREASE, OBJECT_SELF);

               string nMes = "*Supreme Power Attack Mode Deactivated*";
               FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
          }          
     }
}