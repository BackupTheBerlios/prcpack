//:://////////////////////////////////////////////
//:: HeartBeat (Module)
//:: HD_O0_HeartBeat
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Sample Heartbeat script for randomly firing other scripts
at periodic intervals.  Not used for executing code directly
*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: December 11, 2003
//:://////////////////////////////////////////////

void main()
{

    // Every game hour...
    int nHour = GetTimeHour();
    int nHoursSince = abs(nHour - GetLocalInt(OBJECT_SELF, "nLastHour"));
    if (nHoursSince >= 1)
    {
        // Tri-hourly scripts
        ExecuteScript("hd_o0_trackprog", OBJECT_SELF);

        /////////////////////////////////////////////
        SetLocalInt(OBJECT_SELF, "nLastHour", nHour);
    }

    // Every Game Day
    int nDay = GetCalendarDay();
    int nDaysSince = abs(nDay - GetLocalInt(OBJECT_SELF, "nLastDay"));
    if (nDaysSince >= 1)
    {
        // Daily scripts
        // put daily scripts here..

        ///////////////////////////////////////////
        SetLocalInt(OBJECT_SELF, "nLastDay", nDay);
    }

}

