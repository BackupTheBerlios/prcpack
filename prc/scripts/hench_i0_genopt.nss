/*

this file is used for options for the henchman ai
the exe and hak versions are different than the erf version
the exe and hak version still use the small scripts to control options
the erf version can just be built directly using this file without using
    the small control files, it can be changed to anything including
    module properties, spawn script, etc.

*/





const int HENCH_GENAI_SOUINSTALLED  = 0x0001;      // associates dont attack master on damage
const int HENCH_GENAI_ENABLEHEARING = 0x0002;     // PC can use inventory on associates


int GetGeneralOptions(int nSel)
{
    int nReturn;
    if (nSel & HENCH_GENAI_SOUINSTALLED)
    {
        DeleteLocalInt(OBJECT_SELF, "HenchOptionReturn");
        ExecuteScript("henchhearing", OBJECT_SELF);
        nReturn = nReturn | (GetLocalInt(OBJECT_SELF, "HenchOptionReturn") & HENCH_GENAI_SOUINSTALLED);
    }
    if (nSel & HENCH_GENAI_ENABLEHEARING)
    {
            // associates dont attack master on damage
        DeleteLocalInt(OBJECT_SELF, "HenchOptionReturn");
        ExecuteScript("henchsouinst", OBJECT_SELF);
        nReturn = nReturn | (GetLocalInt(OBJECT_SELF, "HenchOptionReturn") & HENCH_GENAI_ENABLEHEARING);
    }
    DeleteLocalInt(OBJECT_SELF, "HenchOptionReturn");
    return nReturn;
}
