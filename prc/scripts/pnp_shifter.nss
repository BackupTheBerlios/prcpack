//::///////////////////////////////////////////////
//:: Name     Shifter PnP functions
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Functions used by the shifter class to better simulate the PnP rules

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "nw_o0_itemmaker"
#include "nw_i0_spells"

// Determine the level of the Shifter needed to take on
// oTargets shape.
// Returns 1-10 for Shifter level, 11+ for Total levels
int GetShifterLevelRequired(object oTarget);
// Can the shifter (oPC) assume the form of the target
// return Values: TRUE or FALSE
int GetValidShift(object oPC, object oTarget);
// Determine if the oCreature can wear certain equipment
// nInvSlot INVENTORY_SLOT_*
// Return values: TRUE or FALSE
int GetCanFormEquip(object oCreature, int nInvSlot);
// Determine if the oCreature has the ability to cast spells
// Return values: TRUE or FALSE
int GetCanFormCast(object oCreature);
// Translastes a creature name to a resref for use in createobject
// returns a resref string
string GetResRefFromName(string sName);
// Determines if the oCreature is harmless enough to have
// special effects applied to the shifter
// Return values: TRUE or FALSE
int GetIsCreatureHarmless(object oCreature);
// Determines the APPEARANCE_TYPE_* for the PC
// based on the players RACIAL type
int GetTrueForm(object oPC);

// Transforms the oPC into the oTarget
// Assumes oTarget is already a valid target
// Return values: TRUE or FALSE
int SetShift(object oPC, object oTarget);
// Transforms the oPC into the oTarget using the epic rules
// Assumes oTarget is already a valid target
// Return values: TRUE or FALSE
int SetShiftEpic(object oPC, object oTarget);
// Transforms the oPC back to thier true form if they are shifted
// Return values: TRUE or FALSE
int SetShiftTrueForm(object oPC);
// Creates a temporary creature for the shifter to shift into
// Assumes that the creature is valid for the shifter level
// Return values: TRUE or FALSE
int SetShiftFromTemplate(object oPC, string sTemplate);
// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
int SetShiftFromTemplateValidate(object oPC, string sTemplate);
// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
int SetShiftEpicFromTemplateValidate(object oPC, string sTemplate);

// Extra item functions
// Copys all the item properties from the target to the destination
void CopyAllItemProperties(object oDestination,object oTarget);
// Gets all the ability modifires from the creature objects inv
// use IP_CONTS_ABILITY_*
int GetAllItemsAbilityModifier(object oTarget, int nAbility);
// Removes all the item properties from the item
void RemoveAllItemProperties(object oItem);
// Gets an IP_CONST_FEAT_* from FEAT_*
// returns -1 if the feat is not available
int GetIPFeatFromFeat(int nFeat);
// Determines if the target creature has a certain type of spell
// and sets the powers onto the object item
void SetItemSpellPowers(object oItem, object oTarget);

// Removes leftover aura effects
void RemoveAuraEffect( object oPC );
// Adds a creature to the list of valid GWS shift possibilities
void RecognizeCreature( object oPC, string sTemplate );
// Checks to see if the specified creature is a valid GWS shift choice
int IsKnownCreature( object oPC, string sTemplate );
// Shift based on position in the known array
// oTemplate is either the epic or normal template
void ShiftFromKnownArray(int nIndex, object oTemplate, object oPC);

void RecognizeCreature( object oPC, string sTemplate )
{
    // Only add new ones
    if (IsKnownCreature(oPC,sTemplate))
        return;

    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    if ( !GetIsObjectValid(oMimicForms) )
        oMimicForms = CreateItemOnObject( "sparkoflife", oPC );

    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );

    SetLocalArrayString( oMimicForms, "shift_choice", num_creatures, sTemplate );
    SetLocalInt( oMimicForms, "num_creatures", num_creatures+1 );
}

int IsKnownCreature( object oPC, string sTemplate )
{
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int i;
    string cmp;

    for ( i=0; i<num_creatures; i++ )
    {
        cmp = GetLocalArrayString( oMimicForms, "shift_choice", i );
        if ( TestStringAgainstPattern( cmp, sTemplate ) )
        {
            return TRUE;
        }
    }
    return FALSE;
}

// Shift based on position in the known array
void ShiftFromKnownArray(int nIndex,object oTemplate, object oPC)
{
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");

    // Find the name
    string sResRef = GetLocalArrayString( oMimicForms, "shift_choice", nIndex );
    if (GetResRef(oTemplate) == "shifterlistenero")
    {
        // Force a normal shift
        if (SetShiftFromTemplateValidate(oPC,sResRef))
            DestroyObject(oTemplate,2.0);
    }
    else // epic shift
    {
        if (SetShiftEpicFromTemplateValidate(oPC,sResRef))
            DestroyObject(oTemplate,2.0);
    }
}


// Remove "dangling" aura effects on trueform shift
// Now only removes things it should remove (i.e., auras)
void RemoveAuraEffect( object oPC )
{
    if ( GetHasSpellEffect(SPELLABILITY_AURA_BLINDING, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_BLINDING, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_COLD, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_COLD, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_ELECTRICITY, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_ELECTRICITY, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_FEAR, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_FEAR, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_FIRE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_FIRE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_MENACE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_MENACE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_PROTECTION, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_PROTECTION, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_STUN, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_STUN, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNEARTHLY_VISAGE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_UNEARTHLY_VISAGE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNNATURAL, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_UNNATURAL, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_DRAGON_FEAR, oPC) )
        RemoveSpellEffects( SPELLABILITY_DRAGON_FEAR, oPC, oPC );
}


void CopyAllItemProperties(object oDestination,object oTarget)
{
    itemproperty iProp = GetFirstItemProperty(oTarget);

    while (GetIsItemPropertyValid(iProp))
    {
        AddItemProperty(GetItemPropertyDurationType(iProp),
                        iProp,
                        oDestination);

        iProp = GetNextItemProperty(oTarget);
    }
}

int GetAllItemsAbilityModifier(object oTarget, int nAbility)
{
    // Go through all the equipment and add it all up
    int nRetValue = 0;
    object oItem;
    itemproperty iProp;
    int i;

    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oItem = GetItemInSlot(i,oTarget);

        if (GetIsObjectValid(oItem))
        {
            iProp = GetFirstItemProperty(oItem);
            while (GetIsItemPropertyValid(iProp))
            {
                //SendMessageToPC(oTarget,"In while loop for " + GetName(oItem));
                if (ITEM_PROPERTY_ABILITY_BONUS == GetItemPropertyType(iProp))
                {
                    if (nAbility == GetItemPropertySubType(iProp))
                    {
                        nRetValue += GetItemPropertyCostTableValue(iProp);
                    }
                }
                iProp = GetNextItemProperty(oItem);
            }
        }

    }
    return nRetValue;
}

