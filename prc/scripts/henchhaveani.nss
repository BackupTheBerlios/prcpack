#include "inc_npc"
int StartingConditional()
{
    object oAss = GetAssociateNPC(ASSOCIATE_TYPE_ANIMALCOMPANION,GetPCSpeaker());

    if (oAss == OBJECT_INVALID) return FALSE;

    return TRUE;
}
