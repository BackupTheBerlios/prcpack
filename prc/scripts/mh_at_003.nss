//::///////////////////////////////////////////////
//:: FileName mh_at_003
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/02/2004 15:33:49
//:://////////////////////////////////////////////
#include "mh_instr_inc"
void main()
{
    // Donner les objets � la personne qui parle
    object oSpeaker = GetPCSpeaker();
    object oItem = CreateItemOnObject("mh_it_flute", oSpeaker, 1);
    SetIdentified(oItem,TRUE);
    SetLocalObject(oItem, "mh_createur", oSpeaker);
    SetLocalInt(oItem,"cout_instrument",5000);
    //ExecuteScript("mh_ins_sp_script", oSpeaker);
    TakeGoldFromCreature(2500, GetPCSpeaker(), TRUE);
    SetXP(GetPCSpeaker(), GetXP(GetPCSpeaker()) - 200);
    if(!GetLocalInt(oSpeaker,"use_CIMM"))
    {
        ActiveModeCIMM(oSpeaker);
    }
}
