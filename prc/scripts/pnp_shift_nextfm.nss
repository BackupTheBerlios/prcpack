//::///////////////////////////////////////////////
//:: FileName pnp_shift_nextfm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 2/22/2004 6:13:10 PM
//:://////////////////////////////////////////////
// Move to the starting point in the list of critters by 10
void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    if ( !GetIsObjectValid(oMimicForms) )
        oMimicForms = CreateItemOnObject( "sparkoflife", oPC );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );

    nStartIndex+=10;
    // Make sure we dont go beyond the end of the list
    if (nStartIndex > num_creatures)
        nStartIndex = 0;
    // Set the variable
    SetLocalInt(oPC, "ShifterListIndex", nStartIndex);

}
