//::///////////////////////////////////////////////
//:: Name Dragonwrack
//:: FileName ft_dw_armor.nss
//:://////////////////////////////////////////////
/*
    Dragonwrack for the Vassal of Bahamut's Armor
*/
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Created On: 5 april 2004
//:://////////////////////////////////////////////

void main()
{
     int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);
     object oTarget = GetSpellTargetObject();
     int iDam;
     effect eDam;
     if (nVassal = 10)
     {
     iDam = d6(2);
     }
     else if (nVassal >= 4)
     {
     iDam = d6(1);
     }
     eDam = EffectDamage(iDam);
     if (GetRacialType(oTarget)==RACIAL_TYPE_DRAGON)
     {
         if (GetAlignmentGoodEvil(oTarget)==ALIGNMENT_EVIL)
         {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
         }
     }
}