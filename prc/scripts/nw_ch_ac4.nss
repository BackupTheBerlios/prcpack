//::///////////////////////////////////////////////
//:: Associate: On Dialogue
//:: NW_CH_AC4
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    by the generic script after dialogue or a
    shout is initiated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////

#include "hench_i0_hensho"

#include "inc_npc"

// * This function checks to make sure no
// * dehibilating effects are on the player that should
// * Don't use getcommandable for this since the dying system
// * will sometimes leave a player in a noncommandable state
int AbleToTalk(object oSelf)
{
    if (!GetCommandable(oSelf))
    {
        if (GetHasAnyEffect3(EFFECT_TYPE_CONFUSED, EFFECT_TYPE_DOMINATED,EFFECT_TYPE_PETRIFY, oSelf) ||
            GetHasAnyEffect3(EFFECT_TYPE_PARALYZE, EFFECT_TYPE_STUNNED, EFFECT_TYPE_FRIGHTENED, oSelf))
        {
            return FALSE;
        }
    }
    return TRUE;
}


void main()
{
    object oMaster = GetMasterNPC();
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();

    object oIntruder;
    if (nMatch == -1)
    {
        if(AbleToTalk(OBJECT_SELF) && GetCurrentAction() != ACTION_OPENLOCK)
        {
            ClearAllActions();
            // * if in XP2, use an alternative dialog file
            string sDialog = "";
            if (GetLocalInt(GetModule(), "X2_L_XP2") ==  1)
            {
                sDialog = "x2_associate";
            }
            BeginConversation(sDialog);
        }
    }
    else if(GetIsObjectValid(oShouter) && oMaster == oShouter)
    {
        SetCommandable(TRUE);
        HenchChRespondToShout(oShouter, nMatch, oIntruder);
    }

    // Signal user-defined event
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}

