//::///////////////////////////////////////////////
//:: Frenzied Berserker - Frenzy
//:: NW_S1_frebzk
//:: Copyright (c) 2004 
//:: Special thanks to BioWare's Rage script
//:: and to mr bumpkin for the +12 stat cap bonuses
//:://////////////////////////////////////////////
/*
    Increases Str and reduces AC
    Greater Frenzy starts at level 8.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "inc_addragebonus"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void TurnBasedDamage(object oTarget, object oCaster);
void AttackNearestForDuration();

void main()
{
    if(!GetHasFeatEffect(FEAT_FRENZY))
    {	    
        // Declare major variables
        int nLevel = GetLevelByClass(CLASS_TYPE_FRE_BERSERKER);
        int nIncrease;
        int acDecrease;
        int hasHaste;
        int nSlot;  // for checking armor slots

        object oTarget = GetSpellTargetObject();
        
        // Removes effects of being winded
        RemoveSpecificEffect(EFFECT_TYPE_ABILITY_DECREASE, oTarget);
        RemoveSpecificEffect(EFFECT_TYPE_MOVEMENT_SPEED_DECREASE, oTarget);
        
        hasHaste = 0;
        acDecrease = 4;
        
        // Change the strength bonus at level 8
        if (nLevel < 8)
        {
            nIncrease = 6;
        }
        else
        {
            nIncrease = 10;
        }
        
        // Check for haste
        if(GetHasSpellEffect(SPELL_MASS_HASTE, oTarget) == TRUE)
        {
		hasHaste = 1;
	}
	if(GetHasSpellEffect(647, oTarget) == TRUE) // blinding speed
	{
		hasHaste = 1;	
	}
	if(GetHasSpellEffect(78, oTarget) == TRUE) // haste
	{
		hasHaste = 1;	
	}
	
	// Checks all equiped items for haste
	for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++) 
	{
	    object oItem = GetItemInSlot(nSlot, OBJECT_SELF);
	
	    if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE))
	    {
	          hasHaste = 1;		    	
            }
	}
	
	if(hasHaste == 1)
	{
		acDecrease = 8;
	}
	else
	{
		acDecrease = 4;
	}
        
        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
        
        //Determine the duration
        int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
        effect eAC = EffectACDecrease(acDecrease, AC_DODGE_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eStr, eAC);
        
        if(hasHaste == 0)
        {
		effect eHaste = EffectHaste();
		effect eMove = EffectMovementSpeedDecrease(50);
		eLink = EffectLinkEffects(eLink, eHaste);
		eLink = EffectLinkEffects(eLink, eMove);
		
		//effect eExAtt = EffectModifyAttacks(1);
		//eLink = EffectLinkEffects(eLink, eExAtt);
	}
        
        eLink = EffectLinkEffects(eLink, eDur);
        
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_FRENZY, FALSE));
        //Make effect extraordinary
        eLink = ExtraordinaryEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX

        if (nCon > 0)
        {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            
            object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
            DelayCommand(6.0f,TurnBasedDamage(oTarget, oSelf) );
            AttackNearestForDuration();

            // 2004-01-18 mr_bumpkin: determine the ability scores before adding bonuses, so the values
            // can be read in by the GiveExtraRageBonuses() function below.
            int StrBeforeBonuses = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH);
            int ConBeforeBonuses = GetAbilityScore(OBJECT_SELF,ABILITY_CONSTITUTION);
 
            // 2004-01-18 mr_bumpkin: Adds special bonuses to those barbarians who are restricted by the
            // +12 attribute bonus cap, to make up for them. :)
 
            // The delay is because you have to delay the command if you want the function to be able
            // to determine what the ability scores become after adding the bonuses to them.
            DelayCommand(0.1, GiveExtraRageBonuses(nCon,StrBeforeBonuses, ConBeforeBonuses, nIncrease, 0, 0, DAMAGE_TYPE_DIVINE, OBJECT_SELF));
        }
    }
}

void TurnBasedDamage(object oTarget, object oCaster)
{
    if (GZGetDelayedSpellEffectsExpired(SPELL_FRENZY,oTarget,oCaster)) // 2700
    {
        int nLevel = GetLevelByClass(CLASS_TYPE_FRE_BERSERKER);  // 210
	    
        // code for being winded
        if(nLevel < 10)
        {
             effect eStrPen = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
             effect eDexPen = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
             effect eMove = EffectMovementSpeedDecrease(50);
             effect eLink2 = EffectLinkEffects(eStrPen, eDexPen);
             eLink2 = EffectLinkEffects(eLink2, eMove);
             
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, OBJECT_SELF, RoundsToSeconds(10));
        }
              
        return;
    }
    
    if (GetIsDead(oTarget) == FALSE)
    {
	effect eDam = EffectDamage(2, DAMAGE_TYPE_MAGICAL);

        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,TurnBasedDamage(oTarget,oCaster));
    }
}

void AttackNearestForDuration()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, 1, -1, -1, -1, -1);    
     
    // stops force attacking when frenzy is over
    if (GZGetDelayedSpellEffectsExpired(SPELL_FRENZY,oCaster,oCaster))
    {
        AssignCommand(oCaster, ClearAllActions(TRUE) );     
        return;
    }	
    
    AssignCommand(oCaster, ActionAttack(oTarget, FALSE));
    DelayCommand(6.0f,AttackNearestForDuration() );
}
