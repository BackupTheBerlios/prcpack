#include "x2_inc_switches"
#include "inc_prc_function"


//does everything myResistSPell does, only it adjusts for +1 ECL
// uses spell script: "add_spell_penetr" , also any changes made to "prc_caster_level" will affect
// it the same way as they affect the GetChangesToCasterLevel function.
int MyPRCResistSpell(object oCaster, object oTarget, float fDelay = 0.0);


// Scraped - because it turned out not to be quite versatile enough.
//effect PRCElementalDamage(object oCaster, int nDamage, int nType, int nDamagePower = DAMAGE_POWER_NORMAL);


// returns amount added to Caster Level to allow adjustments for +1 ECL
// uses spell script: "prc_caster_level"
int GetChangesToCasterLevel(object oCaster);

// returns any additional changes to spell save DC you want included other
// than the basic 10 + spell level + attribute + feats
// uses spell script:  "add_spell_dc"
int GetChangesToSaveDC(object oCaster);

// returns alternate damage type for spells that do area of effect, or damage sheilds.
// uses script: "set_damage_type"
int ChangedElementalDamage(object oCaster, int nDamageType);



// does SR checks.   Runs ExecuteScriptAndReturnInt() twice,  once to get adjusted PRC caster level
// and a second time to get any random spell penetration bonuses or to exclude certain targets from
// taking damage.   The caster level script is called "prc_caster_level" and  the other is "add_spell_penetr"

// I think the code for it was much more readable before I tried to optimise it a bit. :)

int MyPRCResistSpell(object oCaster, object oTarget, float fDelay = 0.0)
{

    if (fDelay > 0.5)
    {
        fDelay = fDelay - 0.1;
    }

    int nResist = 0;
    int nTargetSR = GetSpellResistance(oTarget);
    int nRolled;
    string toSay = "";

    nResist = ExecuteScriptAndReturnInt("screen_targets", oTarget);
    // Make sure this script returns 0 if you don't want any thing specifically screened.
    // If this script returns 0, nothing happens
    // If 1, Spell is automatically resisted with the usual SR vfx
    // If 2, same, but with globe vfx
    // If 3, same, but with spell mantle vfx
    // If 4 or higher, same but with no vfx.


    /// I want the "add_spell_penetr" to return -2001, -2002, -2003, or -2004 if the target is
    /// supposed to just plain not get hurt by the spell.   It's a good way to do feats like
    /// the Arch Mage's Mastery of Shaping feat. (Though just the aspect of avoiding harm to allies)

    /// If -2001 is returned, the SR vfx fires and the target is unharmed.  If -2002 is returned,
    /// the globe vfx will fire instead.  If -2003 is returned, it will be the spell mantle vfx.
    /// And, if -2004 is returned, then no vfx at all.    In any of these cases, the target is
    /// unharmed.

    /// I figured it would be better processing time wise rather than to fire off 2 scripts
    /// one for friendly fire checks, and one for random spell penetration bonuses, to just
    /// have them both happen in  "add_spell_penetr"
    if(nResist == 0)
        {
        if(nTargetSR > 0)             // no matter how big the negative modifier you give the
            {                         // caster on their spell penetration check, it will never
                                      // fail against an sr of 0.

            int nCasterLevel = GetCasterLevel(oCaster) + ExecuteScriptAndReturnInt("prc_caster_level", oCaster);
        // this is the same as saying:  GetCasterLevel(oCaster) + GetChangesToCasterLevel(oCaster);
        // I just think it would be silly to actually call the GetChangesToCasterLevel(oCaster) function.
        // It only wastes like I don't know: 5 operations or so?  But why waste them?
            if(GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
                {
                nCasterLevel = nCasterLevel + 6;
                }
                else if(GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster))
                {
                nCasterLevel = nCasterLevel + 4;
                }
                else if(GetHasFeat(FEAT_SPELL_PENETRATION, oCaster))
                {
                nCasterLevel = nCasterLevel + 2;
                }

            // Adds any special amounts you might want to add to the check, useful if you want to
            // do something like have a staff or scepter of penetrating spell resistance, or a special
            // feat that adds a special bonus to the caster's checks to beat spell resistance.
            nCasterLevel = nCasterLevel + ExecuteScriptAndReturnInt("add_spell_penetr", oCaster);


            int nRolled = d20(1);
            // d&d 3.0E PHB page 150: caster's check (d20 + caster level) must equal or exceed target's SR
            // for the spell to affect it.  So the spell only fails if that check is LESS than the sr,
            // and succeeds if it's equal or greater.

            if(nCasterLevel + nRolled <  nTargetSR) // Do the actual spell resistance check.
                {
                nResist = 1; // <- This is what kills the spell.
                toSay = (IntToString(nRolled) + " + " + IntToString(nCasterLevel) + " = "
                + IntToString(nRolled + nCasterLevel) + " vs. Spell Resistance " + IntToString(nTargetSR)
                + " :  Resisted Spell. ");
                }
                else
                {
                toSay = (IntToString(nRolled) + " + " + IntToString(nCasterLevel) + " = "
                + IntToString(nRolled + nCasterLevel) + " vs. Spell Resistance " + IntToString(nTargetSR)
                + " :  Spell Resistance Defeated. ");
                }
                // A touch I thought I'd add in, since it's possible now.  Caster and Target get
                // to see the roll.  :)  They only see it if the spell hits or is defeated by SR.
                //
                DelayCommand(fDelay, SendMessageToPC(oCaster, toSay));
                DelayCommand(fDelay, SendMessageToPC(oTarget, toSay));

           }// end of check for if target has SR


        if(nResist == 0)    // I don't want it to run the Resist Spell function if SR wasn't penetrated
                {          // or if the target was already getting passed over, or it could waste some
                          // of the target's spell mantle unnecessarily.

                        // The downside is that globes of invulnerability also aren't tested against
                       // if sr isn't penetrated, only if it is.
                      // ie. if both a globe and SR stop a spell, the globe vfx won't fire, only
                     // the SR vfx.

                int nOtherReason = ResistSpell(oCaster, oTarget);
                switch(nOtherReason)
                    {
                    case 2: nResist = 2;break; // Spell stopped by globe
                    case 3: nResist = 3;break; // Spell stopped by spell mantle.
                    }

                }// end of check for globes of invulnerability, and spell mantles.
    }// end of original if(nResist == 0) check much earlier.   Yeah, there's 2 of them.



    effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);

    if(nResist == 1) //Spell Resistance
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));

    }
    else if(nResist == 2) //Globe
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
    }
    else if(nResist == 3) //Spell Mantle
    {
        if (fDelay > 0.5)
        {
            fDelay = fDelay - 0.1;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
    }
    return nResist;
}
// End of MyPRCResistSpell. :)  the longest function in this file.



