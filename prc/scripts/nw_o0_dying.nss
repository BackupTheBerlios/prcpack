//::///////////////////////////////////////////////
//:: Dying Script
//:: NW_O0_DEATH.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script handles the default behavior
    that occurs when a player is dying.
    DEFAULT CAMPAIGN: player dies automatically
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: November 6, 2001
//:://////////////////////////////////////////////
#include "heartward_inc"
#include "x0_i0_position"
#include "NW_I0_GENERIC"

void main()
{
/*    AssignCommand(GetLastPlayerDying(), ClearAllActions());
    AssignCommand(GetLastPlayerDying(),SpeakString( "I Dying"));
    PopUpGUIPanel(GetLastPlayerDying(),GUI_PANEL_PLAYER_DEATH);
*/
// * April 14 2002: Hiding the death part from player

    object oDying =GetLastPlayerDying();

    if (GetHasFeat(FEAT_SHADOWDISCOPOR, oDying) &&
     ( GetIsAreaAboveGround(GetArea(OBJECT_SELF))==AREA_UNDERGROUND || GetIsNight()|| GetHasEffect(EFFECT_TYPE_DARKNESS)) )
    {
     int iDice=d20();

     if (iDice+GetReflexSavingThrow(oDying)>=5+GetLocalInt(oDying,"DmgDealt"))
     {
       string sFeedback = "*Reflex Save vs Death : *success* :(" + IntToString(iDice) + " + " + IntToString(GetReflexSavingThrow(oDying)) + " = " + IntToString(iDice+GetReflexSavingThrow(oDying)) + " vs. DD:"+ IntToString(5+GetLocalInt(oDying,"DmgDealt"))+")";
       FloatingTextStringOnCreature(sFeedback, oDying);

        location locJump=GetRandomLocation(GetArea(OBJECT_SELF), oDying, 30.0f);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oDying);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1 - (GetCurrentHitPoints(oDying))), oDying);
       SignalEvent(oDying,EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
       AssignCommand(oDying,ClearAllActions());
       AssignCommand(oDying,ActionJumpToLocation(locJump));
       return;

     }
        string sFeedback = "*Reflex Save vs Death : *failed* :(" + IntToString(iDice) + " + " + IntToString(GetReflexSavingThrow(oDying)) + " = " + IntToString(iDice+GetReflexSavingThrow(oDying)) + " vs. DD:"+ IntToString(5+GetLocalInt(oDying,"DmgDealt"))+")";
        FloatingTextStringOnCreature(sFeedback, oDying);

   }

    effect eDeath = EffectDeath(FALSE, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, GetLastPlayerDying());
}