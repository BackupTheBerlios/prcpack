//:://////////////////////////////////////////////
//:: TrackProg (Item Creation Feats - PC)
//:: HD_G0_TrackProg
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Run every game hour (by default: 2 real minutes)
*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: December 11, 2003
//:://////////////////////////////////////////////

#include "HD_I0_ITEMCREAT"

int TimeToLog()
{
    int nDay = GetCalendarDay();
    int nDaysSince = abs(nDay - GetLocalInt(GetModule(), "nLastDay"));
    int nLogProcess = FALSE;
    if (nDaysSince >= 1)
    {
        nLogProcess = TRUE;
        SetLocalInt(OBJECT_SELF, "nLastDay", nDay);
    }
    return nLogProcess;
}

int IsMultiplayer()
    {return GetLocalInt(GetModule(), "nIsMultiplayer");}

void SetICHoursInDayCycle(int nHours=1)
    {
        SetLocalInt(GetModule(), "nICHoursInDayCycle", nHours);
        string sMessage = GetPCPlayerName(OBJECT_SELF) + " has set " + IntToString(nHours) + " HoursInDayCycle for Item Creation";
        WriteTimestampedLogEntry(sMessage);
        SendMessageToAllDMs(sMessage);
    }

int GetICHoursInDayCycle()
    {
        int nHoursInDayCycle = GetLocalInt(GetModule(), "nICHoursInDayCycle");
        if (nHoursInDayCycle > 0)
            {return nHoursInDayCycle;}
        else
            {SetICHoursInDayCycle(1); return 1;}
    }

void SetICMinDays(float fMinDays=0.1)
    {
        SetLocalFloat(GetModule(), "fICMinDays", fMinDays);
        string sMessage = GetPCPlayerName(OBJECT_SELF) + " has set " + FloatToString(fMinDays) + " MinDays for Item Creation";
        WriteTimestampedLogEntry(sMessage);
        SendMessageToAllDMs(sMessage);
    }

void SetICMaxDays(float fMaxDays=0.2)
    {
        SetLocalFloat(GetModule(), "fICMaxDays", fMaxDays);
        string sMessage = GetPCPlayerName(OBJECT_SELF) + " has set " + FloatToString(fMaxDays) + " MaxDays for Item Creation";
        WriteTimestampedLogEntry(sMessage);
        SendMessageToAllDMs(sMessage);
    }

float GetICMinDays()
    {
        float fICMinDays = GetLocalFloat(GetModule(), "fICMinDays");
        if (fICMinDays > 0.0)
            {return fICMinDays;}
        else
            {SetICMinDays(0.1); return 0.1;}
    }

float GetICMaxDays()
    {
        float fICMaxDays = GetLocalFloat(GetModule(), "fICMaxDays");
        if (fICMaxDays > 0.0)
            {return fICMaxDays;}
        else
            {SetICMaxDays(0.2); return 0.2;}
    }


// Create the Item from the resref and set it IDed.
// Play musical fanfare yay~..

void FinishItem(string sItemResRef)
{
    object oResult;
    string sCompleted, sCreating, sCreated;
    sCompleted = GetName(OBJECT_SELF) + " has completed progress on " + sItemResRef;
    WriteTimestampedLogEntry(sCompleted);
    SendMessageToAllDMs(sCompleted);
    sCreating = "Attempting to create " + sItemResRef + " on " + GetName(OBJECT_SELF);
    WriteTimestampedLogEntry(sCreating);
    if (GetIsObjectValid(oResult = CreateItemOnObject(sItemResRef)))
        {
            WriteTimestampedLogEntry(sCreated = GetName(oResult) + " (" + sItemResRef + ", " + IntToString(GetGoldPieceValue(oResult)) + "gp) " + "successfully created on " + GetName(OBJECT_SELF));
            SetIdentified(oResult, TRUE);
            SendMessageToAllDMs(sCreated);
            sCreated = GetName(GetItemPossessor(oResult)) + " has the newly created " + GetName(oResult);
            WriteTimestampedLogEntry(sCreated);
            SendMessageToAllDMs(sCreated);
            if (GetBaseItemType(oResult) == BASE_ITEM_RING)
                {FloatingTextStringOnCreature("You have forged a " + GetName(oResult) + ".", OBJECT_SELF, FALSE);}
            else
                {FloatingTextStringOnCreature("You have crafted a " + GetName(oResult) + ".", OBJECT_SELF, FALSE);}
            PlaySound("gui_quest_done");
        }
}



