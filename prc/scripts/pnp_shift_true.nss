#include "pnp_shifter"

void main()
{
    SetShiftTrueForm(OBJECT_SELF);

    // Reset any PRC feats that might have been lost from the shift
    EvalPRCFeats(OBJECT_SELF);
}
