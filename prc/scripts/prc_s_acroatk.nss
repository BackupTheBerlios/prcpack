//::///////////////////////////////////////////////
//:: [Acrobatic Attack]
//:: [prc_s_acroatk.nss]
//:://////////////////////////////////////////////
//:: Leaps at a target and performs a full round of
//:: attacks at a bonus to damage and attack determined
//:: by feat level.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 21, 2003
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "inc_combat"

void main()
{
    object oTarget = GetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    int iEnhancement = GetWeaponEnhancement(oWeap);
    int iDamageType = GetWeaponDamageType(oWeap);

    float iDistance = GetDistanceToObject(oTarget);
    int iAttacks = GetBaseAttackBonus(OBJECT_SELF) / 5 + 1;
        iAttacks = iAttacks > 4 ? 4 : iAttacks;

    int iBonus = 0;
    int iNextAttackPenalty = 0;

    //Check which level of acrobatic attack has been used
    if(GetHasFeat(FEAT_ACROBATIC_ATTACK_8))iBonus = 8;
    else if(GetHasFeat(FEAT_ACROBATIC_ATTACK_6))iBonus = 6;
    else if(GetHasFeat(FEAT_ACROBATIC_ATTACK_4))iBonus = 4;
    else if(GetHasFeat(FEAT_ACROBATIC_ATTACK_2))iBonus = 2;

    int iDamage = 0;

    effect eDamage;
    effect eAttack = EffectAttackIncrease(iBonus);

    //Ability only works from 2.5 or more meters away
    if(iDistance >= 2.5f){
        DelayCommand(0.2, DoWhirlwindAttack(FALSE));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, OBJECT_SELF, 3.0f);
        DelayCommand(1.5f, JumpToObject(oTarget));

        float fDelay = 1.5f;

        //Perform a full round of attacks
        for(iAttacks; iAttacks > 0; iAttacks--){

            //Roll to hit
            int iHit = DoMeleeAttack(OBJECT_SELF, oWeap, oTarget, iBonus + iNextAttackPenalty, TRUE, fDelay);

            if(iHit > 0){

                //Check to see if we rolled a critical and determine damage accordingly
                if(iHit == 2)
                    iDamage = GetMeleeWeaponDamage(OBJECT_SELF, oWeap, TRUE) + iBonus;
                else
                    iDamage = GetMeleeWeaponDamage(OBJECT_SELF, oWeap, FALSE) + iBonus;

                //Apply the damage
                eDamage = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING, iEnhancement);
                DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

                iNextAttackPenalty -= 5;
                fDelay += 0.5;
            }
        }
    }
    else
    {
        FloatingTextStringOnCreature("Too close for Acrobatic Attack", OBJECT_SELF);
    }
}
