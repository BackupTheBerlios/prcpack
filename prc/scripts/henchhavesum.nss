#include "inc_npc"
int StartingConditional()
{
    object oAss = GetAssociateNPC(ASSOCIATE_TYPE_SUMMONED,GetPCSpeaker());

    if (oAss == OBJECT_INVALID) return FALSE;

    return TRUE;
}
