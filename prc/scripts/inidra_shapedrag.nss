//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into a Red Dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 20, 2003
#include "heartward_inc"
#include "inc_prc_function"
#include "inc_item_props"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;

    if (!GetHasFeat(FEAT_INIDR_SHAPEDRAGON))
    {
       DeletePRCLocalInts(GetPCSkin(OBJECT_SELF));
       return ;
    }

    int nSpell = GetSpellId();

    if(nSpell == SPELL_SHAPEDRAGONGOLD)
    {
       ePoly = EffectPolymorph(POLY_SHAPEDRAGONGOLD);
    }
    else if (nSpell == SPELL_SHAPEDRAGONRED)
    {
        ePoly = EffectPolymorph(POLY_SHAPEDRAGONRED);
    }
    else if (nSpell == SPELL_SHAPEDRAGONPRYS)
    {
        ePoly = EffectPolymorph(POLY_SHAPEDRAGONPRYS);
    }


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(2));

}
