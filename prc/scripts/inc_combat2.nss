#include "inc_combat"


// Get Bonus Mighty
int GetMightyWeapon(object oWeap);

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

