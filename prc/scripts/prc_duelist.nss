//::///////////////////////////////////////////////
//:: [Duelist Feats]
//:: [prc_duelist.nss]
//:://////////////////////////////////////////////
//:: Check to see which Duelist feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 20, 2003
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_class_const"
#include "prc_feat_const"


// * Applies the Duelist's AC bonuses as CompositeBonuses on the object's skin.
// * AC bonus is determined by object's int bonus (2x int bonus if epic)
// * iOnOff = TRUE/FALSE
// * iEpic = TRUE/FALSE
void DuelistCannyDefense(object oPC, object oSkin, int iOnOff, int iEpic = FALSE)
{
    int iIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        iIntBonus = iEpic ? iIntBonus * 2 : iIntBonus;

    if(iOnOff){
        SetCompositeBonus(oSkin, "CannyDefenseBonus", iIntBonus, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != TRUE)
            FloatingTextStringOnCreature("Canny Defense On", oPC);
        SetLocalInt(oPC, "CannyDefense", TRUE);
    }
    else {
        SetCompositeBonus(oSkin, "CannyDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != FALSE)
            FloatingTextStringOnCreature("Canny Defense Off", oPC);
        SetLocalInt(oPC, "CannyDefense", FALSE);
   }
}

// * Applies the Duelist's reflex bonuses as CompositeBonuses on the object's skin.
// * iLevel = integer reflex save bonus
void DuelistGrace(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "GraceBonus") == iLevel) return;

    if(iLevel > 0){
        SetCompositeBonus(oSkin, "GraceBonus", iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        if(GetLocalInt(oPC, "Grace") != TRUE)
            FloatingTextStringOnCreature("Grace On", oPC);
        SetLocalInt(oPC, "Grace", TRUE);
    }
    else {
        SetCompositeBonus(oSkin, "GraceBonus", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        if(GetLocalInt(oPC, "Grace") != FALSE)
            FloatingTextStringOnCreature("Grace Off", oPC);
        SetLocalInt(oPC, "Grace", FALSE);
   }
}

// * Applies the Duelist's parry skill bonuses as CompositeBonuses on the object's skin.
// * Bonus is determined by object's Duelist level
void DuelistElaborateParry(object oPC, object oSkin)
{
    int iClassBonus = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);
    if(GetLocalInt(oSkin, "ElaborateParryBonus") == iClassBonus) return;

    SetCompositeBonus(oSkin, "ElaborateParryBonus", iClassBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY);
}

// * Applies the Duelist's damage bonuses on the object's main hand weapon.
// * iPStrkLevel = 1 (1D6), 2 (2D6) or 0 (off)
void DuelistPreciseStrike(object oPC, object oWeap, int iPStrkLevel)
{
    int iDamBonus = 0;

    if(iPStrkLevel == 1) iDamBonus = IP_CONST_DAMAGEBONUS_1d6;
    if(iPStrkLevel == 2) iDamBonus = IP_CONST_DAMAGEBONUS_2d6;

    if(iPStrkLevel > 0){
        if(GetLocalInt(oWeap, "PStrkBonus") != iDamBonus){
            DuelistRemovePreciseStrike(oWeap);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, iDamBonus), oWeap);
            SetLocalInt(oWeap, "PStrkBonus", iDamBonus);
        }

        if(GetLocalInt(oPC, "PreciseStrike") != TRUE)
            FloatingTextStringOnCreature("Precise Strike On", oPC);
        SetLocalInt(oPC, "PreciseStrike", TRUE);
    }
    else {
        //The actual removal of the bonus is handled in the module's unequip script
        //This section simply alerts the player that the bonus has been turned off
        if(GetLocalInt(oPC, "PreciseStrike") != FALSE)
            FloatingTextStringOnCreature("Precise Strike Off", oPC);
        SetLocalInt(oPC, "PreciseStrike", FALSE);
   }
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    //Determine which duelist feats the character has
    int bCanDef = GetHasFeat(FEAT_CANNY_DEFENSE, oPC);
    int bEpicCD = GetHasFeat(FEAT_EPIC_DUELIST, oPC);
    int bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_1d6, oPC) ? 1 : 0;
        bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_2d6, oPC) ? 2 : bPStrk;
    int bGrace  = GetHasFeat(FEAT_GRACE_2, oPC) ? 2 : 0;
        bGrace  = GetHasFeat(FEAT_GRACE_4, oPC) ? 4 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_6, oPC) ? 6 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_8, oPC) ? 8 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_10, oPC) ? 10 : bGrace;
    int bElabPr = GetHasFeat(FEAT_ELABORATE_PARRY, oPC);

    //Apply bonuses accordingly
    if(bCanDef > 0 && GetBaseAC(oArmor) == 0)
        DuelistCannyDefense(oPC, oSkin, TRUE, bEpicCD);
    else
        DuelistCannyDefense(oPC, oSkin, FALSE);

    if(bPStrk > 0 && (GetBaseItemType(oWeapon) == BASE_ITEM_RAPIER || GetBaseItemType(oWeapon) == BASE_ITEM_DAGGER))
        DuelistPreciseStrike(oPC, oWeapon, bPStrk);
    else
        DuelistPreciseStrike(oPC, oWeapon, 0);

    if(bGrace > 0 && GetBaseAC(oArmor) == 0)
        DuelistGrace(oPC, oSkin, bGrace);
    else
        DuelistGrace(oPC, oSkin, 0);

    if(bElabPr > 0) DuelistElaborateParry(oPC, oSkin);

}
