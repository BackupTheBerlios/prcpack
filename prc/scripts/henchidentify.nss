// This code is by Magic

// Pausanias's modification:
// Add more text feedback to the player.

#include "hench_i0_ident"
#include "hench_i0_strings"


void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetFirstItemInInventory(oPC);
    int nNotId = 0;
    while (GetIsObjectValid(oItem))
    {
        if (!GetIdentified(oItem))
        {
            ++nNotId;
            if (TalentIdentifyItem(oItem))
            {
                SpeakString(sHenchIdentObject + IntToString(nNotId) + sHenchIdentSuccess
                    + GetName(oItem) + ".");
            }
            else
            {
                SpeakString(sHenchIdentObject + IntToString(nNotId) + sHenchIdentFail);
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
    if (nNotId == 0)
    {
        SpeakString(sHenchIdentNoItems);
    }
}

