void main()
{
    object oCaster = OBJECT_SELF;

    /* Archmage feat: Mastery of Elements */
    if(GetLocalInt(oCaster, "archmage_mastery_elements") > 0)
    {
        SetLocalInt(oCaster,"X2_L_LAST_RETVAR", GetLocalInt(oCaster, "archmage_mastery_elements"));
        return;
    }

    SetLocalInt(oCaster,"X2_L_LAST_RETVAR", 0);
}

