int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();
    int nCasterLevel = GetLocalInt(oPC, "SP_CREATETATOO_LEVEL");
    iResult = nCasterLevel >= 7;
    return iResult;
}
