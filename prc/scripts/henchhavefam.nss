#include "inc_npc"
int StartingConditional()
{
    object oAss = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR,GetPCSpeaker());

    if (oAss == OBJECT_INVALID) return FALSE;

    return TRUE;
}
