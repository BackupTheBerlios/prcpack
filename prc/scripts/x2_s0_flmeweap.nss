 //::///////////////////////////////////////////////
//:: Flame Weapon
//:: X2_S0_FlmeWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Gives a melee weapon 1d4 fire damage +1 per caster
  level to a maximum of +10.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"


#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"

void DeleteTheInts(object oTarget)
{
DeleteLocalInt(oTarget, "X2_Wep_Dam_Type");
DeleteLocalInt(oTarget, "X2_Wep_Caster_Lvl");
}
/// Used simply to use up a bit less processor time on the delayed command to delete these 2 Ints.

void AddFlamingEffectToWeapon(object oTarget, float fDuration, int nCasterLevel)
{
   int nAppearanceType = ITEM_VISUAL_FIRE;
   int nDamageType = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE);
   //SendMessageToPC(OBJECT_SELF, "I am the caster");
   switch(nDamageType)
   {
   case DAMAGE_TYPE_ACID: nAppearanceType = ITEM_VISUAL_ACID; break;
   case DAMAGE_TYPE_COLD: nAppearanceType = ITEM_VISUAL_COLD; break;
   case DAMAGE_TYPE_ELECTRICAL: nAppearanceType = ITEM_VISUAL_ELECTRICAL; break;
   case DAMAGE_TYPE_SONIC: nAppearanceType = ITEM_VISUAL_SONIC; break;
   }
   DeleteLocalInt(oTarget, "X2_Wep_Dam_Type");
   SetLocalInt(oTarget, "X2_Wep_Dam_Type", nDamageType);

   // Sets Caster Level int because it was too confusing trying to figure out caster level
   // in the damage script.
   DeleteLocalInt(oTarget, "X2_Wep_Caster_Lvl");
   SetLocalInt(oTarget, "X2_Wep_Caster_Lvl", nCasterLevel);

   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(124,nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(nAppearanceType), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   DelayCommand(fDuration, DeleteTheInts(oTarget));

   return;
}




void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = 2 * (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF);

    //Limit nCasterLvl to 10, so it max out at +10 to the damage.
    if(nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

   object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

   if(GetIsObjectValid(oMyWeapon) )
   {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            // haaaack: store caster level on item for the on hit spell to work properly
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            AddFlamingEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration),nCasterLvl);

         }
            return;
    }
     else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
