void main()
{

   float iDuration;
   if (GetIsAreaAboveGround(GetAreaFromLocation(GetLocation(OBJECT_SELF)))==AREA_UNDERGROUND)
   {
      iDuration=HoursToSeconds(24);
   }
   else if (GetIsNight())
   {
     int iHour=GetTimeHour();
     iDuration=HoursToSeconds(31-iHour);
   }
   else
   {
    FloatingTextStringOnCreature("only working in the Night", OBJECT_SELF);
    return;

   }

    effect eMiss=EffectConcealment(20);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eMiss),OBJECT_SELF,iDuration);

}
