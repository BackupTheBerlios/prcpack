#include "hench_i0_enhanc"
#include "inc_npc"
void main()
{
    object oAss = GetAssociateNPC(ASSOCIATE_TYPE_SUMMONED,GetPCSpeaker());
    int iBuffed = HenchTalentUseProtectionOthers(oAss);
    if (!iBuffed) iBuffed = HenchTalentEnhanceOthers(oAss,TRUE);
    SetLocalInt(GetPCSpeaker(),"BuffedUp",iBuffed);
}
