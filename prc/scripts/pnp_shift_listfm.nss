//::///////////////////////////////////////////////
//:: FileName pnp_shift_listfm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 2/22/2004 2:59:44 PM
//:://////////////////////////////////////////////

#include "pnp_shifter"

// We will be setting the custom tokens so the dlg will display
// 10 forms at a time.

void main()
{
    object oPC = GetPCSpeaker();
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    if ( !GetIsObjectValid(oMimicForms) )
        oMimicForms = CreateItemOnObject( "sparkoflife", oPC );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    int i;
    int j = 0;

    //SendMessageToPC(oPC,"sid "+IntToString(nStartIndex)+" num "+IntToString(num_creatures));
    // cycle back to the start
    if (nStartIndex > num_creatures)
        nStartIndex = 0;

    for ( i=nStartIndex; i<nStartIndex+10; i++ )
    {
        SetCustomToken(100+j,GetLocalArrayString( oMimicForms, "shift_choice", i ));
        j++;
        //SendMessageToPC(oPC,GetLocalArrayString( oMimicForms, "shift_choice", i ));
    }


}
