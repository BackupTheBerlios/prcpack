//:://////////////////////////////////////////////
//:: Heartbeat (Item Creation Feat)
//:: HD_G0_HeartBeat
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Poll if crafter is failing the crafting process
This is a 1.0s heartbeat (recursive-delay) on
the player who is presumably not doing anything
other than walking or talking.
*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: December 26, 2003
//:://////////////////////////////////////////////

void main()
{
    // SendMessageToPC(OBJECT_SELF, "3.0s heartbeat has fired");   // DEBUG
    // If caster attacks
    // is attacked...
    if ((GetIsInCombat(OBJECT_SELF)) ||
        // casts a spell...
        (GetAttemptedSpellTarget() != OBJECT_INVALID) ||
        // dies...
        (GetIsDead(OBJECT_SELF)))
        // or wanders away... (check this elsewhere)
        {
            // jump to failure state
            ExecuteScript("hd_g0_killprog", OBJECT_SELF);
            return;
        }
    else
        // Check every 3.0 seconds
        {DelayCommand(3.0, ExecuteScript("hd_g0_heartbeat", OBJECT_SELF));}

}

