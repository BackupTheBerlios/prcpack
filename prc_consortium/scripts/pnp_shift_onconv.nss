#include "pnp_shifter"

void main()
{
    // OnConversation script for listener monster
    int i = 1;  // Start after the Form of phrase
    object oPC = GetLastSpeaker();
    int nMatch = GetListenPatternNumber();

    // Revert to true form
    if(nMatch == 10110)
    {
        if (SetShiftTrueForm(oPC))
            DestroyObject(OBJECT_SELF,2.0); // all done
    }
    else if (nMatch == 10100) // translate a creature string to a resref
    {
        nMatch = GetMatchedSubstringsCount();

        string sCreatureName;
        while(i<nMatch)
        {
            sCreatureName += GetMatchedSubstring(i);
            i++;
        }

        // Force the PC to shift
        if (SetShiftFromTemplateValidate(oPC,GetResRefFromName(sCreatureName)))
            DestroyObject(OBJECT_SELF,2.0);
    }
    else if (nMatch == 10101) // no translations this is a resref
    {
        nMatch = GetMatchedSubstringsCount();

        string sCreatureName;
        while(i<nMatch)
        {
            sCreatureName += GetMatchedSubstring(i);
            i++;
        }

        // Force the PC to shift
        if (SetShiftFromTemplateValidate(oPC,sCreatureName))
            DestroyObject(OBJECT_SELF,2.0);
    }
    else if (nMatch == 10102) // give the shifter some of the powers of the form
    {
        nMatch = GetMatchedSubstringsCount();

        string sCreatureName;
        while(i<nMatch)
        {
            sCreatureName += GetMatchedSubstring(i);
            i++;
        }

        // Force the PC to shift
        if (SetShiftEpicFromTemplateValidate(oPC,GetResRefFromName(sCreatureName)))
            DestroyObject(OBJECT_SELF,2.0);
    }
    else if (nMatch == 10103) // no translations this is a resref
    {
        nMatch = GetMatchedSubstringsCount();

        string sCreatureName;
        while(i<nMatch)
        {
            sCreatureName += GetMatchedSubstring(i);
            i++;
        }

        // Force the PC to shift
        if (SetShiftEpicFromTemplateValidate(oPC,sCreatureName))
            DestroyObject(OBJECT_SELF,2.0);
    }

}
