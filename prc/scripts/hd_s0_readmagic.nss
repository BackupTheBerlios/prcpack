//:://////////////////////////////////////////////
//:: Read (Item Ability)
//:: HD_S3_Read
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*
Attempt to read an item.  Part of Hierarchical
Design's Item Creation Feats System

The target can be a recipe or a magic item
*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: November 12, 2003
//:://////////////////////////////////////////////

#include "HD_I0_ITEMCREAT"

void main()
{
    object oItem = GetSpellTargetObject();
    string sTargetTag = GetTag(oItem);
    // Run a check to see if the char is capable of comprehending the recipe item.
    // This should prolly be a Spellcraft check of some sort...
    // Display the Recipe to reader's screen.
    struct ireqreport iReport = CheckIReqs(sTargetTag, TRUE, FALSE);
    if (iReport.baseitemtype == BASE_ITEM_INVALID)
    {

        {SendMessageToPC(OBJECT_SELF, "Trying to make a recipe");}
        // Try to make a recipe for the item
        if (!CreateRecipeFromItem(oItem,OBJECT_SELF))
            {SendMessageToPC(OBJECT_SELF, "You can discern nothing from this.");}
    }
}
