void main()
{
    // Spawn in shifter listener

    // Make it perm invis
    effect eInv = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    SupernaturalEffect(eInv);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInv,OBJECT_SELF);

    // Listen for messages from the shifter
    SetListening(OBJECT_SELF,TRUE);
    // the ** will be the name of the creature to become
    SetListenPattern(OBJECT_SELF,"Form of **",10100);
    // the ** will be the name of the creature to become
    // this is for a resref name, no translation of the string
    SetListenPattern(OBJECT_SELF,"resref Form of **",10101);
}
