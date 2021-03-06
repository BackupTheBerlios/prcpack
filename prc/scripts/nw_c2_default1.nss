//::///////////////////////////////////////////////
//:: Default On Heartbeat
//:: NW_C2_DEFAULT1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script will have people perform default
    animations.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
#include "hench_i0_ai"


void main()
{
    DeleteLocalInt(OBJECT_SELF, "AIIntruder");
    DeleteLocalInt(OBJECT_SELF, "AI_CHEAT_CASTING");

    // * if not runnning normal or better AI then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

//    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION,  PERCEPTION_HEARD)))
//    {
//        Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()));
//    }

    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
    {
        if(HenchTalentAdvancedBuff(40.0))
        {
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);
            // TODO evalulate continue with combat
            return;
        }
    }

    if(GetHasEffect(EFFECT_TYPE_SLEEP))
    {
        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
            if(d10() > 6)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            }
        }
    }

    // If we have the 'constant' waypoints flag set, walk to the next
    // waypoint.
    else if(!GetIsObjectValid(GetNearestSeenOrHeardEnemyNotDead(HENCH_MONSTER_DONT_CHECK_HEARD_MONSTER)))
    {
        CleanCombatVars();
        if (GetLocalInt(OBJECT_SELF, "LastSeenOrHeard"))
        {
            MoveToLastSeenOrHeard();
        }
        else if (DoStealthAndWander())
        {
            // nothing to do here    
         }
        // TK sometimes waypoints are not initialized
        else if (!GetWalkCondition(NW_WALK_FLAG_INITIALIZED) || GetWalkCondition(NW_WALK_FLAG_CONSTANT))
        {
            WalkWayPoints();
        }
        else
        {
            if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL) || GetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE) ||
                GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE))
            {
                HenchDetermineSpecialBehavior();
            }
            else if(!IsInConversation(OBJECT_SELF))
            {
                if(GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS) ||
                    GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN) ||
                    GetIsEncounterCreature())
                {
                    PlayMobileAmbientAnimations();
                }
                else if(GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS))
                {
                    PlayImmobileAmbientAnimations();
                }
            }
        }
    }
    else if (GetUseHeartbeatDetect())
    {
//        Jug_Debug(GetName(OBJECT_SELF) + " starting combat round in heartbeat");
        HenchDetermineCombatRound();
    }
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}
