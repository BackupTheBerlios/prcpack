#include "heartward_inc"
#include "inc_item_props"
#include "Soul_inc"

int FindUnarmedDmgGlove(object oPC,int bUnarmedDmg)
{

  int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);
      iMonk = (iMonk >20) ? 20 :iMonk ;

  int iSize =GetCreatureSize(oPC);

  int iDmg = 1;
  int iLvDmg;

  if (iMonk)
  {
    int iLvDmg = iMonk/4+2;

    if (iLvDmg == 6 && bUnarmedDmg == 0) return -2 ;

    if (iSize == CREATURE_SIZE_SMALL ||iSize== CREATURE_SIZE_TINY)
      iLvDmg--;

    iDmg =iLvDmg ;

  }

  if (!bUnarmedDmg) return -1;

  if (bUnarmedDmg == 1)
    return  IP_CONST_DAMAGEBONUS_2;

   return IP_CONST_DAMAGEBONUS_4;
}

void SetLocalsancty2(object oPC)
{
     object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     int iType= GetBaseItemType(oItem);

     if (GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE))
         return;

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

     if (Sanctify_Feat(iType) &&  !GetLocalInt(oItem,"SanctMar"))
     {
       SetLocalInt(oItem,"SanctMar",1);
     }
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     if (Sanctify_Feat(iType) &&  !GetLocalInt(oItem,"SanctMar"))
     {
        SetLocalInt(oItem,"SanctMar",1);
     }

}


void SetLocalFistRaziel(object oPC)
{
    object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    int iType= GetBaseItemType(oItem);

     switch (iType)
     {
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_ARROW:
          iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
          break;
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
          break;
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
          oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
          break;
        case BASE_ITEM_SLING:
          oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
          break;
     }

      SetLocalInt(oItem,"MartialStrik",1);

     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     iType= GetBaseItemType(oItem);
     SetLocalInt(oItem,"MartialStrik",1);


}

void SetLocalIniDra(object oPC)
{
   object oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);

   int Enh =  GetHasFeat(FEAT_CLAWDRAGON,oPC) ? 1: 0;
       Enh =  GetHasFeat(FEAT_CLAWENH2,oPC)   ? 2: Enh;
       Enh =  GetHasFeat(FEAT_CLAWENH3,oPC)   ? 3: Enh;

   int UnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE1,oPC) ? 1:0;
       UnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE2,oPC) ? 2:UnarmedDmg;

   int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);

   int iKi = GetHasFeat(FEAT_KI_STRIKE,oPC) ? 1 : 0 ;
       iKi = (iMonk>12)                     ? 2 : iKi;
       iKi = (iMonk>15)                     ? 3 : iKi;

   int iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4,oPC) ? 1 : 0 ;
       iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5,oPC) ? 2 : iEpicKi ;

   iKi+= iEpicKi;

   int iDmgGlove =FindUnarmedDmgGlove(oPC,UnarmedDmg);

   if (GetHasFeat(FEAT_INIDR_STUNSTRIKE,oPC) && !GetLocalInt(oItem,"IniStunStrk"))
          SetLocalInt(oItem,"IniStunStrk",1);

   SetLocalInt(oItem,"IniClaw",iDmgGlove);
   SetLocalInt(oItem,"IniEnh",Enh+iKi);

}

void SetLocalStormlord(object oPC)
{
   object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

   if (GetBaseItemType(oItem)!=BASE_ITEM_SHORTSPEAR) return;
   if (GetLocalInt(oItem,"STShock")) return;

   if (GetHasFeat(FEAT_SHOCK_WEAPON,oPC)) SetLocalInt(oItem,"STShock",1);
   if (GetHasFeat(FEAT_THUNDER_WEAPON,oPC)) SetLocalInt(oItem,"STThund",1);
}



void main()
{
   object oPC=OBJECT_SELF;

   if (GetLevelByClass(CLASS_TYPE_STORMLORD,oPC)) SetLocalStormlord(oPC);
   SetLocalsancty2(oPC);
   if (GetLevelByClass(CLASS_TYPE_FISTRAZIEL,oPC)>9) SetLocalFistRaziel(oPC);
   if (GetHasFeat(FEAT_SHADOWDISCOPOR, oPC)) {SetLocalInt(GetItemInSlot(INVENTORY_SLOT_CHEST,oPC),"ShaDiscorp",1);}
   if (GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC,oPC)) SetLocalIniDra(oPC);
}