void main()
{
    // If we are on a multiplayer server and a game day has turned, log everyone's progress to db.

    /* TrackProgress
    We check all PCs for ongoing item creation processes and if they have it,
    log their progress.  We then run a check to see if the progress was
    completed.
    */

    // SendMessageToPC(OBJECT_SELF, "hd_g0_trackprog has fired");
    struct itemcreationprocess pProcess = GetLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS");
    // Calculated DiffDays between CurrentTime and LastTime.


    // If CurrentTime dy/hr have progressed since LastTime, calculate DiffHours

    // Get the current HoursInDayCycle
    // This will depend on how this configuration is stored and where.
    // Get the last tangibly recorded timestamp.
    int nLastTimeStamp = pProcess.lasttimestamp;
    int nCurrentTimeStamp = GetTimeHour();
    // SendMessageToPC(OBJECT_SELF, "nLastTimeStamp Hour: " + IntToString(nLastTimeStamp));
    // SendMessageToPC(OBJECT_SELF, "nCurrentTimeStamp Hour: " + IntToString(nCurrentTimeStamp));

    // Count number of game hours since last time
    int nDiffHours = abs(nCurrentTimeStamp - nLastTimeStamp);
    // This calculation needs to handle the midnight turnover transition properly..
    // SendMessageToPC(OBJECT_SELF, "nDiffHours: " + IntToString(nDiffHours));


    // If CurrentTime dy/hr have not changed, nDiffHours is 0, do nothing.
    if (nDiffHours > 0)
        {
            // Convert to DiffDays using whatever the current HoursInDayCycle is.
            float fDiffDays = IntToFloat(nDiffHours) / IntToFloat(GetICHoursInDayCycle());
            // SendMessageToPC(OBJECT_SELF, "HoursInDayCycle: " + IntToString(GetICHoursInDayCycle()));

            // Add DiffDays to CompletedDays.
            float fCompletedDays = pProcess.completeddays;
            fCompletedDays = fCompletedDays + fDiffDays;
            // SendMessageToPC(OBJECT_SELF, "fDiffDays: " + FloatToString(fDiffDays));
            // SendMessageToPC(OBJECT_SELF, "fCompletedDays: " + FloatToString(fCompletedDays));

            /*
            Progress is completed if fCompletedDays is greater than fDaysNeeded where
            nDaysNeeded is MarketPrice/1000 (with minimum of MinDays, and a max of MaxDays)
            */
            float fDaysNeeded = IntToFloat(pProcess.marketprice) / 1000.0;
            // SendMessageToPC(OBJECT_SELF, "fDaysNeeded: " + FloatToString(fDaysNeeded));
            float fMinDays = GetICMinDays();
            float fMaxDays = GetICMaxDays();
            // SendMessageToPC(OBJECT_SELF, "fICMinDays: " + FloatToString(fMinDays));
            // SendMessageToPC(OBJECT_SELF, "fICMaxDays: " + FloatToString(fMaxDays));
            if (fDaysNeeded < fMinDays)
                {fDaysNeeded = fMinDays;}

            if (fDaysNeeded > fMaxDays)
                {fDaysNeeded = fMaxDays;}

            if (fCompletedDays >= fDaysNeeded)
                {
                    string sResultResRef = pProcess.result;
                    // Clear all the process variables.
                    DeleteLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS");
                    // Run the item creation routine/script.
                    FinishItem(sResultResRef);
                }
            // If progress not completed,
            // then reset local
            // if Time to Log is true and this is multiplayer
            else
                {
                    // Log the new Completed Days on the crafter.
                    pProcess.completeddays = fCompletedDays;

                    // CurrentTimeStamp becomes LastTimeStamp for the next check cycle;
                    pProcess.lasttimestamp = nCurrentTimeStamp;
                    SetLocalItemCreationProcess(OBJECT_SELF, "HD_ICPROCESS", pProcess);

                    string sTemp = FloatToString(fDaysNeeded - fCompletedDays);
                    sTemp = GetSubString(sTemp, 0, GetStringLength(sTemp) - 7);
                    FloatingTextStringOnCreature(sTemp + " days left...", OBJECT_SELF, FALSE);

                    if (TimeToLog() && IsMultiplayer())
                        {

                        }
                }
        }
}