void RemoveAllItemProperties(object oItem)
{
    itemproperty iProp = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(iProp))
    {
        RemoveItemProperty(oItem,iProp);

        iProp = GetNextItemProperty(oItem);
    }
}

// Gets an IP_CONST_FEAT_* from FEAT_*
// -1 is an invalid IP_CONST_FEAT
int GetIPFeatFromFeat(int nFeat)
{
    switch (nFeat)
    {
    case FEAT_ALERTNESS:
        return IP_CONST_FEAT_ALERTNESS;
    case FEAT_AMBIDEXTERITY:
        return IP_CONST_FEAT_AMBIDEXTROUS;
    case FEAT_ARMOR_PROFICIENCY_HEAVY:
        return IP_CONST_FEAT_ARMOR_PROF_HEAVY;
    case FEAT_ARMOR_PROFICIENCY_LIGHT:
        return IP_CONST_FEAT_ARMOR_PROF_LIGHT;
    case FEAT_ARMOR_PROFICIENCY_MEDIUM:
        return IP_CONST_FEAT_ARMOR_PROF_MEDIUM;
    case FEAT_CLEAVE:
        return IP_CONST_FEAT_CLEAVE;
    case FEAT_COMBAT_CASTING:
        return IP_CONST_FEAT_COMBAT_CASTING;
    case FEAT_DODGE:
        return IP_CONST_FEAT_DODGE;
    case FEAT_EXTRA_TURNING:
        return IP_CONST_FEAT_EXTRA_TURNING;
    case FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE:
        return IP_CONST_FEAT_IMPCRITUNARM;
    case FEAT_IMPROVED_KNOCKDOWN:
        return IP_CONST_FEAT_KNOCKDOWN;
    case FEAT_POINT_BLANK_SHOT:
        return IP_CONST_FEAT_POINTBLANK;
    case FEAT_POWER_ATTACK:
        return IP_CONST_FEAT_POWERATTACK;
    case FEAT_SPELL_FOCUS_ABJURATION:
        return IP_CONST_FEAT_SPELLFOCUSABJ;
    case FEAT_SPELL_FOCUS_CONJURATION:
        return IP_CONST_FEAT_SPELLFOCUSCON;
    case FEAT_SPELL_FOCUS_DIVINATION:
        return IP_CONST_FEAT_SPELLFOCUSDIV;
    case FEAT_SPELL_FOCUS_ENCHANTMENT:
        return IP_CONST_FEAT_SPELLFOCUSENC;
    case FEAT_SPELL_FOCUS_EVOCATION:
        return IP_CONST_FEAT_SPELLFOCUSEVO;
    case FEAT_SPELL_FOCUS_ILLUSION:
        return IP_CONST_FEAT_SPELLFOCUSILL;
    case FEAT_SPELL_FOCUS_NECROMANCY:
        return IP_CONST_FEAT_SPELLFOCUSNEC;
    case FEAT_SPELL_PENETRATION:
        return IP_CONST_FEAT_SPELLPENETRATION;
    case FEAT_TWO_WEAPON_FIGHTING:
        return IP_CONST_FEAT_TWO_WEAPON_FIGHTING;
    case FEAT_WEAPON_FINESSE:
        return IP_CONST_FEAT_WEAPFINESSE;
    case FEAT_WEAPON_PROFICIENCY_EXOTIC:
        return IP_CONST_FEAT_WEAPON_PROF_EXOTIC;
    case FEAT_WEAPON_PROFICIENCY_MARTIAL:
        return IP_CONST_FEAT_WEAPON_PROF_MARTIAL;
    case FEAT_WEAPON_PROFICIENCY_SIMPLE:
        return IP_CONST_FEAT_WEAPON_PROF_SIMPLE;
    case FEAT_IMPROVED_UNARMED_STRIKE:
        return IP_CONST_FEAT_WEAPSPEUNARM;

    // Some undefined ones
    case FEAT_DISARM:
        return 28;
    case FEAT_HIDE_IN_PLAIN_SIGHT:
        return 31;
    case FEAT_MOBILITY:
        return 27;
    case FEAT_RAPID_SHOT:
        return 30;
    case FEAT_SHIELD_PROFICIENCY:
        return 35;
    case FEAT_SNEAK_ATTACK:
        return 32;
    case FEAT_USE_POISON:
        return 36;
    case FEAT_WHIRLWIND_ATTACK:
        return 29;
    case FEAT_WEAPON_PROFICIENCY_CREATURE:
        return 38;
        // whip disarm is 37
    }
    return (-1);
}

