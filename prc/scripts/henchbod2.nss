#include "inc_npc"

int StartingConditional()
{
    int iResult;

    return GetIsObjectValid(GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR));
}
