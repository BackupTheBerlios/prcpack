//::///////////////////////////////////////////////////
//:: X0_D2_HEN_DEFND
//:: TRUE if henchman is currently in "Defend Master"
//:: mode.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/24/2003
//::///////////////////////////////////////////////////

#include "x0_i0_assoc"
#include "inc_npc"

int StartingConditional()
{
    return GetAssociateStateNPC(NW_ASC_MODE_DEFEND_MASTER);
}
