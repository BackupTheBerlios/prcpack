//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_alter
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// alter self for the lich

#include "pnp_shifter"


void main()
{
    int nCurForm = GetAppearanceType(OBJECT_SELF);
    int nPCForm = GetTrueForm(OBJECT_SELF);

    // Switch to lich
    if (nPCForm == nCurForm)
    {
        int nLichLevel = GetLevelByClass(CLASS_TYPE_LICH,OBJECT_SELF);
        if (nLichLevel < 10)
        {
            effect eFx = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFx,OBJECT_SELF);

            SetCreatureAppearanceType(OBJECT_SELF,APPEARANCE_TYPE_LICH);
        }
        if (nLichLevel == 10)
        {
            effect eFx = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFx,OBJECT_SELF);
            SetCreatureAppearanceType(OBJECT_SELF,430); // DemiLich
        }
    }
    else // Switch to PC
    {
        effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFx,OBJECT_SELF);
        SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
    }
}
