//::///////////////////////////////////////////////
//:: Frenzied Berserker - Remove effects of Supreme Power Attack
//:: NW_S1_frebzk
//:: Copyright (c) 2004 
//:://////////////////////////////////////////////
/*
    Removes bonuses of Supreme Power Attack
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "inc_addragebonus"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
     if(GetHasFeatEffect(FEAT_FRENZY))
     {
          int willSave = WillSave(OBJECT_SELF, 20, SAVING_THROW_TYPE_NONE, OBJECT_SELF);          
          if(willSave == 1)
          {
               RemoveSpellEffects(SPELL_FRENZY, OBJECT_SELF, OBJECT_SELF);
               RemoveSpecificEffect(EFFECT_TYPE_DAMAGE_INCREASE, OBJECT_SELF);
               RemoveSpecificEffect(EFFECT_TYPE_ATTACK_DECREASE, OBJECT_SELF);
          }
     }
}