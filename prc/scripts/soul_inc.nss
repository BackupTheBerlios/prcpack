
#include "x2_inc_switches"

// ShadowLOrd
const int IPRP_FEAT_SNEAKATK4     = 70;
const int IPRP_FEAT_DEATHATTACK   = 86;
const int IPRP_FEAT_DEATHATTACK20 = 105;

// Bonded
const int IPRP_FEAT_BarbEndurance = 106;

const int IPRP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS = 20;

int Sanctify_Feat(int iTypeWeap)
{
       switch(iTypeWeap)
            {
                case BASE_ITEM_BASTARDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BASTARDSWORD);
                case BASE_ITEM_BATTLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BATTLEAXE);
                case BASE_ITEM_CLUB: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_CLUB);
                case BASE_ITEM_DAGGER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DAGGER);
                case BASE_ITEM_DART: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DART);
                case BASE_ITEM_DIREMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DIREMACE);
                case BASE_ITEM_DOUBLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DOUBLEAXE);
              //  case BASE_ITEM_DWARVENWARAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DWAXE);
                case BASE_ITEM_GREATAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATAXE);
                case BASE_ITEM_GREATSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATSWORD);
                case BASE_ITEM_HALBERD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HALBERD);
                case BASE_ITEM_HANDAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HANDAXE);
                case BASE_ITEM_HEAVYCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYCROSSBOW);
                case BASE_ITEM_HEAVYFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYFLAIL);
                case BASE_ITEM_KAMA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KAMA);
                case BASE_ITEM_KATANA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KATANA);
                case BASE_ITEM_KUKRI: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KUKRI);
                case BASE_ITEM_LIGHTCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTCROSSBOW);
                case BASE_ITEM_LIGHTFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTFLAIL);
                case BASE_ITEM_LIGHTHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTHAMMER);
                case BASE_ITEM_LIGHTMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MACE);
                case BASE_ITEM_LONGBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGBOW);
                case BASE_ITEM_LONGSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGSWORD);
                case BASE_ITEM_MORNINGSTAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MORNINGSTAR);
                case BASE_ITEM_QUARTERSTAFF: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_QUATERSTAFF);
                case BASE_ITEM_RAPIER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_RAPIER);
                case BASE_ITEM_SCIMITAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCIMITAR);
                case BASE_ITEM_SCYTHE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCYTHE);
                case BASE_ITEM_SHORTBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTBOW);
                case BASE_ITEM_SHORTSPEAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SPEAR);
                case BASE_ITEM_SHORTSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTSWORD);
                case BASE_ITEM_SHURIKEN: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHURIKEN);
                case BASE_ITEM_SLING: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
                case BASE_ITEM_TWOBLADEDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_TWOBLADED);
                case BASE_ITEM_WARHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_WARHAMMER);
                case BASE_ITEM_WHIP: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
            }
    return 0;
}

int Add_SneakAtk(int nD6)
{
  int Iprp_Feat;

   if (nD6>40) nD6=40;

   if (nD6<6)
   {
      switch (nD6)
      {
        case 1:
          Iprp_Feat = 32;
          break;
        case 2:
          Iprp_Feat = 33;
          break;
        case 3:
          Iprp_Feat = 34;
          break;
        case 4:
          Iprp_Feat = IPRP_FEAT_SNEAKATK4;
          break;
        case 5:
          Iprp_Feat = 39;
          break;
      }
   }
   else
     Iprp_Feat = IPRP_FEAT_SNEAKATK4+nD6-5;

   return  Iprp_Feat;
}

int MyPRCResistSpell2(object oCaster, object oTarget,int nCasterLevel, float fDelay = 0.0)
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




