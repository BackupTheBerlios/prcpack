
#include "pnp_shifter"

void main()
{

    object oTarget = GetSpellTargetObject();
    if (GetValidShift(OBJECT_SELF,oTarget))
    {
        if (!SetShift(OBJECT_SELF,oTarget))
            IncrementRemainingFeatUses(OBJECT_SELF,2900); // only uses a feat if they shift
    else
        RecognizeCreature( OBJECT_SELF, GetResRef(oTarget) );
    }
    else
        IncrementRemainingFeatUses(OBJECT_SELF,2900); // only uses a feat if they shift

}
