#include "prc_dg_inc"

void main()
{
    object oCaster = GetLastSpellCaster();
    object oTarget = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
    string sItem = GetTag(oItem);
    string sTarget =  GetTag(oTarget);
    //SendMessageToPC(oCaster, sTarget);

    if( sItem == "ScepterofNotHarmingBoars")
    {
        if(sTarget == "NW_BOARDIRE" || sTarget == "NW_BOAR" || sTarget == "NW_S_BOARDIRE")
        {
            SetLocalInt(oTarget,"X2_L_LAST_RETVAR", 2);
            return;
        }
    }

    else if ((GetHasFeat(FEAT_MASTERY_SHAPES, oCaster)) && (GetLocalInt(oCaster, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, oCaster) || oTarget == oCaster || GetMaster(oTarget) == oCaster))
    {
        SetLocalInt(oTarget,"X2_L_LAST_RETVAR", 3);
        return;
    }
    // This part is to screen friendly targets.
    // Set it to:
    // 1 if you want the spell resistance vfx to fire
    // 2 for globe vfx
    // 3 for spell mantle vfx
    // 4 or higher for no vfx at all.

    SetLocalInt(oTarget,"X2_L_LAST_RETVAR", 0);
}

// Holding this scepter will prevent you from dealing damage to a standard Boar
// or Wild Boar,  but only when casting spells that allow spell resistance, spell mantles,
// or Globes of Invulnerability - not sure which ones that would exclude.    Of course this
// only works on boars with the default tags, and summoned boars.   Just for fun, not seriously
// an item anyone would really use.

// On persistent AoE's, the caster must have the scepter equipped whenever damage
// would be dealt in order to  prevent it.

// I know.  This one's silly.  Hopefully the other two scepters are more interesting.:)



