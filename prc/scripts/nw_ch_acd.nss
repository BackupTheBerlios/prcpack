//::///////////////////////////////////////////////
//:: User Defined Henchmen Script
//:: NW_CH_ACD
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The most complicated script in the game.
    ... ever
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "hench_i0_hensho"

#include "inc_npc"

void main()
{
    int nEvent = GetUserDefinedEventNumber();

    if (nEvent == 20000 + ACTION_MODE_STEALTH)
    {
        if (!GetIsFighting(OBJECT_SELF))
        {
            int bStealth = GetActionMode(GetMasterNPC(), ACTION_MODE_STEALTH);
            RelayModeToAssociates(ACTION_MODE_STEALTH, bStealth);
        }
    }
    else if (nEvent == 20000 + ACTION_MODE_DETECT)
    {
        if (!GetIsFighting(OBJECT_SELF))
        {
            int bDetect = GetActionMode(GetMasterNPC(), ACTION_MODE_DETECT);
            RelayModeToAssociates(ACTION_MODE_DETECT, bDetect);
        }
    }
    // * If a creature has the integer variable X2_L_CREATURE_NEEDS_CONCENTRATION set to TRUE
    // * it may receive this event. It will unsommon the creature immediately
    else if (nEvent == X2_EVENT_CONCENTRATION_BROKEN)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(OBJECT_SELF));
        FloatingTextStrRefOnCreature(84481,GetMasterNPC(OBJECT_SELF));
        DestroyObject(OBJECT_SELF,0.1f);
    }
}
