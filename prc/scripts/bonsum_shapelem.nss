#include "heartward_inc"
#include "inc_prc_function"
#include "inc_item_props"

void main()
{

    int iType = GetHasFeat(FEAT_BONDED_AIR, OBJECT_SELF)   ? 1 : 0 ;
        iType = GetHasFeat(FEAT_BONDED_EARTH, OBJECT_SELF) ? 2 : iType ;
        iType = GetHasFeat(FEAT_BONDED_FIRE, OBJECT_SELF)  ? 3 : iType ;
        iType = GetHasFeat(FEAT_BONDED_WATER, OBJECT_SELF) ? 4 : iType ;

    if (!GetHasFeat(FEAT_TYPE_ELEMENTAL))
    {
         effect ePoly=GetFirstEffect(OBJECT_SELF);
         while(GetIsEffectValid(ePoly))
         {
            if(GetSpellId()==SPELL_POLYMORPH_ELEM)
               RemoveEffect(OBJECT_SELF, ePoly);

           ePoly = GetNextEffect(OBJECT_SELF);
         }

      DeletePRCLocalInts(GetPCSkin(OBJECT_SELF));

      return ;
    }

    int iPoly;

    if (iType==1)
    {
       iPoly = POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL;
    }
    else if (iType==2)
    {
       iPoly = POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL;
    }
    else if (iType==3)
    {
       iPoly = POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL;
    }
    else if (iType==4)
    {
       iPoly = POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;
    }


    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectPolymorph(iPoly),OBJECT_SELF,HoursToSeconds(10));

}
