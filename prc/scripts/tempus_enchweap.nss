#include "inc_item_props"
#include "heartward_inc"
#include "x2_inc_itemprop"


void AddIPEnh(object oWeap,int iCost )
{
  int iLvl=GetLevelByClass(CLASS_TYPE_TEMPUS,OBJECT_SELF);
  itemproperty ip;

  if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_ENHANCEMENT_BONUS))
    {
        int iValue;
        ip = GetFirstItemProperty(oWeap);
        int iBreak = FALSE;
        int iNew;

        while (GetIsItemPropertyValid(ip) && !iBreak)
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS )
            {
                iValue = GetItemPropertyCostTableValue(ip);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(iValue + iCost), oWeap,TurnsToSeconds(iLvl));
                iBreak = TRUE;
            }
            ip = GetNextItemProperty(oWeap);
        }
    }
    else
    {
        ip = ItemPropertyEnhancementBonus(iCost);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oWeap,TurnsToSeconds(iLvl));
    }

}


int Activpower(object oWeap,int iType,int iRace,int iLvl,int iVicious)
{

  if (!iType) return iVicious;

  switch (iType)
  {
     case TEMPUS_ABILITY_ENHANC1:
        AddIPEnh(oWeap,1);
       break;
     case TEMPUS_ABILITY_ENHANC2:
        AddIPEnh(oWeap,2);
       break;
     case TEMPUS_ABILITY_ENHANC3:
        AddIPEnh(oWeap,3);
       break;
     case TEMPUS_ABILITY_FIRE1D6:
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_1d6),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_COLD1D6:
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_ELEC1D6:
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_KEEN:
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyKeen(),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_ANARCHIC:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_AXIOMATIC:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_HOLY:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_UNHOLY:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_DISRUPTION:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_SLAYRACE,IP_CONST_ONHIT_SAVEDC_14,IP_CONST_RACIALTYPE_UNDEAD),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_WOUNDING:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_26,IP_CONST_RACIALTYPE_UNDEAD),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_VAMPIRE:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVampiricRegeneration(10),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_VICIOUS:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(iRace,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,TurnsToSeconds(iLvl));
        if (!iVicious)
         AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,2),oWeap,TurnsToSeconds(iLvl));
         iVicious++;
       break;
     case TEMPUS_ABILITY_BARSKIN:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_BARKSKIN_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_CONECOLD:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_9,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_DARKNESS:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_FIREBALL:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_HASTE:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_IMPROVINV:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_LIGHTBOLT:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_MAGICMISSILE:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;
     case TEMPUS_ABILITY_WEB:
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,TurnsToSeconds(iLvl));
       break;


  }

   return iVicious;
}


void main()
{
  object oSkin = GetPCSkin(OBJECT_SELF);
  int iSave=GetLocalInt(OBJECT_SELF,"WeapEchant1");
  object oWeap=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  int iType=GetBaseItemType(oWeap);

  int iLvl=GetLevelByClass(CLASS_TYPE_TEMPUS,OBJECT_SELF);
  int iFeat= iLvl>1 ? FEAT_ENCHANT_WEAPON1:0;
      iFeat= iLvl>5 ? FEAT_ENCHANT_WEAPON2:iFeat;
      iFeat= iLvl>9 ? FEAT_ENCHANT_WEAPON3:iFeat;


  if (!iSave || iType!=GetLocalInt(oSkin,"FEAT_WEAP_TEMPUS") )
    {
      int iPower=(iLvl>1 ) ? 1:0;
      iPower=(iLvl>5 ) ? 2:iPower;
      iPower=(iLvl>9 ) ? 3:iPower;

      DeleteLocalInt(OBJECT_SELF,"WeapEchant1");
      DeleteLocalInt(OBJECT_SELF,"WeapEchant2");
      DeleteLocalInt(OBJECT_SELF,"WeapEchant3");
      DeleteLocalInt(OBJECT_SELF,"WeapEchantRace1");
      DeleteLocalInt(OBJECT_SELF,"WeapEchantRace2");
      DeleteLocalInt(OBJECT_SELF,"WeapEchantRace3");
      SetLocalInt(OBJECT_SELF,"TempusPower",iPower);
      ActionStartConversation(OBJECT_SELF,"cv_tempus");
      IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
      return;
    }

  if (!IPGetWeaponEnhancementBonus(oWeap)|| GetHasSpellEffect(TEMPUS_ENCHANT_WEAPON,oWeap))
  {
      IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
      return;
  }

   int iVicious;
   iVicious=Activpower(oWeap,GetLocalInt(OBJECT_SELF,"WeapEchant1"),GetLocalInt(OBJECT_SELF,"WeapEchantRace1"),iLvl,iVicious);
   iVicious=Activpower(oWeap,GetLocalInt(OBJECT_SELF,"WeapEchant2"),GetLocalInt(OBJECT_SELF,"WeapEchantRace2"),iLvl,iVicious);
   iVicious=Activpower(oWeap,GetLocalInt(OBJECT_SELF,"WeapEchant3"),GetLocalInt(OBJECT_SELF,"WeapEchantRace3"),iLvl,iVicious);

}
