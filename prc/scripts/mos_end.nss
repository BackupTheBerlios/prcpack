//::///////////////////////////////////////////////
//:: Default: End of Combat Round
//:: NW_C2_DEFAULT3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

// Modified for MoS summoned spirit behavior
// Brian Greinke
// 2004/02/17

#include "NW_I0_GENERIC"
#include "mos_ai"
void main()
{
    object oSummoner = GetLocalObject( OBJECT_SELF, "summoner" );
    int ttl = GetLocalInt( OBJECT_SELF, "ttl" );

    if ( ttl <= 0 ) UnsummonMe();
    else SetLocalInt( OBJECT_SELF, "ttl", ttl-1 );

    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
    {
        DetermineSpecialBehavior();
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
       DetermineCombatRound( DetermineTarget(oSummoner) );
    }
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}