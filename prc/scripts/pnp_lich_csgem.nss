//::///////////////////////////////////////////////
//:: FileName pnp_lich_csgem
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/24/2004 9:39:35 AM
//:://////////////////////////////////////////////

#include "pnp_lich_inc"

// Crafts the soul gem

void main()
{
    object oPC = GetPCSpeaker();

    // Make sure the PC has enough gold
    if (GetGold(oPC) < 120000)
    {
        FloatingTextStringOnCreature("You do not have enough gold to craft the soul gem", oPC);
        return;
    }
    // Make sure the PC has enough exp so they dont go back a level
    int nHD = GetHitDice(oPC);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = GetXP(oPC) - 4800;
    // -------------------------------------------------------------------------
    // check for sufficient XP to create
    // -------------------------------------------------------------------------
    if (nMinXPForLevel > nNewXP || nNewXP == 0 )
    {
        FloatingTextStrRefOnCreature(3785, oPC); // Item Creation Failed - Not enough XP
        return;
    }
    // Allow the pc to get lich levels
    SetLocalInt(oPC,"PNP_AllowLich", 0);

    // Remove some gold from the player
    TakeGoldFromCreature(120000, oPC, TRUE);

    // Remove some xp from the player
    SetXP(oPC, nNewXP);

    // do some VFX
    CraftVFX(OBJECT_SELF);

    // Soul gem creation code
    object oSoulGem = CreateItemOnObject("soul_gem",oPC);
    itemproperty iProp = ItemPropertyCastSpell(851,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
    AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oSoulGem);

    // Trigger the level up lich check
    DelayCommand(0.1, EvalPRCFeats(oPC));

}
