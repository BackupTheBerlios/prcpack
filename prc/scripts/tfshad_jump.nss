#include "prc_alterations"
#include "inc_item_props"
#include "inc_combat2"

const int PHS_VFX_IMP_DIMENSION_DOOR_DISS   = 777;
const int PHS_VFX_IMP_DIMENSION_DOOR_APPR   = 776;

void main()
{
    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    int iLevel       =  GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);
    int iMaxDis      =  iLevel*6;
    int iDistance    =  FloatToInt(GetDistanceBetweenLocations(lCaster,lTarget));
    int iLeftUse = 1;

    int iFeat=FEAT_SHADOWJUMP-1+GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);



    while (GetHasFeat(iFeat,OBJECT_SELF))
    {
      DecrementRemainingFeatUses(OBJECT_SELF,iFeat);
      iLeftUse++;
    }

    int nCount=iLeftUse-1;
    while (nCount)
    {
      IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
      nCount--;
    }

    if ( iMaxDis>iLeftUse*3) iMaxDis=iLeftUse*3;

    if  (iDistance>iMaxDis)
    {
        FloatingTextStringOnCreature("Distance too Far", OBJECT_SELF);
        IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
        return;
    }

    iDistance=(iDistance-3)/3;
    while (iDistance)
    {
      DecrementRemainingFeatUses(OBJECT_SELF,iFeat);
      iDistance--;
    }

    // Duration is 1 turn
    float fDuration = TurnsToSeconds(1);

    // Declare effects
    effect eDissappear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_DISS);
    effect eAppear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_APPR);

    // Duration effect for stopping the caster do anything else
    effect eDur = EffectCutsceneParalyze();

        // Jump to the target location with visual effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDissappear, lCaster);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAppear, lTarget);

        // Jump
        DelayCommand(1.0, JumpToLocation(lTarget));

        if (iLevel<4)
        {
           // Caster cannot move for 1 turn now.
           DelayCommand(1.5, SendMessageToPC(oCaster, "You cannot perform any more actions for 1 turn due to the Shadow Jump"));
           DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration));
        }
        else
        {
           object oTarget = GetSpellTargetObject();
           object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
           int iEnhancement = GetWeaponEnhancement(oWeap);
           int iDamageType = GetWeaponDamageType(oWeap);
           if  ( GetObjectType(oTarget)!= OBJECT_TYPE_CREATURE) return;

           int iAttacks=NbAtk(OBJECT_SELF);
           int iSneakAttack,iDeathAttack ;
           int iBonus = 0;
           int iNextAttackPenalty = 0;
           int iDamage = 0;

           effect eDamage;

           if (!GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT))
           {
            iSneakAttack=((GetLevelByClass(CLASS_TYPE_ROGUE,OBJECT_SELF)+1)/2) +
                         ((GetLevelByClass(CLASS_TYPE_BLACKGUARD,OBJECT_SELF)-1)/3);
            iDeathAttack= ((GetLevelByClass(CLASS_TYPE_ASSASSIN,OBJECT_SELF)+1)/2) +
                           GetHasFeat(FEAT_DEATHATTACK, OBJECT_SELF);

             int iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1,OBJECT_SELF) ? 1:0;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2,OBJECT_SELF) ? 2:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3,OBJECT_SELF) ? 3:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4,OBJECT_SELF) ? 4:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5,OBJECT_SELF) ? 5:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6,OBJECT_SELF) ? 6:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7,OBJECT_SELF) ? 7:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8,OBJECT_SELF) ? 8:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9,OBJECT_SELF) ? 9:iEpicSneak;
                 iEpicSneak = GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10,OBJECT_SELF) ? 10:iEpicSneak;

             iSneakAttack+=iEpicSneak+iDeathAttack;


            iBonus=d6(iSneakAttack);

           }


            float fDelay = 1.5f;

           //Perform a full round of attacks
           for(iAttacks; iAttacks > 0; iAttacks--)
           {

             //Roll to hit
             int iHit = DoMeleeAttack(OBJECT_SELF, oWeap, oTarget, iBonus + iNextAttackPenalty, TRUE, fDelay);

             if(iHit > 0)
             {
                //Check to see if we rolled a critical and determine damage accordingly
                if(iHit == 2)
                    iDamage = GetMeleeWeaponDamage(OBJECT_SELF, oWeap, TRUE) + iBonus;
                else
                    iDamage = GetMeleeWeaponDamage(OBJECT_SELF, oWeap, FALSE) + iBonus;

                //Apply the damage
                eDamage = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING, iEnhancement);
                DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

                if (iDeathAttack && iBonus)
                {
                    if (!FortitudeSave(oTarget,10+iDeathAttack+GetAbilityModifier(ABILITY_INTELLIGENCE,OBJECT_SELF),SAVING_THROW_TYPE_DEATH))
                       DelayCommand(fDelay + 0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oTarget));


                }

                iNextAttackPenalty -= 5;
                fDelay += 0.5;
             }
             iBonus=0;
          }
        }
}

