#include "inc_combat"

// * Performs a ranged attack roll by oPC against oTarget.
// * Begins with BAB; to simulate multiple attacks in one round,
// * use iMod to add a -5 modifier for each consecutive attack.
// * If bShowFeedback is TRUE, display the attack roll in oPC's
// * message window after a delay of fDelay seconds.
// * Caveat: Cannot account for ATTACK_BONUS effects on oPC
int DoRangedAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0);

// Get Bonus Mighty
int GetMightyWeapon(object oWeap);

// * Returns an integer amount of damage done by oPC with oWeap
// * Caveat: Cannot account for DAMAGE_BONUS effects on oPC
int GetRangedWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0,int bCritMult=0);

// * Returns an  Alignment Group
int ConvAlignGr(int iGoodEvil,int iLawChaos);

// * Returns Weapon Attack bonus
// * With Alignement Bonus
int GetWeaponAtkBonusIP(object oWeap,object oTarget);

// * Return Melee Attacker around 15 feet (TRUE or FALSE).
int GetMeleeAttackers15ft();

// Return  attacks by round
int NbAtk(object oPC);


int ConvAlignGr(int iGoodEvil,int iLawChaos)
{
   int Align;

   switch(iGoodEvil)
   {
    case ALIGNMENT_GOOD:
        Align=0;
        break;
    case ALIGNMENT_NEUTRAL:
        Align=1;
        break;
    case ALIGNMENT_EVIL:
        Align=2;
        break;
   }
    switch(iLawChaos)
   {
    case ALIGNMENT_LAWFUL:
        Align+=0;
        break;
    case ALIGNMENT_NEUTRAL:
        Align+=3;
        break;
    case ALIGNMENT_CHAOTIC:
        Align+=6;
        break;
   }
    return Align;
}


int GetWeaponAtkBonusIP(object oWeap,object oTarget)
{
    int iBonus = 0;
    int iTemp;

    int iRace=GetRacialType(oTarget);

    int iGoodEvil=GetAlignmentGoodEvil(oTarget);
    int iLawChaos=GetAlignmentLawChaos(oTarget);
    int iAlignSp=ConvAlignGr(iGoodEvil,iLawChaos);
    int iAlignGr;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int iIp=GetItemPropertyType(ip);
        switch(iIp)
        {
            case ITEM_PROPERTY_ATTACK_BONUS:
                iTemp = GetItemPropertyCostTableValue(ip);
                break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
                iAlignGr=GetItemPropertySubType(ip);

                if (iAlignGr==ALIGNMENT_NEUTRAL)
                {
                   if (iAlignGr==iLawChaos)
                       iTemp =GetItemPropertyCostTableValue(ip);
                }
                else if (iAlignGr==iGoodEvil || iAlignGr==iLawChaos || iAlignGr==IP_CONST_ALIGNMENTGROUP_ALL)
                   iTemp =GetItemPropertyCostTableValue(ip);

                break;
            case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
                iTemp = GetItemPropertySubType(ip)==iRace ? GetItemPropertyCostTableValue(ip):-1 ;
                break;
            case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
                iTemp = GetItemPropertySubType(ip)==iAlignSp ? GetItemPropertyCostTableValue(ip):-1 ;
                break;

        }

        iBonus = iTemp > iBonus ? iTemp : iBonus;
        ip = GetNextItemProperty(oWeap);
    }

    return iBonus;
}

int GetMeleeAttackers15ft()
{
    int nCnt = 0;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, GetLocation(OBJECT_SELF), TRUE);

    while(GetIsObjectValid(oTarget) && !nCnt)
    {
         if(GetIsEnemy(oTarget)) nCnt++;

         oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.0, GetLocation(OBJECT_SELF), TRUE);
    }
    return nCnt;
}

int NbAtk(object oPC)
{
  int BAB=GetBaseAttackBonus(oPC);
  int LvlCarac=GetHitDice(oPC);

  if (LvlCarac>20)
  {
     LvlCarac=(LvlCarac-19)/2;
     BAB=BAB-LvlCarac;
  }
  int iAttacks= (BAB - 1) / 5 + 1;
      iAttacks = iAttacks > 4 ? 4 : iAttacks;
  return iAttacks;
}

int GetMightyWeapon(object oWeap)
{
 int iMighty;
 itemproperty ip = GetFirstItemProperty(oWeap);
 while(GetIsItemPropertyValid(ip))
 {
    int iTemp;
    if(GetItemPropertyType(ip) == ITEM_PROPERTY_MIGHTY)
      iTemp = GetItemPropertyCostTableValue(ip);

    iMighty = iTemp > iMighty ? iTemp : iMighty;
    ip = GetNextItemProperty(oWeap);
  }
  return iMighty;
}

int GetRangedWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0,int bCritMult=0)
{
    //Declare in instantiate major variables
    int iType = GetBaseItemType(oWeap);
    int nSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iType));
    int nDice = StringToInt(Get2DAString("baseitems", "NumDice", iType));
    int nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", iType))+bCritMult;
    int nMassiveCrit;
    int bSpec = GetHasFeat(GetFeatByWeaponType(iType, "Specialization"), oPC);
    int bESpec = GetHasFeat(GetFeatByWeaponType(iType, "EpicSpecialization"), oPC);
