//::///////////////////////////////////////////////
//:: FileName pnp_lich_camulet
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/24/2004 9:58:39 AM
//:://////////////////////////////////////////////
// Craft the lich amulet (create one or upgrade one)

#include "pnp_lich_inc"

void main()
{
    object oPC = GetPCSpeaker();

    // Make sure the PC has enough gold
    if (GetGold(oPC) < 40000)
    {
        FloatingTextStringOnCreature("You do not have enough gold to craft the phlyactery", oPC);
        return;
    }
    // Make sure the PC has enough exp so they dont go back a level
    int nHD = GetHitDice(oPC);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = GetXP(oPC) - 1600;
    // -------------------------------------------------------------------------
    // check for sufficient XP to create
    // -------------------------------------------------------------------------
    if (nMinXPForLevel > nNewXP || nNewXP == 0 )
    {
        FloatingTextStrRefOnCreature(3785, oPC); // Item Creation Failed - Not enough XP
        return;
    }

    object oAmulet = GetItemPossessedBy(oPC,"lichamulet");
    int nAmuletLevel = GetAmuletLevel(oAmulet);
    // Cant upgrade past level 10
    if (nAmuletLevel >= 10)
    {
        FloatingTextStringOnCreature("You can not upgrade your phlyactery anymore", oPC);
        return;
    }


    // Remove some gold from the player
    TakeGoldFromCreature(40000, oPC, TRUE);

    // Remove some xp from the player
    SetXP(oPC, nNewXP);

    // Allow the pc to get lich levels
    SetLocalInt(oPC,"PNP_AllowLich", 0);

    // do some VFX
    CraftVFX(OBJECT_SELF);

    // Create the amulet if they dont have one
    if (!GetIsObjectValid(oAmulet))
    {
        // Give them the level 1 phylactery
        oAmulet = CreateItemOnObject("lichamulet",oPC);
        SetIdentified(oAmulet,TRUE);
        return;
    }
    // Upgrade the amulet if they do
    LevelUpAmulet(oAmulet,nAmuletLevel+1);

    // Trigger the level up lich check
    DelayCommand(0.1, EvalPRCFeats(oPC));
}
