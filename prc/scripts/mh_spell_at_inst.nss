//::///////////////////////////////////////////////
//:: Name mh_spell_at_ins
//:: FileNameCast a spell to any instrument
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script is runned when a player is in
    Cast Spell at Instrument mod
*/
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On: February 2004
//:://////////////////////////////////////////////


#include "x2_inc_craft"
#include "mh_instr_inc"


void finish(object oTarget,int iDesactive = FALSE)
{
    string sScript =  GetLocalString(GetModule(),"temp_spell_at_inst");
    if (sScript != "")
        {
            ExecuteScript(sScript,OBJECT_SELF);
        }
    if(iDesactive)
    {
        UnactiveModeCIMM(oTarget);
    }

}


void main()
{
//SpawnScriptDebugger();
//define variable
object oItem = GetSpellTargetObject();
object oCaster = GetLastSpellCaster();

//if the target is not a instrument or spell cast from item or the caster is not
//the creator of the item, or if the caster is not in add spell mod
//cast the spell normaly and exit the add spell mod

if( (GetObjectType(oItem) != OBJECT_TYPE_ITEM) ||
    ( GetTag(oItem) != "MH_IT_LUTH" &&
      GetTag(oItem) != "MH_IT_HARP" &&
      GetTag(oItem) != "MH_IT_FLUTE" &&
      GetTag(oItem) != "MH_IT_COR" ) ||
      //GetObjectType(GetSpellCastItem()) != OBJECT_TYPE_INVALID ||
      oCaster != GetLocalObject(oItem, "mh_createur")

    )
    {

        finish(oCaster,GetLocalInt(oCaster,"use_CIMM"));
        return;
    }



int iID = GetSpellId();

int iIPConst =  IPGetIPConstCastSpellFromSpellID(iID);

if (iID == 0 && iIPConst != 0)
    {
        FloatingTextStrRefOnCreature(84544,oCaster);
        finish(oCaster);
        return;
    }
itemproperty ipC ;
float fCharge1 = 0.0f;
float fCharge2;
int iCost;
int iNewCost;

if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL))
    {
        //detect if the targe has the spell property
        itemproperty ipTest = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ipTest) && (iIPConst != GetItemPropertySubType(ipTest)))
        {
            ipTest = GetNextItemProperty(oItem);
        }


        if (iIPConst == GetItemPropertySubType(ipTest) )
        {
            iCost = GetItemPropertyCostTableValue(ipTest);
            if(iCost == IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY)
                iNewCost = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
            if(iCost == IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY)
                iNewCost = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
            if(iCost == IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY)
                iNewCost = IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY;
            if(iCost == IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY)
                iNewCost = IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY;
            if(iCost == IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY)
                {
                //if the item has max return
                FloatingTextStrRefOnCreature(16780242,oCaster);
                finish(oCaster);
                SetModuleOverrideSpellScriptFinished();
                return;
                }
            RemoveItemProperty(oItem,ipTest);
            ipC = ItemPropertyCastSpell(iIPConst,iNewCost);
        }
        else
        {
            iCost = 0;
            iNewCost = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            ipC = ItemPropertyCastSpell(iIPConst,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        }
    }
else
    {
        iCost = 0;
        iNewCost = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
        ipC = ItemPropertyCastSpell(iIPConst,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
    }


//get the cost of the property

if(iCost > 0)
    fCharge1 = StringToFloat(Get2DAString("iprp_chargecost","Cost",iCost));

fCharge2 = StringToFloat(Get2DAString("iprp_chargecost","Cost",iNewCost));

int iTotalCost = FloatToInt( (fCharge2 - fCharge1) * StringToFloat(Get2DAString("iprp_spells","Cost",iIPConst)) );
int iCostMax = GetLocalInt(oItem,"cout_instrument");
// if the cost is too hight return
if(iCostMax < iTotalCost)
    {
        FloatingTextStrRefOnCreature(16780243,oCaster);
        finish(oCaster);
        SetModuleOverrideSpellScriptFinished();
        return;
    }
AddItemProperty(DURATION_TYPE_PERMANENT,ipC, oItem);
SetLocalInt(oItem,"cout_instrument",iCostMax - iTotalCost);
SetModuleOverrideSpellScriptFinished();
}