//    int iDamage = 0;
    int iBonus = 0;


    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iBonus = iStr < 0 ?  iStr : 0 ;
        iStr = iStr > 0 ? iStr : 0 ;
    int iMighty = GetMightyWeapon(oWeap);
        iMighty = iStr>iMighty ? iMighty:iStr;


    object oAmmu;

    switch (iType)
    {
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_HEAVYCROSSBOW:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
        break;
      case BASE_ITEM_SLING:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
        break;
     case BASE_ITEM_SHORTBOW:
     case BASE_ITEM_LONGBOW:
       oAmmu=GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
     case BASE_ITEM_SHURIKEN:
       oAmmu= oWeap;
    }

    int iEnhancement = GetWeaponEnhancement(oAmmu);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;

    //Get Damage Bonus and Massive Critical Properties from oWeap
    itemproperty ip = GetFirstItemProperty(oAmmu);
    while(GetIsItemPropertyValid(ip))
    {
        int tempConst = -1;
        int iCostVal = GetItemPropertyCostTableValue(ip);

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS){
            if(iCostVal > tempConst){
                nMassiveCrit = GetDamageByConstant(iCostVal, TRUE);
                tempConst = iCostVal;
             }
        }

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS){
            iBonus += GetDamageByConstant(iCostVal, TRUE);
        }
        ip = GetNextItemProperty(oAmmu);
    }

    //Roll the base damage dice.
    if(nSides == 2) iDamage += d2(nDice);
    if(nSides == 4) iDamage += d4(nDice);
    if(nSides == 6) iDamage += d6(nDice);
    if(nSides == 8) iDamage += d8(nDice);
    if(nSides == 10) iDamage += d10(nDice);
    if(nSides == 12) iDamage += d12(nDice);


    //Add any applicable bonuses
    if(bSpec) iDamage += 2;
    if(bESpec) iDamage += 4;
    iDamage += iMighty;
    iDamage += iEnhancement;
    iDamage += iBonus;

    //Add critical bonuses
    if(bCrit){
        iDamage *= nCritMult;
        iDamage += nMassiveCrit;
    }

    iDamage =  iDamage<1 ? 1 :iDamage;

    return iDamage;
}

int DoRangedAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0)
{
    //Declare in instantiate major variables
    int iDiceRoll = d20();
    int iBAB = GetBaseAttackBonus(oPC);
    int iAC = GetAC(oTarget);
    int iType = GetBaseItemType(oWeap);
    int iCritThreat = GetMeleeWeaponCriticalRange(oPC, oWeap);
    int bFocus = GetHasFeat(GetFeatByWeaponType(iType, "Focus"), oPC);
    int bEFocus = GetHasFeat(GetFeatByWeaponType(iType, "EpicFocus"), oPC);
    int bProwess = GetHasFeat(FEAT_EPIC_PROWESS, oPC);
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        iDex = iDex > 0 ? iDex:0;

    int iWis = GetAbilityModifier(ABILITY_WISDOM,oPC) && GetHasFeat(FEAT_ZEN_ARCHERY,oPC);
        iDex = iWis>iDex ? iWis:iDex;

    string sFeedback = GetName(oPC) + " attacks " + GetName(oTarget) + ": ";
    int iReturn = 0;

    int RangeWeap=StringToInt(Get2DAString("baseitems", "RangedWeapon", iType));;
    int iBonus;

    object oAmmu= oWeap;
   switch (iType)
   {
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_HEAVYCROSSBOW:
         oAmmu=GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
      break;
    case BASE_ITEM_SLING:
      oAmmu=GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
      break;
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_LONGBOW:
      oAmmu=GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
      break;
   }

   int iEnhancement = GetWeaponEnhancement(oAmmu);
       iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;

    int Distance=FloatToInt(GetDistanceBetween(oPC,oTarget));

    int mRange=Distance/RangeWeap*2;
    int mMelee=GetMeleeAttackers15ft();

    int bPBShot = (mMelee) ? (GetHasFeat(FEAT_POINT_BLANK_SHOT,oPC)? 1:-4):0 ;


    //Add up total attack bonus

        int iAttackBonus = iBAB;
        iAttackBonus += iDex;
        iAttackBonus += bFocus ? 1 : 0;
        iAttackBonus += bEFocus ? 2 : 0;
        iAttackBonus += bProwess ? 1 : 0;
        iAttackBonus += iEnhancement;
        iAttackBonus += iMod;
        iAttackBonus -= mRange;
        iAttackBonus += bPBShot;
        iAttackBonus += iBonus; // Weapon mastery


    //Include ATTACK_BONUS properties from the weapon
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS)
        {
            iAttackBonus += GetItemPropertyCostTableValue(ip);
        }
        ip = GetNextItemProperty(oWeap);
    }





    //Check for a critical threat
    if(iDiceRoll >= iCritThreat && iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*critical hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + "): ";
        //Roll again to see if we scored a critical hit
        iDiceRoll = d20();

        sFeedback += "*threat roll*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        if(iDiceRoll + iAttackBonus > iAC)
            iReturn = 2;
        else
            iReturn = 1;
    }

    //Just a regular hit
    else if(iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 1;
    }

    //Missed
    else
    {
        sFeedback += "*miss*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 0;
    }

    if(bShowFeedback) DelayCommand(fDelay, SendMessageToPC(oPC, sFeedback));
    return iReturn;
}
