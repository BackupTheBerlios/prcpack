//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_touch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// touch attack for the lich class

const int CLASS_TYPE_LICH = 90;

void main()
{
    object oTarget = GetSpellTargetObject();

    // Gotta hit first
    if(TouchAttackMelee(oTarget,TRUE)<1)
        return;

    // Gotta be a living critter
    int nType = GetRacialType(oTarget);
    if ((nType == RACIAL_TYPE_CONSTRUCT) ||
        (nType == RACIAL_TYPE_UNDEAD) ||
        (nType == RACIAL_TYPE_ELEMENTAL))
        return;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    // Lich level determines the damage and paralyze length
    int nLichLevel = GetLevelByClass(CLASS_TYPE_LICH);
    // Total character levels
    int nTotalHD = GetHitDice(OBJECT_SELF);
    // Save DC
    int nSaveDC = 10 + nTotalHD/2 + GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
    // Damage
    int nDam = 0;
    // Para duration in seconds
    float fDuration;
    switch(nLichLevel)
    {
    case 1:
        nDam += d6() + 5;
        fDuration = RoundsToSeconds(d4());
        break;
    case 2:
        nDam += d8() + 5;
        fDuration = IntToFloat(d4() * 60);
        break;
    case 3:
        nDam += d8() + 5;
        fDuration = IntToFloat(d4() * 60 * 60);
        break;
    case 4:
        nDam += d8() + 5;
        fDuration = 0.0;
        break;
    case 5:
        nDam += d6(4) + 5;
        fDuration = 0.0;
        break;
    case 6:
        nDam += d6(6) + 10;
        fDuration = 0.0;
        break;
    case 7:
        nDam += d6(8) + 15;
        fDuration = 0.0;
        break;
    case 8:
        nDam += d6(10) + 20;
        fDuration = 0.0;
        break;
    }

    // Apply Damage 1/2 if they will save
    effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
    if(WillSave(oTarget,nSaveDC , SAVING_THROW_WILL))
        nDam = nDam/2;

    effect eDamage = EffectDamage(nDam);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);

    // Apply paralyze touch
    if(FortitudeSave(oTarget,nSaveDC , SAVING_THROW_FORT))
        return;
    eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect ePara = EffectParalyze();
    ePara = EffectLinkEffects(eVis,ePara);
    // Cant be dispelled
    ePara = SupernaturalEffect(ePara);
    if (fDuration < 1.0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,ePara,oTarget);
    else
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePara,oTarget,fDuration);

    eVis = EffectVisualEffect(VFX_IMP_STUN);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);

    return;
}
