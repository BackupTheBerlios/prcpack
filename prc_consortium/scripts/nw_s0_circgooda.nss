//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"

#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);


    object oTarget = GetEnteringObject();
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //Declare major variables
        int nDuration = (GetCasterLevel(OBJECT_SELF) + GetChangesToCasterLevel(OBJECT_SELF));
        //effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
        effect eLink = CreateProtectionFromAlignmentLink(ALIGNMENT_GOOD);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));

        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
     }
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
