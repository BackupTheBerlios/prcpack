
#include "inc_npc"

void main()
{

    object oHench = GetHenchmanNPC(GetPCSpeaker());
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oHench);
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oHench);

    SetLocalObject(oHench,"LeftHand",oLeft);
    SetLocalObject(oHench,"RightHand",oRight);
}
