//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_level
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Completes the level up process by checking the amulet level vs the hide level
// vs the lich level.

// Called by the EvalPRC function

#include "pnp_lich_inc"
#include "NW_I0_GENERIC"


void LichLevelUpVFX(object oPC)
{
    // make some fancy fireworks for when the lich levels up
    // VFX for the increase of powers
    effect eFx = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
    eFx = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
    eFx = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
}

void main()
{
    // being called by EvalPRCFeats
    object oPC = OBJECT_SELF;
    int nLichLevel = GetLevelByClass(CLASS_TYPE_LICH,oPC);

    // If they are polymorphed dont run this code
    // this should fix the HOTU sensi amulet bug
    if (GetHasEffect(EFFECT_TYPE_POLYMORPH,oPC))
        return;


    //************************************************
    // Lich items
    // The amulet is the phlycatery that is required to become a lich
    object oAmulet = GetItemPossessedBy(oPC,"lichamulet");
    int nAmuletLevel = GetAmuletLevel(oAmulet);
    //SendMessageToPC(oPC,"amulet level = " + IntToString(nAmuletLevel));

    object oHide = GetPCSkin(oPC);
    int nHideLevel = GetHideLevel(oHide);
    //SendMessageToPC(oPC,"hide level = " + IntToString(nHideLevel));
    //debug code to inspect the hide props
    //CopyItem(oHide,oPC,TRUE);

    // Find the number of soul gems on the lich
    int nNumSoulGems = 0;
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetResRef(oItem) == "soul_gem")
            nNumSoulGems++;
        oItem = GetNextItemInInventory(GetFirstPC());
    }
    //SendMessageToPC(oPC,"num soul gems = " + IntToString(nNumSoulGems));
    // Lich items
    //************************************************

    // Evalutation EVENT Hook.
    // Check to see if they have the amulet, find out what level it is,
    // and adjust the hide to match the amulet level.  If they loose the amulet
    // they need to do everything all over from scratch.
    // Make sure they dont get a hide above the lich level
    effect eFx;

    switch(nLichLevel)
    {
        case 0:
            return;
        case 1:
        case 2:
        case 3:
            if ((nAmuletLevel >= nLichLevel) && (nHideLevel < nLichLevel))
            {
                LevelUpHide(oPC, oHide, nLichLevel);
                LichLevelUpVFX(oPC);
                return;
            }
            else
            { // indicate the problem
                if (nAmuletLevel < nLichLevel)
                {
                    FloatingTextStringOnCreature("You need to upgrade your phylactery in order to gain more lich powers",oPC);
                    // make sure we give them the highest hide they can get
                    if (nHideLevel < nAmuletLevel)
                        LevelUpHide(oPC, oHide, nAmuletLevel);
                }
                return;
            }
            break;
        case 4:
            if ((nAmuletLevel >= nLichLevel) && (nHideLevel < nLichLevel))
            {
                LevelUpHide(oPC, oHide, nLichLevel);
                // they are now a full lich, make them look like one
                LichLevelUpVFX(oPC);
                SetCreatureAppearanceType(oPC,APPEARANCE_TYPE_LICH);
                return;
            }
            else
            { // indicate the problem
                if (nAmuletLevel < nLichLevel)
                {
                    FloatingTextStringOnCreature("You need to upgrade your phylactery in order to gain more lich powers",oPC);
                    // make sure we give them the highest hide they can get
                    if (nHideLevel < nAmuletLevel)
                        LevelUpHide(oPC, oHide, nAmuletLevel);
                }
                return;
            }
            break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            // for the demilich levels we need soul gems
            if ((nAmuletLevel >= nLichLevel) && (nHideLevel < nLichLevel) && (nNumSoulGems >= (nLichLevel-4)))
            {
                LevelUpHide(oPC, oHide, nLichLevel);
                LichLevelUpVFX(oPC);
                return;
            }
            else
            { // indicate the problem
                if (nAmuletLevel < nLichLevel)
                    FloatingTextStringOnCreature("You need to upgrade your phylactery in order to gain more lich powers",oPC);
                if (nNumSoulGems < nLichLevel-4)
                    FloatingTextStringOnCreature("You need to make more soul gems in order to gain more lich powers",oPC);

                // Determine what hide they should get
                int nLowestHideLevel = nLichLevel;
                if (nAmuletLevel < nLowestHideLevel)
                    nLowestHideLevel = nAmuletLevel;
                if (nNumSoulGems+4 < nLowestHideLevel)
                    nLowestHideLevel = nNumSoulGems+4;
                if (nHideLevel < nLowestHideLevel)
                    LevelUpHide(oPC, oHide, nLowestHideLevel);
            }
            break;
        case 10:
            // at 10th level we need 8 gems
            if ((nAmuletLevel >= nLichLevel) && (nNumSoulGems >= 8) && (nHideLevel < nLichLevel))
            {
                LevelUpHide(oPC, oHide, nLichLevel);
                LichLevelUpVFX(oPC);
                eFx = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,oPC);
                SetCreatureAppearanceType(oPC,430);
            }
            else
            { // indicate the problem
                if (nAmuletLevel < nLichLevel)
                    FloatingTextStringOnCreature("You need to upgrade your phylactery in order to gain more lich powers",oPC);
                if (nNumSoulGems < 8)
                    FloatingTextStringOnCreature("You need 8 soul gems in order to gain more lich powers",oPC);
                // Determine what hide they should get
                int nLowestHideLevel = nLichLevel;
                if (nAmuletLevel < nLowestHideLevel)
                    nLowestHideLevel = nAmuletLevel;
                if (nNumSoulGems+4 < nLowestHideLevel)
                    nLowestHideLevel = nNumSoulGems+4;
                // they need 8 gems at 10 so.. need to plug up this hole
                if (nLowestHideLevel >= 10)
                    nLowestHideLevel = 9;
                if (nHideLevel < nLowestHideLevel)
                    LevelUpHide(oPC, oHide, nLowestHideLevel);
            }
            break;
    }
    return;
}
