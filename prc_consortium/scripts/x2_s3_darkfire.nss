 //::///////////////////////////////////////////////
//:: OnHit Darkfire
//:: x2_s3_darkfire
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

   OnHit Castspell Fire Damage property for the
   flaming weapon spell (x2_s0_flmeweap).

   We need to use this property because we can not
   add random elemental damage to a weapon in any
   other way and implementation should be as close
   as possible to the book.

   Behavior:
   The casterlevel is set as a variable on the
   weapon, so if players leave and rejoin, it
   is lost (and the script will just assume a
   minimal caster level).


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-17
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin on Dec 4, 2003 for prc stuff - caster level left alone.

#include "prc_alterations"



void main()
{


//string toSay =  " Self: " + GetTag(OBJECT_SELF) + " Item: " + GetTag(GetSpellCastItem());
//SendMessageToPC(OBJECT_SELF, toSay);
//  GetTag(OBJECT_SELF) was nothing, just ""  and the SendMessageToPC sent the message to my player.
//  It's funny because I thought player characters had tags :-?  So who knows what to make of it?

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

object oWeapon = GetSpellCastItem();

int nDamageType = GetLocalInt(oWeapon, "X2_Wep_Dam_Type");
int nAppearanceTypeS = VFX_IMP_FLAME_S;
int nAppearanceTypeM = VFX_IMP_FLAME_M;

switch(nDamageType)
{
   case DAMAGE_TYPE_ACID: nAppearanceTypeS = VFX_IMP_ACID_S; nAppearanceTypeM = VFX_IMP_ACID_L; break;
   case DAMAGE_TYPE_COLD: nAppearanceTypeS = VFX_IMP_FROST_S; nAppearanceTypeM = VFX_IMP_FROST_L; break;
   case DAMAGE_TYPE_ELECTRICAL: nAppearanceTypeS = VFX_IMP_LIGHTNING_S; nAppearanceTypeM =VFX_IMP_LIGHTNING_M;break;
   case DAMAGE_TYPE_SONIC: nAppearanceTypeS = VFX_IMP_SONIC; nAppearanceTypeM = VFX_IMP_SONIC; break;
}




  // Get Caster Level
  int nLevel = GetLocalInt(oWeapon, "X2_Wep_Caster_Lvl");
  //int nLevel = GetCasterLevel(OBJECT_SELF); - OBJECT_SELF is whoever is holding the weapon.

  int nDmg = d6() + (nLevel/2);

  effect eDmg = EffectDamage(nDmg,nDamageType);
  effect eVis;
  if (nDmg<10) // if we are doing below 12 point of damage, use small flame
  {
    eVis =EffectVisualEffect(nAppearanceTypeS);
  }
  else
  {
     eVis =EffectVisualEffect(nAppearanceTypeM);
  }
  eDmg = EffectLinkEffects (eVis, eDmg);
  object oTarget = GetSpellTargetObject();

  if (GetIsObjectValid(oTarget))
  {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
  }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
