//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "heartward_inc"
#include "prc_getcast_lvl"

#include "inc_npc"

void ElementalFamiliar()
{

// add
    location loc = GetLocation(OBJECT_SELF);
    vector vloc = GetPositionFromLocation( loc );
    vector vLoc;
    location locSummon;

    vLoc = Vector( vloc.x + (Random(6) - 2.5f),
                       vloc.y + (Random(6) - 2.5f),
                       vloc.z );
        locSummon = Location( GetArea(OBJECT_SELF), vLoc, IntToFloat(Random(361) - 180) );

//
    object oPC = OBJECT_SELF;

    string iType = GetHasFeat(FEAT_BONDED_AIR, OBJECT_SELF)   ? "AIR"  : "" ;
           iType = GetHasFeat(FEAT_BONDED_EARTH, OBJECT_SELF) ? "EARTH"  : iType ;
           iType = GetHasFeat(FEAT_BONDED_FIRE, OBJECT_SELF)  ? "FIRE"  : iType ;
           iType = GetHasFeat(FEAT_BONDED_WATER, OBJECT_SELF) ? "WATER"  : iType ;

    string iSize = GetHasFeat(FEAT_ELE_COMPANION_MED, OBJECT_SELF) ? "MED"  : "" ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_LAR, OBJECT_SELF) ? "LAR"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_HUG, OBJECT_SELF) ? "HUG"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_GRE, OBJECT_SELF) ? "GRE"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_ELD, OBJECT_SELF) ? "ELD"  : iSize ;

    string sRef = "HEN_"+iType+"_"+iSize;

    object oEle = CreateLocalNPC(OBJECT_SELF,ASSOCIATE_TYPE_FAMILIAR,sRef,locSummon,1,"BONDFAMILIAR");

    object oCreB=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oEle);
    object oCreL=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oEle);
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oEle);
    object oHide=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oEle);

    if (iType=="FIRE")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(DAMAGE_TYPE_FIRE,IP_CONST_DAMAGEIMMUNITY_100_PERCENT),oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageVulnerability(DAMAGE_TYPE_COLD,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT),oHide);

        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_1d6),oCreB);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d6),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d6),oCreR);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,2),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
    else if (iType=="WATER")
    {
         if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
 else if (iType=="AIR")
    {

        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,5),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
    else if (iType=="EARTH")
    {

        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }

    int Arcanlvl = GetCasterLvl(TYPE_ARCANE);

    if (Arcanlvl>11)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT,SupernaturalEffect(EffectSpellResistanceIncrease(Arcanlvl+5)),oEle);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IPRP_FEAT_BarbEndurance),oHide);
    }
    else  if (Arcanlvl>8)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT,SupernaturalEffect(EffectSpellResistanceIncrease(Arcanlvl+5)),oEle);
    }

}

void main()
{
    if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
    {
      object oDes=GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR);
      DestroyObject(oDes);
      ElementalFamiliar();
      return;
    }
    //Yep thats it
    SummonFamiliar();

}
