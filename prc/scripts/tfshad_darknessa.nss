//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"

#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    int nMetaMagic = GetMetaMagicFeat();
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);

    int nDuration = GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);

    object oTarget = GetEnteringObject();

    // * July 2003: If has darkness then do not put it on it again
    if (GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) == TRUE)
    {
        return;
    }

    if(GetIsObjectValid(oTarget) && oTarget != GetAreaOfEffectCreator())
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        }
        //Fire cast spell at event for the specified target
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
    else if (oTarget == GetAreaOfEffectCreator())
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        //Fire cast spell at event for the specified target
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
    }

    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD,oTarget);

    if (iShadow)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectUltravision(), oTarget);
    if (iShadow>1)
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectConcealment(20), oTarget);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}



