//Hellfire Grasp by Sir Attilla

//Fixed some run-time errors that caused spell to do nothing
//Aaon Graywolf - Jan 9, 2004
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDamage = d6(1);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
   //Main Spell Body
   int iHit = TouchAttackMelee(oTarget);
   if (iHit > 0)
   {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   }

}