// Determines if the target creature has a certain type of spell
// and sets the powers onto the object item
void SetItemSpellPowers(object oItem, object oCreature)
{
    itemproperty iProp;
    int total_props = 0; //max of 8 properties on one item

    //first, auras--only want to allow one aura power to transfer
    if ( GetHasSpell(SPELLABILITY_AURA_BLINDING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(750,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(751,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_ELECTRICITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(752,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(753,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(754,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_MENACE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(755,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_PROTECTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(756,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(757,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNEARTHLY_VISAGE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(758,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNNATURAL, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(759,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, bolts
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(760,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(761,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(762,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(763,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(764,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(765,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(766,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CHARM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(767,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(768,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CONFUSE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(769,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(770,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(771,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(772,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DOMINATE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(773,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(774,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_KNOCKDOWN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(775,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LEVEL_DRAIN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(776,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(777,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_PARALYZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(778,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(779,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SHARDS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(780,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SLOW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(781,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(782,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_WEB, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(783,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, cones
    if ( GetHasSpell(SPELLABILITY_CONE_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(784,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(785,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(786,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(787,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(788,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(789,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_SONIC, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(790,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //various petrify attacks
    if ( GetHasSpell(SPELLABILITY_BREATH_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(791,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(792,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_TOUCH_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(793,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //dragon stuff (fear aura, breaths)
    if ( GetHasSpell(SPELLABILITY_DRAGON_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(796,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(400,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(401,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(402,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(403,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_GAS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(404,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(405,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(698, oCreature) && (total_props <= 7) ) //NEGATIVE
    {
        iProp = ItemPropertyCastSpell(794,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_PARALYZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(406,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLEEP, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(407,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLOW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(408,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_WEAKEN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(409,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(771, oCreature) && (total_props <= 7) ) //PRISMATIC
    {
        iProp = ItemPropertyCastSpell(795,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //gaze attacks
    if ( GetHasSpell(SPELLABILITY_GAZE_CHARM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(797,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_CONFUSION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(798,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(799,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(800,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_CHAOS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(801,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_EVIL, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(802,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_GOOD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(803,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_LAW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(804,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOMINATE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(805,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(806,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(807,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PARALYSIS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(808,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_STUNNED, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(809,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //miscellaneous abilities
    if ( GetHasSpell(SPELLABILITY_GOLEM_BREATH_GAS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(810,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HELL_HOUND_FIREBREATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(811,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_KRENSHAR_SCARE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(812,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //howls
    if ( GetHasSpell(SPELLABILITY_HOWL_CONFUSE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(813,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(814,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(815,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DOOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(816,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(817,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_PARALYSIS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(818,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_SONIC, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(819,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(820,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //pulses
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(821,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(822,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(823,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(824,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(825,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(826,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(827,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(828,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(829,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DROWN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(830,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(831,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_HOLY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(832,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LEVEL_DRAIN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(833,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(834,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_NEGATIVE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(835,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(836,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_SPORES, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(837,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_WHIRLWIND, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(838,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //monster summon abilities
    if ( GetHasSpell(SPELLABILITY_SUMMON_SLAAD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(839,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_SUMMON_TANARRI, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(840,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //abilities without const refs
    if ( GetHasSpell(552, oCreature) && (total_props <= 7) ) //PSIONIC CHARM
    {
        iProp = ItemPropertyCastSpell(841,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(551, oCreature) && (total_props <= 7) ) //PSIONIC MINDBLAST
    {
        iProp = ItemPropertyCastSpell(842,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(713, oCreature) && (total_props <= 7) ) //MINDBLAST 10M
    {
        iProp = ItemPropertyCastSpell(843,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(741, oCreature) && (total_props <= 7) ) //PSIONIC BARRIER
    {
        iProp = ItemPropertyCastSpell(844,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(763, oCreature) && (total_props <= 7) ) //PSIONIC CONCUSSION
    {
        iProp = ItemPropertyCastSpell(845,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(731, oCreature) && (total_props <= 7) ) //BEBILITH WEB
    {
        iProp = ItemPropertyCastSpell(846,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(736, oCreature) && (total_props <= 7) ) //BEHOLDER EYES
    {
        iProp = ItemPropertyCastSpell(847,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(770, oCreature) && (total_props <= 7) ) //CHAOS SPITTLE
    {
        iProp = ItemPropertyCastSpell(848,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(757, oCreature) && (total_props <= 7) ) //SHADOWBLEND
    {
        iProp = ItemPropertyCastSpell(849,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(774, oCreature) && (total_props <= 7) ) //DEFLECTING FORCE
    {
        iProp = ItemPropertyCastSpell(850,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //some spell-like abilities
    if ((GetHasSpell(SPELL_DARKNESS,oCreature) ||
        GetHasSpell(SPELLABILITY_AS_DARKNESS,oCreature)) &&
        total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_DISPLACEMENT,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPLACEMENT_9,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ((GetHasSpell(SPELLABILITY_AS_INVISIBILITY,oCreature) ||
        GetHasSpell(SPELL_INVISIBILITY,oCreature)) &&
        total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_WEB,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_MAGIC_MISSILE,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_FIREBALL,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_10,IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_CONE_OF_COLD,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_9,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_LIGHTNING_BOLT,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_10,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_CURE_CRITICAL_WOUNDS,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_HEAL,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HEAL_11,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_FINGER_OF_DEATH,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FINGER_OF_DEATH_13,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_FIRE_STORM,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIRE_STORM_13,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_HAMMER_OF_THE_GODS,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_GREATER_DISPELLING,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREATER_DISPELLING_7,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_DISPEL_MAGIC,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_10,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_HARM,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HARM_11,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
}


// Determines the level of the shifter class needed to take on
// oTargets shape.
// Returns 1-10 for Shifter level
// 1000 means they can never take the shape
int GetShifterLevelRequired(object oTarget)
{
    // Target Information
    int nTSize = GetCreatureSize(oTarget);
    int nTRacialType = MyPRCGetRacialType(oTarget);

    int nLevelRequired = 0;

    // Size validation
    switch (nTSize)
    {
    case CREATURE_SIZE_HUGE:
        if (nLevelRequired < 7)
            nLevelRequired = 7;
        break;
    case CREATURE_SIZE_TINY:
    case CREATURE_SIZE_LARGE:
        if (nLevelRequired < 3)
            nLevelRequired = 3;
        break;
    case CREATURE_SIZE_MEDIUM:
    case CREATURE_SIZE_SMALL:
        if (nLevelRequired < 1)
            nLevelRequired = 1;
        break;
    }

    // Type validation
    switch (nTRacialType)
    {
    case RACIAL_TYPE_FEY:
    case RACIAL_TYPE_SHAPECHANGER:
        nLevelRequired = 1000;
        break;
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_ELEMENTAL:
        if (nLevelRequired < 9)
            nLevelRequired = 9;
        break;
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_UNDEAD:
        if (nLevelRequired < 8)
            nLevelRequired = 8;
        break;
    case RACIAL_TYPE_DRAGON:
        if (nLevelRequired < 7)
            nLevelRequired = 7;
        break;
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_OOZE:
        if (nLevelRequired < 6)
            nLevelRequired = 6;
        break;
    case RACIAL_TYPE_MAGICAL_BEAST:
        if (nLevelRequired < 5)
            nLevelRequired = 5;
        break;
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_VERMIN:
        if (nLevelRequired < 4)
            nLevelRequired = 4;
        break;
    case RACIAL_TYPE_BEAST:
//    case RACIAL_TYPE_PLANT:
        if (nLevelRequired < 3)
            nLevelRequired = 3;
        break;
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
        if (nLevelRequired < 2)
            nLevelRequired = 2;
        break;
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
        // all level 1 forms
        if (nLevelRequired < 1)
            nLevelRequired = 1;
        break;
    }
    return nLevelRequired;
}

// Can the shifter (oPC) assume the form of the target
// return Values: TRUE or FALSE
int GetValidShift(object oPC, object oTarget)
{
    // Valid Monster?
    if (!GetIsObjectValid(oTarget))
        return FALSE;
    // Valid PC
    if (!GetIsObjectValid(oPC))
        return FALSE;

    // Target Information
    int nTHD = GetHitDice(oTarget);

    // PC Info
    int nPCHD = GetHitDice(oPC);
    int nPCShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER,oPC);

    // HD check (cant take any form that has more HD then the shifter)
    if (nTHD > nPCHD)
    {
        SendMessageToPC(oPC,"You need " + IntToString(nTHD-nPCHD) + " more levels before you can take on that form" );
        return FALSE;
    }

    // Check the shifter level required
    int nPCShifterLevelsRequired = GetShifterLevelRequired(oTarget);
    if (nPCShifterLevel < nPCShifterLevelsRequired)
    {
        if (nPCShifterLevelsRequired == 1000)
            SendMessageToPC(oPC,"You can never take on that form" );
        else
            SendMessageToPC(oPC,"You need " + IntToString(nPCShifterLevelsRequired) + " shifter levels before you can take on that form" );
        return FALSE;
    }

    return TRUE;
}
// Determine if the oCreature can wear certain equipment
// nInvSlot INVENTORY_SLOT_*
// Return values: TRUE or FALSE
int GetCanFormEquip(object oCreature, int nInvSlot)
{
    int nTRacialType = MyPRCGetRacialType(oCreature);

    switch (nTRacialType)
    {
    case RACIAL_TYPE_SHAPECHANGER:
    case RACIAL_TYPE_OOZE:
//    case RACIAL_TYPE_PLANT:
        // These forms can't wear any equipment
        return FALSE;
        break;
    case RACIAL_TYPE_DRAGON:
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_MAGICAL_BEAST:
    case RACIAL_TYPE_VERMIN:
    case RACIAL_TYPE_BEAST:
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_ELEMENTAL:
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_UNDEAD:
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
    case RACIAL_TYPE_FEY:
        break;
    }

    return TRUE;
}

// Determine if the oCreature has the ability to cast spells
// Return values: TRUE or FALSE
int GetCanFormCast(object oCreature)
{
    int nTRacialType = MyPRCGetRacialType(oCreature);

    // Need to have hands, and the ability to speak

    switch (nTRacialType)
    {
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_MAGICAL_BEAST:
    case RACIAL_TYPE_VERMIN:
    case RACIAL_TYPE_BEAST:
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_OOZE:
//    case RACIAL_TYPE_PLANT:
        // These forms can't cast spells
        return FALSE;
        break;
    case RACIAL_TYPE_SHAPECHANGER:
    case RACIAL_TYPE_ELEMENTAL:
    case RACIAL_TYPE_DRAGON:
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_UNDEAD:
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
    case RACIAL_TYPE_FEY:
        break;
    }

    return TRUE;
}

// Translastes a creature name to a resref for use in createobject
// returns a resref string
string GetResRefFromName(string sName)
{
    string slName = GetStringLowerCase(sName);
    string sDefaultName;

    // many monsters are in this format
    // nw_slName (no spaces)

    // this list will only contain the exceptions to that rule

    if ( "bear" == slName)
        return "nw_bearblck";
    if ( "black bear" == slName)
        return "nw_bearblck";
    if ( "brown bear" == slName)
        return "nw_bearbrwn";
    if ( "dire bear" == slName)
        return "nw_beardire";
    if ( "grizzly bear" == slName)
        return "nw_bearkodiak";
    if ( "polar bear" == slName)
        return "nw_bearpolar";
    if ( "ancient dire bear" == slName)
        return "nw_beardireboss";
    if ( "falcon" == slName)
        return "nw_raptor001";
    if ( "hawk" == slName)
        return "nw_raptor";
    if ( "dire wolf" == slName)
        return "nw_direwolf";
    if ( "pack leader" == slName)
        return "nw_wolfdireboss";
    if ( "winter wolf" == slName)
        return "nw_wolfwint";
    if ( "crag cat" == slName)
        return "nw_cragcat";
    if ( "dire tiger" == slName)
        return "nw_diretiger";
    if ("malar panther" == slName)
        return "nw_beastmalar001 ";
    if ( "leopard" == slName)
        return "nw_cat";
    if ( "dire badger" == slName)
        return "nw_direbadg";
    if ( "dire boar" == slName)
        return "nw_boardire";
    if ( "dire rat" == slName)
        return "nw_ratdire001";
    if ( "rat" == slName)
        return "nw_rat001";
    if ( "white stag" == slName)
        return "nw_deerstag";
    if ( "battle horror" == slName)
        return "nw_bathorror";
    if ( "bone golem" == slName)
        return "golbone";
    if ( "clay golem" == slName)
        return "nw_golclay";
    if ( "flesh golem" == slName)
        return "nw_golflesh";
    if ( "helmed horror" == slName)
        return "nw_helmhorr";
    if ( "iron golem" == slName)
        return "nw_goliron";
    if ( "shield guardian" == slName)
        return "nw_shguard";
    if ( "stone golem" == slName)
        return "nw_golstone";
    if ( "adult black dragon" == slName)
        return "nw_drgblack001";
    if ( "adult blue dragon" == slName)
        return "nw_drgblue001";
    if ( "adult brass dragon" == slName)
        return "nw_drgbrass001";
    if ( "adult bronze dragon" == slName)
        return "nw_drgbrnz001";
    if ( "adult copper dragon" == slName)
        return "nw_drgcopp001";
    if ( "adult gold dragon" == slName)
        return "nw_drggold001";
    if ( "adult green dragon" == slName)
        return "nw_drggreen001";
    if ( "adult red dragon" == slName)
        return "nw_drgred001";
    if ( "adult silver dragon" == slName)
        return "nw_drgsilv001";
    if ( "adult white dragon" == slName)
        return "nw_drgwhite001";
    if ( "ancient black dragon" == slName)
        return "nw_drgblack003";
    if ( "ancient blue dragon" == slName)
        return "nw_drgblue003";
    if ( "ancient brass dragon" == slName)
        return "nw_drgbrass003";
    if ( "ancient bronze dragon" == slName)
        return "nw_drgbrnz003";
    if ( "ancient copper dragon" == slName)
        return "nw_drgcopp003";
    if ( "ancient gold dragon" == slName)
        return "nw_drggold003";
    if ( "ancient green dragon" == slName)
        return "nw_drggreen003";
    if ( "ancient red dragon" == slName)
        return "nw_drgred003";
    if ( "ancient silver dragon" == slName)
        return "nw_drgsilv003";
    if ( "ancient white dragon" == slName)
        return "nw_drgwhite003";
    if ( "old black dragon" == slName)
        return "nw_drgblack002";
    if ( "old blue dragon" == slName)
        return "nw_drgblue002";
    if ( "old brass dragon" == slName)
        return "nw_drgbrass002";
    if ( "old bronze dragon" == slName)
        return "nw_drgbrnz002";
    if ( "old copper dragon" == slName)
        return "nw_drgcopp002";
    if ( "old gold dragon" == slName)
        return "nw_drggold002";
    if ( "old green dragon" == slName)
        return "nw_drggreen002";
    if ( "old red dragon" == slName)
        return "nw_drgred002";
    if ( "old silver dragon" == slName)
        return "nw_drgsilv002";
    if ( "old white dragon" == slName)
        return "nw_drgwhite002";
    if ( "half-dragon cleric" == slName)
        return "nw_halfdra002";
    if ( "half-dragon sorcerer" == slName)
        return "nw_halfdra001";
    if ( "air elemental" == slName)
        return "nw_air";
    if ( "earth elemental" == slName)
        return "nw_earth";
    if ( "elder air elemental" == slName)
        return "nw_airelder";
    if ( "elder earth elemental" == slName)
        return "nw_eartheld";
    if ( "elder fire elemental" == slName)
        return "nw_fireelder";
    if ( "elder water elemental" == slName)
        return "nw_waterelder";
    if ( "fire elemental" == slName)
        return "nw_fire";
    if ( "greater  air elemental" == slName)
        return "nw_airgreat";
    if ( "greater earth elemental" == slName)
        return "nw_earthgreat";
    if ( "greater fire elemental" == slName)
        return "nw_firegreat";
    if ( "greater water elemental" == slName)
        return "nw_watergreat";
    if ( "huge air elemental" == slName)
        return "nw_airhuge";
    if ( "huge earth elemental" == slName)
        return "nw_earthhuge";
    if ( "huge fire elemental" == slName)
        return "nw_firehuge";
    if ( "huge water elemental" == slName)
        return "nw_waterhuge";
    if ( "invisible stalker" == slName)
        return "nw_invstalk";
    if ( "water elemental" == slName)
        return "nw_water";
    if ( "hill giant" == slName)
        return "nw_gnthill";
    if ( "mountain giant" == slName)
        return "nw_gntmount";
    if ( "troll shaman" == slName)
        return "nw_trollwiz";
    if ( "fire giant" == slName)
        return "nw_gntfire";
    if ( "frost giant" == slName)
        return "nw_gntfrost";
    if ( "ogre" == slName)
        return "nw_ogre01";
    if ( "ogre mage" == slName)
        return "nw_ogremage01";
    if ( "bugbear" == slName)
        return "nw_bugbeara";
    if ( "gnoll" == slName)
        return "nw_gnoll001";
    if ( "goblin" == slName)
        return "nw_goblina";
    if ( "kobold" == slName)
        return "nw_kobold001";
    if ( "yuan-ti" == slName)
        return "nw_yuan_ti001";
    if ( "lizardfolk warrior" == slName)
        return "nw_oldwarb";
    if ( "orc" == slName)
        return "nw_orca";
    if ( "bombardier beetle" == slName)
        return "nw_btlbomb";
    if ( "fire beetle" == slName)
        return "nw_btlfire";
    if ( "hive mother" == slName)
        return "nw_beetleboss";
    if ( "spitting fire beetle" == slName)
        return "nw_btlfire02";
    if ( "stag beetle" == slName)
        return "nw_btlstag";
    if ( "stink beetle" == slName)
        return "nw_btlstink";
    if ( "dire spider" == slName)
        return "nw_spiddire";
    if ( "giant spider" == slName)
        return "nw_spidgiant";
    if ( "phase spider" == slName)
        return "nw_spidphase";
    if ( "queen spider" == slName)
        return "nw_spiderboss";
    if ( "sword spider" == slName)
        return "nw_spidswrd";
    if ( "wraith spider" == slName)
        return "nw_spidwra";
    if ( "duergar" == slName)
        return "nw_duefight001";
    if ( "drow" == slName)
        return "nw_drowfight001";
    if ( "dwarf" == slName)
        return "nw_dwarfmerc002";
    if ( "elf" == slName)
        return "nw_elfmerc001";
    if ( "half-orc" == slName)
        return "nw_bandit006";
    if ( "halfling" == slName)
        return "nw_halfling005";
    if ( "human" == slName)
        return "nw_commale";
    if ( "battle devourer" == slName)
        return "nw_battdevour";
    if ( "gray render" == slName)
        return "nw_grayrend";
    if ( "hook horror" == slName)
        return "nw_horror";
    if ( "intellect devourer" == slName)
        return "nw_devour";
    if ( "umber hulk" == slName)
        return "nw_umberhulk";
    if ( "will-o'-wisp" == slName)
        return "nw_willowisp";
    if ( "celestial avenger" == slName)
        return "nw_ctrumpet";
    if ( "half-celestial warrior" == slName)
        return "nw_halfcel001";
    if ( "hound archon" == slName)
        return "nw_chound01";
    if ( "lantern archon" == slName)
        return "nw_clantern";
    if ( "trumpet archon" == slName)
        return "nw_ctrumpet";
    if ( "balor" == slName)
        return "nw_demon";
    if ( "half-fiend warrior" == slName)
        return "nw_halffnd001";
    if ( "hell hound" == slName)
        return "nw_hellhound";
    if ( "hound of xvim" == slName)
        return "nw_beastxvim";
    if ( "shadow mastiff" == slName)
        return "nw_shmastif";
    if ( "succubus" == slName)
        return "nw_dmsucubus";
    if ( "vrock" == slName)
        return "nw_dmvrock";
    if ( "air mephit" == slName)
        return "nw_mepair";
    if ( "dust mephit" == slName)
        return "nw_mepdust";
    if ( "earth mephit" == slName)
        return "nw_mepearth";
    if ( "fire mephit" == slName)
        return "nw_mepfire";
    if ( "ice mephit" == slName)
        return "nw_mepice";
    if ( "magma mephit" == slName)
        return "nw_mepmagma";
    if ( "ooze mephit" == slName)
        return "nw_mepooze";
    if ( "quasit" == slName)
        return "nw_dmquasit";
    if ( "salt mephit" == slName)
        return "nw_mepsalt";
    if ( "steam mephit" == slName)
        return "nw_mepsteam";
    if ( "water mephit" == slName)
        return "nw_mepwater";
    if ( "blink dog" == slName)
        return "nw_blinkdog";
    if ( "fenhound" == slName)
        return "nw_fenhound";
    if ( "tiefling" == slName)
        return "nw_tiefling02";
    if ( "blue slaad" == slName)
        return "nw_slaadbl";
    if ( "death slaad" == slName)
        return "nw_slaaddeth";
    if ( "gray slaad" == slName)
        return "nw_slaadgray";
    if ( "green slaad" == slName)
        return "nw_slaadgrn";
    if ( "red slaad" == slName)
        return "nw_slaadred";
    if ( "baelnorn" == slName)
        return "nw_lich002";
    if ( "doom knight" == slName)
        return "nw_doomkght";
    if ( "lich" == slName)
        return "nw_lich003";
    if ( "revenant" == slName)
        return "nw_revenant001";
    if ( "skeletal devourer" == slName)
        return "nw_skeldevour";
    if ( "vampiric mist" == slName)
        return "nw_mistvamp";
    if ( "shadow fiend" == slName)
        return "nw_shfiend";
    if ( "tyrantfog zombie" == slName)
        return "nw_zombtyrant";
    if ( "zombie" == slName)
        return "nw_zombie01";

    // SoU critters
    if ( "pseudo dragon" == slName)
        return "x0_dragon_pseudo";
    if ( "wyrmling black dragon" == slName)
        return "x0_wyrmling_blk";
    if ( "wyrmling blue dragon" == slName)
        return "x0_wyrmling_blu";
    if ( "wyrmling brass dragon" == slName)
        return "x0_wyrmling_brs";
    if ( "wyrmling bronze dragon" == slName)
        return "x0_wyrmling_brz";
    if ( "wyrmling copper dragon" == slName)
        return "x0_wyrmling_cop";
    if ( "wyrmling gold dragon" == slName)
        return "x0_wyrmling_gld";
    if ( "wyrmling green dragon" == slName)
        return "x0_wyrmling_grn";
    if ( "wyrmling red dragon" == slName)
        return "x0_wyrmling_red";
    if ( "wyrmling silver dragon" == slName)
        return "x0_wyrmling_sil";
    if ( "wyrmling white dragon" == slName)
        return "x0_wyrmling_wht";
    if ( "faerie dragon" == slName)
        return "x0_dragon_faerie";
    if ( "asabi" == slName)
        return "x0_asabi_warrior";
    if ( "medusa" == slName)
        return "x0_medusa";
    if ( "stinger" == slName)
        return "x0_stinger";
    if ( "sphinx" == slName)
        return "x0_sphinx";
    if ( "andro sphinx" == slName)
        return "x0_sphinx";
    if ( "basilisk" == slName)
        return "x0_basilisk";
    if ( "cockatrice" == slName)
        return "x0_cockatrice";
    if ( "gorgon" == slName)
        return "x0_gorgon";
    if ( "gyno sphinx" == slName)
        return "x0_gynosphinx";
    if ( "manticore" == slName)
        return "x0_manticore";
    if ( "formian queen" == slName)
        return "x0_form_queen";
    if ( "formian" == slName)
        return "x0_form_warrior";

    // HotU critters
    if ( "beholder" == slName)
        return "x2_beholder001";
    if ( "beholder mage" == slName)
        return "x2_beholder003";
    if ( "drider" == slName)
        return "x2_drider001";
    if ( "eyeball " == slName)
        return "x2_beholder002";
    if ( "mindflayer" == slName)
        return "x2_mindflayer001";
    if ( "ulitharid" == slName)
        return "x2_mindflayer002";
    if ( "adamantine golem" == slName)
        return "x2_golem002";
    if ( "demonflesh golem" == slName)
        return "nw_goldmflesh001";
    if ( "mithral golem" == slName)
        return "x2_golem001";
    if ( "prismatic dragon" == slName)
        return "x2_dragonpris001";
    if ( "ancient shadow dragon" == slName)
        return "x2_dragonshad001";
    if ( "deep rothe" == slName)
        return "x2_deeprothe001";
    if ( "gelatinous cube" == slName)
        return "x2_gelcube";
    if ( "harpy" == slName)
        return "x2_harpy001";
    if ( "bebilith" == slName)
        return "x2_spiderdemo001";
    if ( "erinyes" == slName)
        return "x2_erinyes";
    if ( "pit fiend" == slName)
        return "x2_pitfiend001";
    if ( "azer" == slName)
        return "x2_azer001";
    if ( "black slaad" == slName)
        return "x2_slaadblack001";
    if ( "white slaad" == slName)
        return "x2_slaadwhite001";
    if ( "demilich" == slName)
        return "x2_demilich001";
    if ( "dracolich" == slName)
        return "x2_dracolich001";

    // Add in larger creatures of the same type because of the small
    // amount of creatures in NWN vs PNP (violates PnP rules)
    if ( "ogre berserker" == slName)
        return "nw_ogrechief01";
    if ( "ogre chieftain" == slName)
        return "nw_ogreboss";
    if ( "ogre high mage" == slName)
        return "nw_ogremageboss";
    if ( "troll berserker" == slName)
        return "nw_trollchief";
    if ( "troll chieftain" == slName)
        return "nw_trollboss";
    if ( "bugbear hero" == slName)
        return "nw_trollboss";
    if ( "bugbear chieftain" == slName)
        return "nw_bugbearboss";
    if ( "bugbear hero" == slName)
        return "nw_bugchiefa";
    if ( "bugbear shaman" == slName)
        return "nw_bugwiza";
    if ( "goblin chieftain" == slName)
        return "nw_goblinboss";
    if ( "goblin elite" == slName)
        return "nw_gobchiefa";
    if ( "asabi chieftain" == slName)
        return "x0_asabi_chief";
    if ( "yuan-ti priest" == slName)
        return "nw_yuan_ti003";
    if ( "minotaur berserker" == slName)
        return "nw_minchief";
    if ( "minotaur chieftain" == slName)
        return "nw_minotaurboss";
    if ( "minotaur shaman" == slName)
        return "nw_minwiz";
    if ( "stinger chieftain" == slName)
        return "x0_stinger_chief";
    if ( "formian myrmarch" == slName)
        return "x0_form_myrmarch";
    if ( "ghoul lord" == slName)
        return "nw_ghoullord";
    if ( "greater mummy" == slName)
        return "nw_mumcleric";
    if ( "mummy lord" == slName)
        return "nw_mummyboss";
    if ( "doom knight commander" == slName)
        return "nw_doomkghtboss";
    if ( "vampire mage" == slName)
        return "nw_vampire003";
    if ( "vampire priest" == slName)
        return "nw_vampire004";
    if ( "vampire rogue" == slName)
        return "nw_vampire002";
    if ( "vampire warrior" == slName)
        return "nw_vampire001";
    if ( "skeleton chieftain" == slName)
        return "nw_skelchief";
    if ( "zombie lord" == slName)
        return "nw_zombieboss";
    if ( "huge iron golem" == slName)
        return "x2_goliron_huge";

    // If all else fails try this
    sDefaultName = "nw_" + slName;
    return sDefaultName;
}
// Determines if the oCreature is harmless enough to have
// special effects applied to the shifter
// Return values: TRUE or FALSE
int GetIsCreatureHarmless(object oCreature)
{
    string sCreatureName = GetName(oCreature);

    // looking for small < 1 CR creatures that nobody looks at twice

    if ((sCreatureName == "Chicken") ||
        (sCreatureName == "Falcon") ||
        (sCreatureName == "Hawk") ||
        (sCreatureName == "Raven") ||
        (sCreatureName == "Bat") ||
        (sCreatureName == "Dire Rat") ||
        (sCreatureName == "Will-O'-Wisp") ||
        (sCreatureName == "Rat") ||
        (GetChallengeRating(oCreature) < 1.0 ))
        return TRUE;
    else
        return FALSE;
}

int GetTrueForm(object oPC)
{
    int nRace = GetRacialType(OBJECT_SELF);
    int nPCForm;
    switch (nRace)
    {
    case RACIAL_TYPE_DWARF:
        nPCForm = APPEARANCE_TYPE_DWARF;
        break;
    case RACIAL_TYPE_ELF:
        nPCForm = APPEARANCE_TYPE_ELF;
        break;
    case RACIAL_TYPE_GNOME:
        nPCForm = APPEARANCE_TYPE_GNOME;
        break;
    case RACIAL_TYPE_HALFELF:
        nPCForm = APPEARANCE_TYPE_HALF_ELF;
        break;
    case RACIAL_TYPE_HALFLING:
        nPCForm = APPEARANCE_TYPE_HALFLING;
        break;
    case RACIAL_TYPE_HALFORC:
        nPCForm = APPEARANCE_TYPE_HALF_ORC;
        break;
    case RACIAL_TYPE_HUMAN:
        nPCForm = APPEARANCE_TYPE_HUMAN;
        break;
    }
    return nPCForm;
}

// Transforms the oPC into the oTarget
// Assumes oTarget is already a valid target
int SetShift(object oPC, object oTarget)
{
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oTarget);
    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oTarget);
    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oTarget);

    // Generate an effect to modify the number attacks based on the number of creature weapons
/*    int nNumAttacks = 0;
    if (GetIsObjectValid(oWeapCR))
        nNumAttacks++;
    if (GetIsObjectValid(oWeapCL))
        nNumAttacks++;
    if (GetIsObjectValid(oWeapCB))
        nNumAttacks++;

    if (nNumAttacks)
    {
        effect eNumAttacks = EffectModifyAttacks(nNumAttacks);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eNumAttacks),oPC);
    }
*/ //does not seem to work as we want it, it gives to many attacks

    // Force the PC to equip the creature items if the PC does not have one
    object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    object oWeapCRPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeapCLPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeapCBPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);

    // Determine if the pc is already shifted
    // This info is saved to the hide, so if they dont have a hide they are not shifted
    if (GetIsObjectValid(oHidePC))
    {
        // Cant shift to something else while shifted
        if (GetLocalInt(oHidePC,"nPCShifted"))
        {
            SendMessageToPC(oPC,"You need to revert back to your original form before you can shift again");
            return FALSE;
        }
    }


    if (!GetIsObjectValid(oHidePC))
    {
        oHidePC = CopyObject(oHide,GetLocation(oPC),oPC);
        // Some NPCs dont have hides, create a generic on on the pc
        if (!GetIsObjectValid(oHidePC))
        {
            oHidePC = CreateItemOnObject("shifterhide",oPC);
        }
        // Need to ID the stuff before we can put it on the PC
        SetIdentified(oHidePC,TRUE);
        AssignCommand(oPC,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR));
    }
    else // apply the hide effects to the PCs hide
    {
        CopyAllItemProperties(oHidePC,oHide);
    }

    // Need to save off the PC original appearance to the hide
    // local variables save off to items and are permanent!
    if (!GetLocalInt(oHidePC,"nPCTrueFormType"))
        SetLocalInt(oHidePC,"nPCTrueFormType",GetAppearanceType(oPC));

    if (!GetIsObjectValid(oWeapCRPC))
    {
        oWeapCRPC = CopyObject(oWeapCR,GetLocation(oPC),oPC);
        SetIdentified(oWeapCRPC,TRUE);
        AssignCommand(oPC,ActionEquipItem(oWeapCRPC,INVENTORY_SLOT_CWEAPON_R));
    }
    else // apply effects to the item
    {
        CopyAllItemProperties(oWeapCRPC,oWeapCR);
    }
    if (!GetIsObjectValid(oWeapCLPC))
    {
        oWeapCLPC = CopyObject(oWeapCL,GetLocation(oPC),oPC);
        SetIdentified(oWeapCLPC,TRUE);
        AssignCommand(oPC,ActionEquipItem(oWeapCLPC,INVENTORY_SLOT_CWEAPON_L));
    }
    else // apply effects to the item
    {
        CopyAllItemProperties(oWeapCLPC,oWeapCL);
    }
    if (!GetIsObjectValid(oWeapCBPC))
    {
        oWeapCBPC = CopyObject(oWeapCB,GetLocation(oPC),oPC);
        SetIdentified(oWeapCBPC,TRUE);
        AssignCommand(oPC,ActionEquipItem(oWeapCBPC,INVENTORY_SLOT_CWEAPON_B));
    }
    else // apply effects to the item
    {
        CopyAllItemProperties(oWeapCBPC,oWeapCB);
    }

    // Get any ability bonuses from effects (spells etc)
    // we must remove all effects that boost str,con,and dex because
    // we cannot determine the boost to the attrib
    effect eEff = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEff))
    {
        int nEType = GetEffectType(eEff);
        if (nEType == EFFECT_TYPE_ABILITY_DECREASE ||
            nEType == EFFECT_TYPE_ABILITY_INCREASE)
            RemoveEffect(oPC,eEff);
        eEff = GetNextEffect(oPC);
    }

    // Get the Targets str, dex, and con
    int nTStr = GetAbilityScore(oTarget,ABILITY_STRENGTH);
    int nTDex = GetAbilityScore(oTarget,ABILITY_DEXTERITY);
    int nTCon = GetAbilityScore(oTarget,ABILITY_CONSTITUTION);

    //SendMessageToPC(oPC,"target Str,dex,con" + IntToString(nTStr) + "," + IntToString(nTDex) + "," + IntToString(nTCon));

    // Find the PC values
    int nPCStr = GetAbilityScore(oPC,ABILITY_STRENGTH);
    int nPCDex = GetAbilityScore(oPC,ABILITY_DEXTERITY);
    int nPCCon = GetAbilityScore(oPC,ABILITY_CONSTITUTION);

    //SendMessageToPC(oPC,"Pc Str,dex,con" + IntToString(nPCStr) + "," + IntToString(nPCDex) + "," + IntToString(nPCCon));

    // Get any ability bonuses from equipment and subtract them from the PCs
    nPCStr -= GetAllItemsAbilityModifier(oPC,IP_CONST_ABILITY_STR);
    nPCDex -= GetAllItemsAbilityModifier(oPC,IP_CONST_ABILITY_DEX);
    nPCCon -= GetAllItemsAbilityModifier(oPC,IP_CONST_ABILITY_CON);

    //SendMessageToPC(oPC,"No equip Str,dex,con" + IntToString(nPCStr) + "," + IntToString(nPCDex) + "," + IntToString(nPCCon));

    // Get the deltas
    int nStrDelta = nTStr - nPCStr;
    int nDexDelta = nTDex - nPCDex;
    int nConDelta = nTCon - nPCCon;

    //SendMessageToPC(oPC,"delta Str,dex,con" + IntToString(nStrDelta) + "," + IntToString(nDexDelta) + "," + IntToString(nConDelta));

    // Cap max to +12 til they can fix it and -10 for the low value
    if (nStrDelta > 12)
        nStrDelta = 12;
    if (nStrDelta < -10)
        nStrDelta = -10;
    if (nDexDelta > 12)
        nDexDelta = 12;
    if (nDexDelta < -10)
        nDexDelta = -10;
    if (nConDelta > 12)
        nConDelta = 12;
    if (nConDelta < -10)
        nConDelta = -10;

    // Big problem with <0 to abilities, if they have immunity to ability drain
    // the - to the ability wont do anything

    // Apply these boni to the creature hide
    if (nStrDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,nStrDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR,nStrDelta*-1),oHidePC);
    if (nDexDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,nDexDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_DEX,nDexDelta*-1),oHidePC);
    if (nConDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,nConDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON,nConDelta*-1),oHidePC);


    // Apply the natural AC bonus to the hide
    // First get the AC from the target
    int nTAC = GetAC(oTarget);
    nTAC -= GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
    // All creatures have 10 base AC
    nTAC -= 10;
    int i;
    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        nTAC -= GetItemACValue(GetItemInSlot(i,oTarget));
    }

    if (nTAC > 0)
    {
        if (nTAC > 20)
        {
            // Have to use an effect for ACs above 20
            effect eAC = EffectACIncrease(nTAC,AC_NATURAL_BONUS);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eAC),oPC);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(nTAC),oHidePC);
        }
    }

    // Remove equipment that can't be worn while shifted
/*    object oItem;
    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        if (!GetCanFormEquip(oTarget,i))
        {
            oItem = GetItemInSlot(i,oPC);
            AssignCommand(oPC,ActionUnequipItem(oItem));
        }
    }
*/
    // Apply any feats the target has to the hide as a bonus feat
    for (i = 0; i< 500; i++)
    {
        if (GetHasFeat(i,oTarget))
        {
            int nIP =  GetIPFeatFromFeat(i);
            if(nIP != -1)
            {
                itemproperty iProp = ItemPropertyBonusFeat(nIP);
                AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oHidePC);
            }

        }
    }
    // If they dont have the natural spell feat they can only cast spells in certain shapes
    if (!GetHasFeat(FEAT_PRESTIGE_SHIFTER_NATURALSPELL,oPC))
    {
        if (!GetCanFormCast(oTarget))
        {
            // remove the ability from the PC to cast
            effect eNoCast = EffectSpellFailure();
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eNoCast),oPC);
        }
    }

    // If the creature is "harmless" give it a perm invis for stealth
    if(GetIsCreatureHarmless(oTarget))
    {
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eInvis),oPC);
    }


    // Change the Appearance of the PC
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_IMP_POLYMORPH),
                        oPC);

    SetCreatureAppearanceType(oPC,GetAppearanceType(oTarget));

    // PnP rules say the shifter would heal as if they rested
    effect eHeal = EffectHeal(GetHitDice(oPC)*d4());
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oPC);

    // Set a flag on the PC to tell us that they are shifted
    SetLocalInt(oHidePC,"nPCShifted",TRUE);

    return TRUE;
}

// Transforms the oPC into the oTarget using the epic rules
// Assumes oTarget is already a valid target
int SetShiftEpic(object oPC, object oTarget)
{

    if (SetShift(oPC, oTarget))
    {
        // Create some sort of usable item to represent monster spells
        object oEpicPowersItem = GetItemPossessedBy(oPC,"EpicShifterPowers");
        if (!GetIsObjectValid(oEpicPowersItem))
            oEpicPowersItem = CreateItemOnObject("epicshifterpower",oPC);
        SetItemSpellPowers(oEpicPowersItem,oTarget);
        return TRUE;
    }
    return FALSE;
}

// Creates a temporary creature for the shifter to shift into
// Return values: TRUE or FALSE
int SetShiftFromTemplate(object oPC, string sTemplate)
{
    // Create the obj from the template
    object oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,GetLocation(oPC));

    // Shift the PC to it
    int bRetValue = SetShift(oPC,oTarget);

    // Remove the temporary creature
    DestroyObject(oTarget);

    return bRetValue;
}

// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
int SetShiftFromTemplateValidate(object oPC, string sTemplate)
{
    int bRetValue = FALSE;
    int in_list = IsKnownCreature( oPC, sTemplate );

    // Create the obj from the template
    object oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,GetLocation(oPC));

    if (!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oPC,"Not a valid creature");
    }
    if ( !in_list )
    {
        SendMessageToPC( oPC, "You have not mimiced this creature yet" );
    }

    // Make sure the PC can take on that form
    if (GetValidShift(oPC, oTarget) && in_list )
    {
        // Shift the PC to it
        bRetValue = SetShift(oPC,oTarget);
    }

    // Remove the temporary creature
    DestroyObject(oTarget);

    return bRetValue;
}

// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
int SetShiftEpicFromTemplateValidate(object oPC, string sTemplate)
{
    int bRetValue = FALSE;
    int in_list = IsKnownCreature( oPC, sTemplate );

    // Create the obj from the template
    object oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,GetLocation(oPC));

    if (!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oPC,"Not a valid creature");
    }
    if ( !in_list )
    {
        SendMessageToPC( oPC, "You have not mimiced this creature yet" );
    }

    // Make sure the PC can take on that form
    if (GetValidShift(oPC, oTarget) && in_list )
    {
        // Shift the PC to it
        bRetValue = SetShiftEpic(oPC,oTarget);
    }

    // Remove the temporary creature
    DestroyObject(oTarget);

    return bRetValue;
}

// Transforms the oPC back to thier true form if they are shifted
int SetShiftTrueForm(object oPC)
{
    // Remove all the creature equipment and destroy it
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);

    // Do not move or destroy the objects, it will crash the game
    if (GetIsObjectValid(oHide))
    {
        // Remove all the abilities of the object
        RemoveAllItemProperties(oHide);
    }
    if (GetIsObjectValid(oWeapCR))
    {
        // Remove all the abilities of the object
        RemoveAllItemProperties(oWeapCR);
    }
    if (GetIsObjectValid(oWeapCL))
    {
        // Remove all the abilities of the object
        RemoveAllItemProperties(oWeapCL);
    }
    if (GetIsObjectValid(oWeapCB))
    {
        // Remove all the abilities of the object
        RemoveAllItemProperties(oWeapCB);
    }
    // if the did an epic form remove the special powers
    object oEpicPowersItem = GetItemPossessedBy(oPC,"EpicShifterPowers");
    if (GetIsObjectValid(oEpicPowersItem))
    {
        RemoveAllItemProperties(oEpicPowersItem);
        RemoveAuraEffect( oPC );
    }


    // Spell failure can only be done through an effect
    // AC > 20 can only be done via an effect
    // Number of attacks have been modified (this has no effect type to look for)
    // so we must remove anything that is perm and supernatural
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
        int eDurType = GetEffectDurationType(eEff);
        int eSubType = GetEffectSubType(eEff);
        if ((eDurType == DURATION_TYPE_PERMANENT) &&
            (eSubType == SUBTYPE_SUPERNATURAL) )
        {
            RemoveEffect(oPC,eEff);
        }
        eEff = GetNextEffect(oPC);
    }

    // Change the PC back to TRUE form
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_IMP_POLYMORPH),
                        oPC);

    SetCreatureAppearanceType(oPC,GetTrueForm(oPC));


    SetLocalInt(oHide,"nPCShifted",FALSE);
    return TRUE;
}

