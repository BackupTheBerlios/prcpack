//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Foe Hunter DR
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
     object oPC = OBJECT_SELF;
     object oFoe = GetLastDamager();
     
     int iFoeRace = GetRacialType(oFoe);
     int iHatedFoe = GetLocalInt(oPC, "HatedFoeDR");

     int iDR = GetLocalInt(oPC, "HatedFoe");
     int iDamageTaken = GetTotalDamageDealt();
     
     int iHeal = 0;
          
     if(iFoeRace == iHatedFoe && iDamageTaken > 0)
     {
          // Prevents player from regaining more HP than damage taken
          if(iDamageTaken >= iDR)
          {
               iHeal = iDR;
          }
          else
          {
               iHeal = iDamageTaken;
          }
          
          effect eHeal = EffectHeal(iHeal);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
     }
}