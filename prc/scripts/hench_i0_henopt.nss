/*

this file is used for options for the henchman ai
the exe and hak versions are different than the erf version
the exe and hak version still use the small scripts to control options
the erf version can just be built directly using this file without using
    the small control files, it can be changed to anything including
    module properties, spawn script, etc.

*/





const int HENCH_HENAI_NOATTACK  = 0x0001;      // associates dont attack master on damage
const int HENCH_HENAI_INVENTORY = 0x0002;     // PC can use inventory on associates

const float fHenchHearingDistance = 5.0;
const float fHenchMasterHearingDistance = 100.0;


int GetHenchmanOptions(int nSel)
{
    int nReturn;
    if (nSel & HENCH_HENAI_NOATTACK)
    {
            // associates dont attack master on damage
        DeleteLocalInt(OBJECT_SELF, "HenchOptionReturn");
        ExecuteScript("henchdontattack", OBJECT_SELF);
        nReturn = nReturn | (GetLocalInt(OBJECT_SELF, "HenchOptionReturn") & HENCH_HENAI_NOATTACK);
    }
    if (nSel & HENCH_HENAI_INVENTORY)
    {
            // associates dont attack master on damage
        DeleteLocalInt(OBJECT_SELF, "HenchOptionReturn");
        ExecuteScript("henchallowinv", OBJECT_SELF);
        nReturn = nReturn | (GetLocalInt(OBJECT_SELF, "HenchOptionReturn") & HENCH_HENAI_INVENTORY);
    }
    DeleteLocalInt(OBJECT_SELF, "HenchOptionReturn");
    return nReturn;
}


// TK TODO move to a 2da?
void HenchBattleCry()
{
    string sName = GetName(OBJECT_SELF);
    // Probability of Battle Cry. MUST be a number from 1 to at least 8
    int iSpeakProb = Random(125)+1;
    if (FindSubString(sName,"Sharw") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Take this, fool!"); break;
       case 2: SpeakString("Spare me your song and dance!"); break;
       case 3: SpeakString("To hell with you, hideous fiend!"); break;
       case 4: SpeakString("Come here. Come here I say!"); break;
       case 5: SpeakString("How dare you, impetuous beast?"); break;
       case 6: SpeakString("Pleased to meet you!"); break;
       case 7: SpeakString("Fantastic. Just fantastic!"); break;
       case 8: SpeakString("You CAN do better than this, can you not?"); break;

       default: break;
    }

    if (FindSubString(sName,"Tomi") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Tomi's got a little present for you here!"); break;
       case 2: SpeakString("Poor sod, soon to bite the earth!"); break;
       case 3: SpeakString("Think twice before messing with Tomi!"); break;
       case 4: SpeakString("Tomi's fast; YOU are slow!"); break;
       case 5: SpeakString("Your momma raised ya to become THIS?"); break;
       case 6: SpeakString("Hey! Where's your manners!"); break;
       case 7: SpeakString("Tomi's got a BIG problem with you. Scram!"); break;
       case 8: SpeakString("You're an ugly little beastie, ain't ya?"); break;

       default: break;
    }

    if (FindSubString(sName,"Grim") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Destruction for all!"); break;
       case 2: SpeakString("Embrace Death, and long for it!"); break;
       case 3: SpeakString("My Silent Lord comes to take you!"); break;
       case 4: SpeakString("Be still: your End approaches."); break;
       case 5: SpeakString("Prepare yourself! Your time is near!"); break;
       case 6: SpeakString("Eternal Silence engulfs you!"); break;
       case 7: SpeakString("I am at one with my End. And you?"); break;
       case 8: SpeakString("Suffering ends; but Death is eternal!"); break;
       default: break;
    }

    if (FindSubString(sName,"Dael") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("I'd spare you if you would only desist."); break;
       case 2: SpeakString("It needn't end like this. Leave us be!"); break;
       case 3: SpeakString("You attack us, only to die. Why?"); break;
       case 4: SpeakString("Must you all chase destruction? Very well!"); break;
       case 5: SpeakString("It does not please me to crush you like this."); break;
       case 6: SpeakString("Do not provoke me!"); break;
       case 7: SpeakString("I am at my wit's end with you all!"); break;
       case 8: SpeakString("Do you even know what you face?"); break;
       default: break;
    }

    if (FindSubString(sName,"Linu") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Oooops! I nearly fell!"); break;
       case 2: SpeakString("What is your grievance? Begone!"); break;
       case 3: SpeakString("I won't allow you to harm anyone else!"); break;
       case 4: SpeakString("Retreat or feel Sehanine's wrath!"); break;
       case 5: SpeakString("By Sehanine Moonbow, you will not pass unchecked."); break;
       case 6: SpeakString("Smite you I will, though unwillingly."); break;
       case 7: SpeakString("Sehanine willing, you'll soon be undone!"); break;
       case 8: SpeakString("Have you no shame? Then suffer!"); break;
       default: break;
    }

    if (FindSubString(sName,"Boddy") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("You face a sorcerer of considerable power!"); break;
       case 2: SpeakString("I find your resistance illogical."); break;
       case 3: SpeakString("I bind the powers of the very Planes!"); break;
       case 4: SpeakString("Fighting for now, and research for later."); break;
       case 5: SpeakString("Sad to destroy a fine specimen such as yourself."); break;
       case 6: SpeakString("Your chances of success are quite low, you know?"); break;
       case 7: SpeakString("It's hard to argue with these fools."); break;
       case 8: SpeakString("Now you are making me lose my patience."); break;
       default: break;
    }
}


