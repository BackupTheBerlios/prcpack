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
    effect eLink = CreateDoomEffectsLink();
    effect eStun = EffectStunned();
    int nLevel = 10;


    //Meta-Magic checks
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOOM));
        //Spell Resistance and Saving throw

        //* GZ Engine fix for mind affecting spell

        int nResult =       WillSave(oTarget, 20, SAVING_THROW_TYPE_MIND_SPELLS);
        if (nResult == 2)
        {
            if (GetIsPC(OBJECT_SELF)) // only display immune feedback for PCs
            {
                FloatingTextStrRefOnCreature(84525, oTarget,FALSE); // * Target Immune
            }
            return;
        }

        nResult = (nResult && MyPRCResistSpell(OBJECT_SELF, oTarget));
        if (!nResult)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(nLevel));
            if ( GetMaxHitPoints( oTarget) < 51)
            {
                int nRoll = d4( 3);
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(nRoll));
            }
            else

                if ( GetMaxHitPoints( oTarget) < 101)
                {
                    int nRoll = d4( 2);
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(nRoll));
                }
                else

                    if ( GetMaxHitPoints( oTarget) < 151)
                    {
                        int nRoll = d4( 1);
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(nRoll));
                    }
        }
    }


// Getting rid of the local integer storing the spellschool name
}
