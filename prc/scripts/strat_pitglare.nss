#include "prc_alterations"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDamage = d6( 16);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
    effect eRay;


        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY));
            eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
            //Apply the VFX impact and effects
            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

        }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);



}