// This function was scrapped, in favor of the other elemental damage modifying function.
// It lacked too much in versatility.
/*
effect PRCElementalDamage(object oCaster, int nDamage, int nType, int nDamagePower = DAMAGE_POWER_NORMAL)
{

int nNewType = ExecuteScriptAndReturnInt("set_damage_type", oCaster);
if(nNewType != 0)
{
nType = nNewType;
}
return EffectDamage(nDamage, nType, nDamagePower);

}
*/




/// used to get the +1 ECL caster level amount of a PRC
/// uses ExecuteScriptAndReturnInt() to get the amount of +1 ECL levels
/// that should be added to the spell's casting class due to a PRC
/// the script is called  "prc_caster_level"
int GetChangesToCasterLevel(object oCaster)
{
int nLevelAdded =  ExecuteScriptAndReturnInt("prc_caster_level", oCaster);
return nLevelAdded;
}



/// used to get additional modifications a DM may want made to a spell's save DC
/// uses ExecuteScriptAndReturnInt to decide if the save DC of the caster's spell
/// should be changed.     The script is called  "add_spell_dc"

int GetChangesToSaveDC(object oCaster)
{
return  ExecuteScriptAndReturnInt("add_spell_dc", oCaster);
}



//  uses ExecuteScriptAndReturnInt to decide whether the type
//  of elemental damage a spell does should be changed.   Mind you, the vfx for
//  an elemental spell will stay the same, only the damage type will change.
//  the script being executed is called "set_damage_type"

int ChangedElementalDamage(object oCaster, int nDamageType)
{
int nNewType = ExecuteScriptAndReturnInt("set_damage_type", oCaster);
if(nNewType != 0)
{
nDamageType = nNewType;
}
return nDamageType;
}

