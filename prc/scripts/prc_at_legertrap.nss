//::///////////////////////////////////////////////
//:: Ranged Legerdemain- Disable Trap
//:: prc_at_legertrap.nss
//:://////////////////////////////////////////////
//::
//:: Allows caster to use skills at a range
//:: of up to 30 feet.
//::
//:://///////////////////////////
//:: Created By: James Tallett
//:: Created On: Mar 4, 2004
//::////////////////////////////////////////////////////////////


#include "prc_alterations"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    int nDC;
    object oCaster = OBJECT_SELF;
    object oTrap = GetSpellTargetObject();
    int nType = GetObjectType(oTrap);
    if (OBJECT_TYPE_DOOR == nType || OBJECT_TYPE_PLACEABLE == nType || OBJECT_TYPE_TRIGGER == nType)
    {
    if (GetDistanceToObject(oTrap) <= 30.0)
        {
        nDC = GetTrapDisarmDC(oTrap);
        nDC = nDC + 5;
        if (GetIsSkillSuccessful(oCaster, SKILL_DISABLE_TRAP, nDC))
            {
            SetTrapDisabled(oTrap);
            }

        }
    }



}
