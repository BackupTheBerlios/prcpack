#include "hench_i0_equip"

void main()
{
    SetLocalInt(OBJECT_SELF, "DualWieldState", 2);
    ClearWeaponStates();
    HenchEquipAppropriateWeapons(OBJECT_SELF, -5., FALSE);
}

