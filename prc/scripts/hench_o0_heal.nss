
#include "hench_i0_heal"

void main()
{
    object oHeal = GetLocalObject(OBJECT_SELF, "HealTarget");
    DeleteLocalObject(OBJECT_SELF, "HealTarget");
    SetCommandable(TRUE);
    InitializeItemSpells();
    
    if(HenchTalentCureCondition()) {DelayCommand(2.0, PlayVoiceChat(VOICE_CHAT_CANDO)); return;}
    if(HenchTalentHeal(0, TRUE)) {DelayCommand(2.0, PlayVoiceChat(VOICE_CHAT_CANDO)); return;}
    DelayCommand(2.5, PlayVoiceChat(VOICE_CHAT_CANTDO));
}