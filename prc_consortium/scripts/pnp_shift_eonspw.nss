void main()
{
    // Spawn in shifter listener

    // Make it perm invis
    effect eInv = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    SupernaturalEffect(eInv);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInv,OBJECT_SELF);

    // Listen for messages from the shifter
    SetListening(OBJECT_SELF,TRUE);
    SetListenPattern(OBJECT_SELF,"Epic Form of **",10102);
    // this is for a resref Epic form, works just like form of does
    SetListenPattern(OBJECT_SELF,"resref Epic Form of **",10103);
}
