//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file can hold your module specific
    OnHitCastSpell definitions

    How to use:
    - Add the Item Property OnHitCastSpell: UniquePower (OnHit)
    - Add code to this spellscript (see below)

   WARNING!
   This item property can be a major performance hog when used
   extensively in a multi player module. Especially in higher
   levels, with each player having multiple attacks, having numerous
   of OnHitCastSpell items in your module this can be a problem.

   It is always a good idea to keep any code in this script as
   optimized as possible.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "heartward_inc"
#include "prc_inc_oni"

void main()
{

   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
   int nVassal;         //Vassal Level

   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        =  GetSpellCastItem();
   nVassal = GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);


   if (GetIsObjectValid(oItem))
   {
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ONHITCAST);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
     }

//// Stormlord Shocking & Thundering Spear

     if (GetHasFeat( FEAT_THUNDER_WEAPON,OBJECT_SELF))
           ExecuteScript("ft_shockweap",OBJECT_SELF);


   }
   
///  Vassal of Bahamut Dragonwrack
     if (nVassal >= 4)
        {
           if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
            {
                ExecuteScript("ft_dw_armor", oSpellTarget);
            }
           else
            {
                ExecuteScript("ft_dw_weapon", oSpellTarget);
            }
         }

   // Frenzied Berserker Auto Frenzy
   if(GetHasFeat(FEAT_FRENZY, OBJECT_SELF) )
   {      
	if(!GetHasFeatEffect(FEAT_FRENZY))
	{	    
		// 10 + damage dealt in that hit
		int willSaveDC = 10 + GetTotalDamageDealt();
		int save = WillSave(OBJECT_SELF, willSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
        	if(save == 0)
        	{
			AssignCommand(OBJECT_SELF, ActionUseFeat(FEAT_FRENZY, OBJECT_SELF) );
		}
        }     
   }
   
   if(GetLevelByClass(CLASS_TYPE_FOE_HUNTER, OBJECT_SELF) > 1)
   {
        ExecuteScript("prc_fh_dr",OBJECT_SELF);
   }
}
