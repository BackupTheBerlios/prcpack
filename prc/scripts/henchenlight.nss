#include "hench_i0_equip"

void main()
{
    SetLocalInt(OBJECT_SELF, "LightOffHand", TRUE);
    ClearWeaponStates();
    HenchEquipAppropriateWeapons(OBJECT_SELF, -5., FALSE);
}
