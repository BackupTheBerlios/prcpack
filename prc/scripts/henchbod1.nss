#include "inc_npc"

int StartingConditional()
{
    int iResult;

    return 1-GetIsObjectValid(GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR));
}
