//:://////////////////////////////////////////////
//:: Include File for Item Creation Feats
//:: HD_I0_ItemCreat
//:: Copyright (c) 2003 Gerald Leung.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Gerald Leung
//:: Created On: November 12, 2003
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"
// Color text tags only compile using nwnnsscomp

//:://////////////////////////////////////////////
// BEGIN - Configuration Section

const string sSecureBox      = "HEARTOFCHAOS";   // temporary box
object oTempContainer        = GetObjectByTag(sSecureBox);
// Tag of temporary locker box to store items as they are briefly created
// so their names and other data can be gotten off them, and then annihilated.
// This is a placeable with an inventory and should be placed in a SECURE
// location.  My personal box is an unopenable chest with max stats in an
// area named "Limbo" that's off-limits to players.  I'll prolly have to
// change that someday if I get around to implementing different planes.
// Anyone looking into the chest should occasionally see items that pop in
// and out of existence.  Even if they were stolen though, the routines
// should destroy them wherever they go so..  I suppose having the items
// spawn then be destroyed out in the visible open would be a cool effect,
// but for now..

// Categorization of BaseItemTypes..
// For creators of custom baseitemtypes, add them here.

int IsScroll(int nBaseItemType)
{
    if ((nBaseItemType == BASE_ITEM_SCROLL) ||
        (BASE_ITEM_SPELLSCROLL))
        {return TRUE;}
    else
        {return FALSE;}
}

int IsPotion(int nBaseItemType)
{
    if (nBaseItemType == BASE_ITEM_POTIONS)
        {return TRUE;}
    else
        {return FALSE;}
}

int IsWand(int nBaseItemType)
{
    if (nBaseItemType == BASE_ITEM_MAGICWAND)
        {return TRUE;}
    else
        {return FALSE;}
}

int IsWondrousItem(int nBaseItemType)
{
    if ((nBaseItemType == BASE_ITEM_TORCH) ||
        (nBaseItemType == BASE_ITEM_HELMET) ||
        (nBaseItemType == BASE_ITEM_AMULET) ||
        (nBaseItemType == BASE_ITEM_BELT) ||
        (nBaseItemType == BASE_ITEM_MISCSMALL)  ||
        (nBaseItemType == BASE_ITEM_BOOTS) ||
        (nBaseItemType == BASE_ITEM_MISCMEDIUM) ||
        (nBaseItemType == BASE_ITEM_MISCLARGE) ||
        (nBaseItemType == BASE_ITEM_GLOVES) ||
        (nBaseItemType == BASE_ITEM_HEALERSKIT) ||
        (nBaseItemType == BASE_ITEM_MISCTALL) ||
        (nBaseItemType == BASE_ITEM_THIEVESTOOLS) ||
        (nBaseItemType == BASE_ITEM_TRAPKIT) ||
        (nBaseItemType == BASE_ITEM_KEY) ||
        (nBaseItemType == BASE_ITEM_LARGEBOX) ||
        (nBaseItemType == BASE_ITEM_MISCWIDE) ||
        (nBaseItemType == BASE_ITEM_BOOK) ||
        (nBaseItemType == BASE_ITEM_GEM) ||
        (nBaseItemType == BASE_ITEM_BRACER) ||
        (nBaseItemType == BASE_ITEM_MISCTHIN) ||
        (nBaseItemType == BASE_ITEM_CLOAK))
        {return TRUE;}
    else
        {return FALSE;}
}

int IsMagicArmOrArmor(int nBaseItemType)
{
    if ((nBaseItemType == BASE_ITEM_ARMOR) ||
        (nBaseItemType == BASE_ITEM_SHORTSWORD) ||
        (nBaseItemType == BASE_ITEM_LONGSWORD) ||
        (nBaseItemType == BASE_ITEM_BATTLEAXE) ||
        (nBaseItemType == BASE_ITEM_BASTARDSWORD) ||
        (nBaseItemType == BASE_ITEM_LIGHTFLAIL) ||
        (nBaseItemType == BASE_ITEM_WARHAMMER) ||
        (nBaseItemType == BASE_ITEM_HEAVYCROSSBOW) ||
        (nBaseItemType == BASE_ITEM_LIGHTCROSSBOW) ||
        (nBaseItemType == BASE_ITEM_LONGBOW) ||
        (nBaseItemType == BASE_ITEM_LIGHTMACE) ||
        (nBaseItemType == BASE_ITEM_HALBERD) ||
        (nBaseItemType == BASE_ITEM_SHORTBOW) ||
        (nBaseItemType == BASE_ITEM_TWOBLADEDSWORD) ||
        (nBaseItemType == BASE_ITEM_GREATSWORD) ||
        (nBaseItemType == BASE_ITEM_SMALLSHIELD) ||
        (nBaseItemType == BASE_ITEM_GREATAXE) ||
        (nBaseItemType == BASE_ITEM_ARROW) ||
        (nBaseItemType == BASE_ITEM_DAGGER) ||
        (nBaseItemType == BASE_ITEM_BOLT) ||
        (nBaseItemType == BASE_ITEM_BULLET) ||
        (nBaseItemType == BASE_ITEM_CLUB) ||
        (nBaseItemType == BASE_ITEM_DART) ||
        (nBaseItemType == BASE_ITEM_DIREMACE) ||
        (nBaseItemType == BASE_ITEM_DOUBLEAXE) ||
        (nBaseItemType == BASE_ITEM_HEAVYFLAIL) ||
        (nBaseItemType == BASE_ITEM_LIGHTHAMMER) ||
        (nBaseItemType == BASE_ITEM_HANDAXE) ||
        (nBaseItemType == BASE_ITEM_KAMA) ||
        (nBaseItemType == BASE_ITEM_KATANA) ||
        (nBaseItemType == BASE_ITEM_KUKRI) ||
        (nBaseItemType == BASE_ITEM_MORNINGSTAR) ||
        (nBaseItemType == BASE_ITEM_QUARTERSTAFF) ||
        (nBaseItemType == BASE_ITEM_RAPIER) ||
        (nBaseItemType == BASE_ITEM_SCIMITAR) ||
        (nBaseItemType == BASE_ITEM_SCYTHE) ||
        (nBaseItemType == BASE_ITEM_LARGESHIELD) ||
        (nBaseItemType == BASE_ITEM_TOWERSHIELD) ||
        (nBaseItemType == BASE_ITEM_SHORTSPEAR) ||
        (nBaseItemType == BASE_ITEM_SHURIKEN) ||
        (nBaseItemType == BASE_ITEM_SICKLE) ||
        (nBaseItemType == BASE_ITEM_SLING) ||
        (nBaseItemType == BASE_ITEM_THROWINGAXE) ||
        (nBaseItemType == BASE_ITEM_DWARVENWARAXE) ||
        (nBaseItemType == BASE_ITEM_WHIP))
        {return TRUE;}
    else
        {return FALSE;}
}

int IsRod(int nBaseItemType)
{
    if (nBaseItemType == BASE_ITEM_MAGICROD)
        {return TRUE;}
    else
        {return FALSE;}
}

int IsStaff(int nBaseItemType)
{
    if (nBaseItemType == BASE_ITEM_MAGICSTAFF)
        {return TRUE;}
    else
        {return FALSE;}
}

int IsRing(int nBaseItemType)
{
    if (nBaseItemType == BASE_ITEM_RING)
        {return TRUE;}
    else
        {return FALSE;}
}

int IsRune(int nBaseItemType)
{return FALSE;}

int IsPortal(int nBaseItemType)
{return FALSE;}

// What is the highest level that the Creature has in a spellcasting class?
// What are all the spellcasting classes?
int hdGetCasterLevel(object oCreature = OBJECT_SELF)
{
    int nDivCasterLevel = 0;
    int nArcCasterLevel = 0;

    // Get levels in all their caster classes
    int nClericLevels = GetLevelByClass(CLASS_TYPE_CLERIC, oCreature);
    if (nClericLevels > nDivCasterLevel)
        {nDivCasterLevel = nClericLevels;}

    int nDruidLevels = GetLevelByClass(CLASS_TYPE_DRUID, oCreature);
    if (nDruidLevels > nDivCasterLevel)
        {nDivCasterLevel = nDruidLevels;}

    int nWizardLevels = GetLevelByClass(CLASS_TYPE_WIZARD, oCreature);
    if (nWizardLevels > nArcCasterLevel)
        {nArcCasterLevel = nWizardLevels;}

    int nSorcererLevels = GetLevelByClass(CLASS_TYPE_SORCERER, oCreature);
    if (nSorcererLevels > nArcCasterLevel)
        {nArcCasterLevel = nSorcererLevels;}

    int nBardLevels = GetLevelByClass(CLASS_TYPE_BARD, oCreature);
    if (nBardLevels > nArcCasterLevel)
        {nArcCasterLevel = nBardLevels;}

    int nPaladinLevels = GetLevelByClass(CLASS_TYPE_PALADIN, oCreature);
    int nRangerLevels = GetLevelByClass(CLASS_TYPE_RANGER, oCreature);
    // Halve class levels for Paladin and Ranger (with floor of class level 4)
    // to get the caster level for them.
    if (nPaladinLevels < 4)
        {nPaladinLevels = 0;}
    else
        {nPaladinLevels = nPaladinLevels >>> 1;}
    if (nPaladinLevels > nDivCasterLevel)
        {nDivCasterLevel = nPaladinLevels;}

    if (nRangerLevels < 4)
        {nRangerLevels = 0;}
    else
        {nRangerLevels = nRangerLevels >>> 1;}
    if (nRangerLevels > nDivCasterLevel)
        {nDivCasterLevel = nRangerLevels;}

    if (nDivCasterLevel > nArcCasterLevel)
        {return nDivCasterLevel;}
    else
        {return nArcCasterLevel;}

}
/*
// What is the highest level that the Creature has in a spellcasting class?
// What are all the spellcasting classes?
int hdGetCasterLevel(object oCreature = OBJECT_SELF)
{
    int nClass, nClassPosition;
    int nCasterLevel = 0;
    int nFirstArcaneClassLevel = 0;
    int nFirstDivineClassLevel = 0;
    int nFirstArcaneClass, nFirstDivineClass;
    for (nClassPosition = 1; nClassPosition <= 3; nClassPosition++)
    {
        // is this a caster class?
        nClass = GetClassByPosition(nClassPosition);
        if (IsArcane(nClass))
        {
            if (nFirstArcaneClassLevel == 0)
                {
                    nFirstArcaneClass = nClass;
                    nFirstArcaneClassLevel = GetLevelByPosition(nClassPosition);
                }
        }
        // is this a prestige class with +1 casterlevel?
    }
    // is this a halfsies class? (Paladin, Ranger)
}
*/
int IsArcane(int nClass)
{
    if ((nClass == CLASS_TYPE_WIZARD) ||
        (nClass == CLASS_TYPE_SORCERER) ||
        (nClass == CLASS_TYPE_BARD))
        {return TRUE;}
    else
        {return FALSE;}
}

int IsDivine(int nClass)
{
    if ((nClass == CLASS_TYPE_CLERIC) ||
        (nClass == CLASS_TYPE_DRUID) ||
        (nClass == CLASS_TYPE_PALADIN) ||
        (nClass == CLASS_TYPE_RANGER))
        {return TRUE;}
    else
        {return FALSE;}
}

// END - Configuration Section Parameters
//:://////////////////////////////////////////////


// SPECIFICATIONS - Declare our routines
// Reading

// Read the "recipe" item and display the item requirements.
struct ireqreport CheckIReqs(string sIReqTable, int nDisplay=TRUE, int nConsumeIReqs=FALSE);

// Get name of feat.
string GetFeatName(int nFeatID);

// Get name of spell.
string GetSpellName(int nSpellID);

// Get name of skill.
string GetSkillName(int nSkillID);

// Get name of race.
string GetRacialTypeName(int nRacialTypeID);

// Get name of class.
string GetClassName(int nClassID);

// Does oTarget have any items by Tag?
int HasItemByResRef(object oTarget, string sItemResRef);

// Get Alignment of the oTarget
string GetAlign(object oTarget=OBJECT_SELF);

// Get oTarget's free XP (extra XP beyond those used for char levels)
int GetAvailXP(object oTarget=OBJECT_SELF);

// Item Creation Process
struct itemcreationprocess
{
    string result;
    int marketprice;
    int lasttimestamp;
    float completeddays;
};

// Local itemcreationprocess functions
// Set a process as a local variable
void SetLocalItemCreationProcess(object oObject, string sVarName, struct itemcreationprocess pProcess);

// Get a process as a local variable
struct itemcreationprocess GetLocalItemCreationProcess(object oObject, string sVarName);

// Delete an item creation process stored in the campaign db.
void DeleteLocalItemCreationProcess(object oObject, string sVarName);

// Campaign itemcreationprocess functions
// Set a process in the campaign database
void SetCampaignItemCreationProcess(string sCampaignName, string sVarName, struct itemcreationprocess pProcess, object oPlayer=OBJECT_INVALID);

// Get a process in the campaign database
struct itemcreationprocess GetCampaignItemCreationProcess(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Delete a process in the campaign database
void DeleteCampaignItemCreationProcess(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Crafting
// Function for reading in an item's requirements.
// The recipe tag MUST be exactly the same as the filename of the IReqTable 2DA.
// example: If "ireq_mring023" is the tag of the recipe item then
// the ireq table must be "ireq_mring023.2da".  I use the convention of "ireq_" to
// maintain the readability of the ireqs 2DAs along with all the other 2DAs.

// Function for displaying an item's requirements for the Tome Reading ability

// IMPLEMENTATIONS

// ReqTypes allowed in ireq tables..
const string sReqTypeResult       = "RESULT";         // min
const string sReqTypeCasterLevel  = "CASTERLVL";      // min
const string sReqTypeExtraXP      = "EXTRAXP";        // min
const string sReqTypeExtraGold    = "EXTRAGOLD";      // min Increases XP cost as well

const string sReqTypeFeat         = "FEAT";           // and
const string sReqTypeSpell        = "SPELL";          // and
const string sReqTypeItem         = "ITEM";           // and
const string sReqTypeSkill        = "SKILL";          // and
const string sReqTypeLevel        = "LEVEL";          // and

const string sReqTypeRace         = "RACE";           // or
const string sReqTypeAlign        = "ALIGN";          // or
const string sReqTypeArea         = "AREA";           // or
const string sReqTypeDeity        = "DEITY";          // or

const string sReqTypeFeatOR       = "FEATOR";         // or
const string sReqTypeSpellOR      = "SPELLOR";        // or
const string sReqTypeItemOR       = "ITEMOR";         // or
const string sReqTypeSkillOR      = "SKILLOR";        // or
const string sReqTypeLevelOR      = "LEVELOR";        // or

// StrRefs for the above, borrowed from mapfile.ini (hehehe) and
// general searching of the base talktable...
const int STRREF_CASTERLEVEL      = 2301;
const int STRREF_LEVEL            = 2318;
const int STRREF_XP               = 62480;

const int STRREF_ITEM             = 6586;
// const int STRREF_SPELL            = 2295;    // commented out because
// const int STRREF_FEAT             = 326;     // the talktable forms of
// const int STRREF_SKILL            = 327;     // these are pluralized
const int STRREF_RANK             = 2316;
const int STRREF_RACE             = 148;
const int STRREF_ALIGNMENT        = 142;
const int STRREF_LG               = 112;
const int STRREF_NG               = 115;
const int STRREF_CG               = 118;
const int STRREF_LN               = 113;
const int STRREF_N                = 116;
const int STRREF_CN               = 119;
const int STRREF_LE               = 114;
const int STRREF_NE               = 117;
const int STRREF_CE               = 120;

const int STRREF_SUBRACE          = 7523;
const int STRREF_DEITY            = 152;

struct ireqreport
{
    string result;
    int    baseitemtype;
    int    marketprice;
};

// Translate the oItem to its recipe if one exists
// and places the recipe on oPC
// This way module makers dont have to include a bunch
// of recipe scrolls all over their module.  And players
// will always have this work in older modules
int CreateRecipeFromItem(object oItem, object oPC);

int CreateRecipeFromItem(object oItem, object oPC)
{
    string sItemResRef = GetResRef(oItem);
    // Scan the item_to_ireq table for the resref
    string sItemIreqFile = "item_to_ireq";
    string sRecipeTag = "NULL";
    int i = 0;
    while (sRecipeTag == "NULL")
    {
        string sItemResRefRead = Get2DAString(sItemIreqFile,"L_RESREF",i);
        //SendMessageToPC(oPC,"reading "+sItemResRefRead);
        if (sItemResRefRead == sItemResRef)
        {
            SendMessageToPC(oPC,"Found item in file");
            sRecipeTag = Get2DAString(sItemIreqFile,"RECIPE_TAG",i);
            // Once we have the recipe tag make a new recipe with that tag
            // so the user can make an item from it.
            // We have no way to change the name so the user will have some
            // trouble figuring out which recipe is for what....
            object oRecipe = CreateObject(OBJECT_TYPE_ITEM,"magicitemrecipe",GetLocation(oPC),FALSE,sRecipeTag);
            ActionDoCommand(ActionPickUpItem(oRecipe));
            return TRUE;
        }
        else if (sItemResRefRead == "")
        {
            //end of file
            //SendMessageToPC(oPC,"no item in file, i= "+IntToString(i)+ " item resref = "+sItemResRef);
            return FALSE;
        }
        i++;
    }
    return FALSE;
}

// CheckIReqs:
struct ireqreport CheckIReqs(string sIReqTable, int nDisplay=TRUE, int nConsumeIReqs=FALSE)
{
    // if recipe has no ireq table, return some message...
                                  string sResultResRef        = "";
                                  string sRecipe              = "";
    int nResultItems      = 0;    string sResultLine          = "";
                                  string sMissing             = "";

    int nCasterLevelReqs  = 0;    string sCasterLevelLine     = "";
                                  string sCasterLevelMiss     = "";
    int nExtraXPReqs      = 0;    string sXPLine              = "";
                                  string sXPMiss              = "";

    int nFeatReqs         = 0;    string sFeatsLine           = ""; // AND
                                  string sFeatsMiss           = "";
    int nSpellReqs        = 0;    string sSpellsLine          = ""; // AND
                                  string sSpellsMiss          = "";
    int nItemReqs         = 0;    string sItemsLine           = ""; // AND
                                  string sItemsMiss           = "";
    int nSkillReqs        = 0;    string sSkillsLine          = ""; // AND
                                  string sSkillsMiss          = "";
    int nLevelReqs        = 0;    string sLevelsLine          = ""; // AND
                                  string sLevelsMiss          = "";

    int nRaceReqs         = 0;    string sRacesLine           = ""; // OR
                                  string sRacesMiss           = "";
    int nAlignReqs        = 0;    string sAlignsLine          = ""; // OR
                                  string sAlignsMiss          = "";
    int nDeityReqs        = 0;    string sDeitiesLine         = ""; // OR
                                  string sDeitiesMiss         = "";

    int nFeatORReqs       = 0;    string sFeatsORLine         = ""; // OR
                                  string sFeatsORMiss         = "";
    int nSpellORReqs      = 0;    string sSpellsORLine        = ""; // OR
                                  string sSpellsORMiss        = "";
    int nItemORReqs       = 0;    string sItemsORLine         = ""; // OR
                                  string sItemsORMiss         = "";
    int nSkillORReqs      = 0;    string sSkillsORLine        = ""; // OR
                                  string sSkillsORMiss        = "";
    int nLevelORReqs      = 0;    string sLevelsORLine        = ""; // OR
                                  string sLevelsORMiss        = "";
    int nExtraGoldReqs      = 0;

    int nXPMatch          = TRUE;
    int nGoldMatch        = TRUE;
    int nCasterLevelMatch = TRUE;

    int nFeatsMatch       = TRUE;    int nFeatsORMatch        = FALSE;
    int nSpellsMatch      = TRUE;    int nSpellsORMatch       = FALSE;
    int nItemsMatch       = TRUE;    int nItemsORMatch        = FALSE;
    int nSkillsMatch      = TRUE;    int nSkillsORMatch       = FALSE;
    int nLevelsMatch      = TRUE;    int nLevelsORMatch       = FALSE;

    int nRaceMatch        = FALSE;
    int nAlignMatch       = FALSE;
    int nAreaMatch        = FALSE;
    int nDeityMatch       = FALSE;
// display the item name (from ireqs table)
    int nIReq = 0;
    int nMarketPrice = 0;
    int nItemsCost = 0;
    int nExtraXP = 0;
    int nExtraGold = 0;
    int nResultBaseItemType = BASE_ITEM_INVALID;
    int nBaseCost, nGPtoCreate, nXPtoCreate;
    int nCurrentParam1, nCurrentParam2, nTemp;
    string sCurrentParam1, sCurrentParam2, sTemp;
    object oTempObject;
    struct ireqreport iReport;
// iterate over the ireq table entries and sort between them..
    string sReqType = Get2DAString(sIReqTable, "ReqType", nIReq);
    do
    {
        sCurrentParam1 = Get2DAString(sIReqTable, "ReqParam1", nIReq);
        if (sReqType == sReqTypeCasterLevel) {
        // Expect Param1 to be a positive int.
            // Ignore any subsequent ones.
            // Construct Recipe line.
            if (nCasterLevelReqs == 0)
                {
                    sCasterLevelLine = sCurrentParam1;
                    // if casterlevel is not sufficient
                    if (hdGetCasterLevel(OBJECT_SELF) < StringToInt(sCurrentParam1))
                        {nCasterLevelMatch = FALSE;}
                }
            nCasterLevelReqs++;

        } else if (sReqType == sReqTypeFeat) {
        // Expect the FeatID.  Convert to int.  Lookup Feat's name.  Append to Feats line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            // Check Match
            nTemp = GetHasFeat(nCurrentParam1);
            sTemp = GetFeatName(nCurrentParam1);
            // AND with prior FEAT ireqs
            nFeatsMatch = nFeatsMatch && nTemp;
            if ((nTemp == TRUE) && (nConsumeIReqs == TRUE))
                {DecrementRemainingFeatUses(OBJECT_SELF, nCurrentParam1);}
            // Construct Recipe line
            if (nFeatReqs == 0)  // if first, start the line..
                {sFeatsLine = sFeatsLine + sTemp;}
            else                 // if not first, append to line.
                {sFeatsLine = sFeatsLine + ", " + sTemp;}
            // Construct Missing Line
            if (nTemp == FALSE)
                {sFeatsMiss = sFeatsMiss + "You do not have the " + GetFeatName(nCurrentParam1) + " feat\n";}
            nFeatReqs++;

        } else if (sReqType == sReqTypeSpell) {
        // Expect the SpellID.  Convert to int.  Lookup Spell's name.  Append to Spells line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            sTemp = GetSpellName(nCurrentParam1);
            // Check Match
            if (GetHasSpell(nCurrentParam1) > 0)
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // AND with prior SPELL ireqs
            nSpellsMatch = nSpellsMatch && nTemp;
            if ((nSpellsMatch == TRUE) && (nConsumeIReqs == TRUE))
                {DecrementRemainingSpellUses(OBJECT_SELF, nCurrentParam1);}
            // Construct Recipe line
            if (nSpellReqs == 0)
                {sSpellsLine = sSpellsLine + sTemp;}
            else
                {sSpellsLine = sSpellsLine + ", " + sTemp;}
            // Construct Missing Line
            if (GetHasSpell(nCurrentParam1) < 1)
                {sSpellsMiss = sSpellsMiss + "You do not have the " + sTemp + " spell prepared\n";}
            nSpellReqs++;

        } else if (sReqType == sReqTypeItem) {
            // Check Match
            oTempObject = GetItemPossessedBy(OBJECT_SELF, sCurrentParam1);
            if (oTempObject == OBJECT_INVALID)
                {nTemp = FALSE;}
            else
                {nTemp = TRUE;}
            // AND with prior ITEM ireqs
            nItemsMatch = nItemsMatch && nTemp;
            if ((nItemsMatch == TRUE) && (nConsumeIReqs == TRUE))
                {DestroyObject(oTempObject);}
            // Construct Recipe line
            // cheap hack for now: spawn in item into secure temporary location,
            // get name and cost offuvit, then vaporize it.
            oTempObject = CreateItemOnObject(sCurrentParam1, oTempContainer);
            SetIdentified(oTempObject, TRUE); // or it will get price of un-IDed item instead
            sCurrentParam1 = GetName(oTempObject);
            nCurrentParam2 = GetGoldPieceValue(oTempObject);
            sCurrentParam2 = IntToString(nCurrentParam2);
            nItemsCost = nItemsCost + nCurrentParam2;
            sTemp = sCurrentParam1 + " (" + sCurrentParam2 + "gp)";
            if (nItemReqs == 0)
                {sItemsLine = sItemsLine + sTemp;}
            else
                {sItemsLine = sItemsLine + ", " + sTemp;}
            // Construct Missing Line
            if (nTemp == FALSE)
                {sItemsMiss = sItemsMiss + "You need a " + sTemp + "\n";}
            DestroyObject(oTempObject);
            nItemReqs++;

        } else if (sReqType == sReqTypeResult) {
        // Expect the Item.  Lookup Item's name.  Append to Items line.
            if (nResultItems < 1) {
                sResultResRef = sCurrentParam1;
                // Construct Recipe line
                // cheap hack for now: spawn in item into secure temporary location,
                oTempObject = CreateItemOnObject(sResultResRef, oTempContainer);
                SetIdentified(oTempObject, TRUE); // or it will get price of un-IDed item instead
                // get name, cost, and baseitemtype offuvit,
                sResultLine = GetName(oTempObject);
                nMarketPrice = GetGoldPieceValue(oTempObject);
                nResultBaseItemType = GetBaseItemType(oTempObject);
                // then vaporize it.
                DestroyObject(oTempObject);
            }
            nResultItems++;

        } else if (sReqType == sReqTypeAlign) {  // OR type ireq
            // Check Match
            if (GetAlign(OBJECT_SELF) == sCurrentParam1)
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // OR with other ALIGN ireqs
            nAlignMatch = nAlignMatch || nTemp;
            // Construct Recipe line
            if (nAlignReqs < 1)
                {sAlignsLine = sCurrentParam1;}
            else
                {sAlignsLine = sAlignsLine + ", " + sCurrentParam1;}
            // Construct Missing: Just say "You do not meet the required alignment"
            nAlignReqs++;

        } else if (sReqType == sReqTypeRace) {
            // Expect the RaceID.
            // Convert to int.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            // Expect a subrace string in ReqParam2, **** for race only ireq
            sCurrentParam2 = Get2DAString(sIReqTable, "ReqParam2", nIReq);
            // Check Match, if race matches...
            if ((GetRacialType(OBJECT_SELF) == nCurrentParam1) &&
                // and.. SubRace is blank (not required) or also matches
                ((sCurrentParam2 == "") || (GetSubRace(OBJECT_SELF) == sCurrentParam2)))
                // set a race match
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // OR with other RACE ireqs
            nRaceMatch = nRaceMatch || nTemp;
            // Lookup Race's name.  Append to Races line.
            sCurrentParam1 = GetRacialTypeName(nCurrentParam1);
            // Construct Recipe line
            if (sCurrentParam2 == "")           // if no subrace req
                {sTemp = sCurrentParam1;}                   // leave blank
            else
                {sTemp = sCurrentParam2;} // if subrace, insert before race
            if (nRaceReqs < 1)
                {sRacesLine = sTemp;}
            else
                {sRacesLine = sRacesLine + ", " + sTemp;}
            // Construct Missing line
            if (nRaceReqs < 1)
                {sRacesMiss = sTemp;}
            else
                {sRacesMiss = sRacesMiss + " or a " + sTemp;}
            nRaceReqs++;

        } else if (sReqType == sReqTypeDeity) {
            // Check Match
            if (GetDeity(OBJECT_SELF) == sCurrentParam1)
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // OR with other DEITY ireqs
            nDeityMatch = nDeityMatch || nTemp;
            // Construct Recipe line
            if (nDeityReqs < 1)
                {sDeitiesLine = sCurrentParam1;}
            else
                {sDeitiesLine = sDeitiesLine + " or " + sCurrentParam1;}
            // Construct Missing line
            if (nDeityReqs < 1)
                {sDeitiesMiss = sCurrentParam1;}
            else
                {sDeitiesMiss = sDeitiesLine + " or " + sCurrentParam1;}
            nDeityReqs++;

        } else if (sReqType == sReqTypeSkill) {
        // Expect the SkillID.  Convert to int.  Lookup Skill's name.  Append to Skills line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            sCurrentParam2 = Get2DAString(sIReqTable, "ReqParam2", nIReq);
            nCurrentParam2 = StringToInt(sCurrentParam2);
            // Check Match
            if (GetSkillRank(nCurrentParam1) >= nCurrentParam2)
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // AND with other SKILL ireqs
            nSkillsMatch = nSkillsMatch && nTemp;
            // Construct Recipe line
            if (nSkillReqs < 1) // if first, start the line..
                {sSkillsLine = sSkillsLine + sCurrentParam2 + " ranks in " + GetSkillName(nCurrentParam1);}
            else                // if not first, append to line.
                {sSkillsLine = sSkillsLine + ", " + sCurrentParam2 + " ranks in " + GetSkillName(nCurrentParam1);}
            // Construct Missing line
            if (nTemp == FALSE)
                {sSkillsMiss = sSkillsMiss + "You need " + sCurrentParam2 + " ranks in " + GetSkillName(nCurrentParam1) + "\n";}
            nSkillReqs++;

        } else if (sReqType == sReqTypeFeatOR) {
        // Expect the FeatID.  Convert to int.  Lookup Feat's name.  Append to Feats line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            // Check Match
            nTemp = GetHasFeat(nCurrentParam1);
            sTemp = GetFeatName(nCurrentParam1);
            // OR with prior FEATOR ireqs
            if ((nFeatsORMatch == FALSE) && (nTemp == TRUE) && (nConsumeIReqs == TRUE))
                {DecrementRemainingFeatUses(OBJECT_SELF, nCurrentParam1);}
            nFeatsORMatch = nFeatsORMatch || nTemp;
            // Construct Recipe Line
            if (nFeatORReqs == 0)
                {sFeatsORLine = sFeatsORLine + sTemp;}
            else
                {sFeatsORLine = sFeatsORLine + " or " + sTemp;}
            // Construct Missing Line
            if (nFeatORReqs == 0)
                {sFeatsORMiss = GetFeatName(nCurrentParam1);}
            else
                {sFeatsORMiss = sFeatsORMiss + " or " + GetFeatName(nCurrentParam1);}
            nFeatORReqs++;

        } else if (sReqType == sReqTypeSpellOR) {
        // Expect the SpellID.  Convert to int.  Lookup Spell's name.  Append to Spells line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            sTemp = GetSpellName(nCurrentParam1);
            // Check Match
            if (GetHasSpell(nCurrentParam1) > 0)  // if first, OR the reqs together
                {nTemp = TRUE;}
            else                 // if not first, AND with prior reqs.
                {nTemp = FALSE;}
            // OR with prior SPELLOR ireqs
            if ((nSpellsORMatch == FALSE) && (nTemp == TRUE) && (nConsumeIReqs == TRUE))
                {DecrementRemainingSpellUses(OBJECT_SELF, nCurrentParam1);}
            nSpellsORMatch = nSpellsORMatch || nTemp;
            // Construct Recipe Line
            if (nSpellORReqs == 0)
                {sSpellsORLine = sSpellsORLine + sTemp;}
            else
                {sSpellsORLine = sSpellsORLine + " or " + sTemp;}
            // Construct Missing Line
            if (nSpellORReqs == 0)
                {sSpellsORMiss = GetSpellName(nCurrentParam1);}
            else
                {sSpellsORMiss = sSpellsORMiss + " or " + GetSpellName(nCurrentParam1);}
            nSpellORReqs++;

        }  else if (sReqType == sReqTypeItemOR) {
        // Expect the Item.  Lookup Item's name.  Append to Items line.
            // cheap hack for now: spawn in item into secure temporary location,
            // get name and cost offuvit, then vaporize it.
            oTempObject = CreateItemOnObject(sCurrentParam1, oTempContainer);
            SetIdentified(oTempObject, TRUE); // or it will get price of un-IDed item instead
            // Check Match
            if (GetItemPossessedBy(OBJECT_SELF, sCurrentParam1) == OBJECT_INVALID)
                {nTemp = FALSE;}
            else
                {nTemp = TRUE;}
            // OR with prior ITEMOR ireqs
            if ((nItemsORMatch == FALSE) && (nTemp == TRUE) && (nConsumeIReqs == TRUE))
                {DestroyObject(oTempObject);}
            nItemsORMatch = nItemsORMatch || nTemp;
            // Construct Recipe Line
            sCurrentParam1 = GetName(oTempObject);
            sCurrentParam2 = IntToString(GetGoldPieceValue(oTempObject));
            // Costs for ITEMOR components will cost the spellcaster EXTRA
            // above the standard item creation cost formulas.  They are
            // not formularized here due to the added complexity of tracking
            // the costs if one of these OR components is used or not.
            sTemp = sCurrentParam1 + " (" + sCurrentParam2 + "gp)";
            if (nItemORReqs == 0)
                {sItemsORLine = sItemsORLine + sTemp;}
            else
                {sItemsORLine = sItemsORLine + " or " + sTemp;}
            // Construct Missing Line
            if (nItemORReqs == 0)
                {sItemsORMiss = sTemp;}
            else
                {sItemsORMiss = sItemsORMiss + " or " + sTemp;}
            DestroyObject(oTempObject);
            nItemORReqs++;

        }  else if (sReqType == sReqTypeSkillOR) {
        // Expect the SkillID.  Convert to int.  Lookup Skill's name.  Append to Skills line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            sCurrentParam2 = Get2DAString(sIReqTable, "ReqParam2", nIReq);
            nCurrentParam2 = StringToInt(sCurrentParam2);
            // Check Match
            if (GetSkillRank(nCurrentParam1) >= nCurrentParam2)
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // OR with other SKILLOR ireqs
            nSkillsORMatch = nSkillsORMatch || nTemp;
            // Construct Recipe Line
            sTemp = sCurrentParam2 + " ranks in " + GetSkillName(nCurrentParam1);
            if (nSkillORReqs == 0)
                {sSkillsORLine = sTemp;}
            else
                {sSkillsORLine = sSkillsORLine + " or " + sTemp;}
            // Construct Missing Line
            if (nSkillORReqs == 0)
                {sSkillsORMiss = sTemp;}
            else
                {sSkillsORMiss = sSkillsORMiss + " or " + sTemp;}
            nSkillORReqs++;

        } else if (sReqType == sReqTypeExtraXP) {
            // Expect the avail XP required.  Convert to int.
            nExtraXP = nExtraXP + StringToInt(sCurrentParam1);
            // Check Match.  Done after the ireqs are
            // Recipe Line.  Not reported here, only in end summary
            // Construct Missing Line.  Not done here, only in end summary
            nExtraXPReqs++;
        } else if (sReqType == sReqTypeExtraGold) {
            // Expect the avail Gold required.  Convert to int.
            nExtraGold = nExtraGold + StringToInt(sCurrentParam1);
            // Check Match.  Done after the ireqs are
            // Recipe Line.  Not reported here, only in end summary
            // Construct Missing Line.  Not done here, only in end summary
            nExtraGoldReqs++;

        } else if (sReqType == sReqTypeLevel) {
            // Expect the level.  Convert.
            // Expect the class.  Convert.  Lookup Class name.  Append to Levels line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            sCurrentParam2 = Get2DAString(sIReqTable, "ReqParam2", nIReq);
            nCurrentParam2 = StringToInt(sCurrentParam2);
            // Check Match
            if (GetLevelByClass(nCurrentParam2) >= nCurrentParam1)
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // AND with prior LEVEL ireqs
            nLevelsMatch = nLevelsMatch && nTemp;
            // Construct Recipe Line
            sTemp = sCurrentParam1 + " "+ GetClassName(nCurrentParam2);
            if (nLevelReqs == 0)  // if first, start the line..
                {sLevelsLine = "level " + sTemp;}
            else                 // if not first, append to line.
                {sLevelsLine = sLevelsLine + ", " + sTemp;}
            // Construct Missing Line
            if (nTemp == FALSE)
                {sLevelsMiss = sLevelsMiss + "You need " + sCurrentParam1 + " levels of " + GetClassName(nCurrentParam2) + "\n";}
            nLevelReqs++;

        } else if (sReqType == sReqTypeLevelOR) {
            // Expect the level.  Convert.
            // Expect the class.  Convert.  Lookup Class name.  Append to Levels line.
            nCurrentParam1 = StringToInt(sCurrentParam1);
            sCurrentParam2 = Get2DAString(sIReqTable, "ReqParam2", nIReq);
            nCurrentParam2 = StringToInt(sCurrentParam2);
            // Check Match
            if (GetLevelByClass(nCurrentParam2) >= nCurrentParam1)
                {nTemp = TRUE;}
            else
                {nTemp = FALSE;}
            // AND with prior LEVELOR ireqs
            nLevelsORMatch = nLevelsORMatch || nTemp;
            // Construct Recipe Line
            sTemp = sCurrentParam1 + " "+ GetClassName(nCurrentParam2);
            if (nLevelORReqs == 0)  // if first, start the line..
                {sLevelsORLine = "a level " + sTemp;}
            else                 // if not first, append to line.
                {sLevelsORLine = sLevelsORLine + " or a level " + sTemp;}
            // Construct Missing Line
            sTemp = sCurrentParam1 + " levels of " + GetClassName(nCurrentParam2);
            if (nLevelORReqs == 0)
                {sLevelsORMiss = sTemp;}
            else
                {sLevelsORMiss = sLevelsORMiss + " or " + sTemp;}
            nLevelORReqs++;

        }
        sReqType = Get2DAString(sIReqTable, "ReqType", ++nIReq);
    } while (sReqType != "");

    // Calculate GP and XP costs to create
    nBaseCost = nMarketPrice - (5 * nExtraXP);
    if (nBaseCost < 0) {nBaseCost = 0;}
    nGPtoCreate = (nBaseCost / 2) - nItemsCost + nExtraGold;
    // Extra gold cost increases the xp needed to make the item
    // as if the item costs that much more.
    // Useful for making items set to plot that have 0 value, but
    // need gold to make
    nXPtoCreate = (nBaseCost / 25) + nExtraXP + (nExtraGold / 25);
    if (nGPtoCreate < 0) {nGPtoCreate = 0;}
    if (nXPtoCreate < 0) {nXPtoCreate = 0;}

    // Display
    sCasterLevelLine = "Caster Level: " + sCasterLevelLine;

    // sRecipe = sCasterLevelLine + sFeatsLine + sSpellsLine + sItemsLine + sSkillsLine;
    sRecipe = sCasterLevelLine + "; Prerequisites: ";
    if (nFeatReqs > 0)
        {sRecipe = sRecipe + sFeatsLine;}
    if (nFeatORReqs > 0)
        {sRecipe = sRecipe + ", " + sFeatsORLine;}
    if (nSpellReqs > 0)
        {sRecipe = sRecipe + ", " + sSpellsLine;}
    if (nSpellORReqs > 0)
        {sRecipe = sRecipe + ", " + sSpellsORLine;}

    if (nAlignReqs > 0)
        {sRecipe = sRecipe + ", creator must be of " + sAlignsLine + " alignment";}
    if (nRaceReqs > 0)
        {sRecipe = sRecipe + ", creator must be a " + sRacesLine;}
    if (nDeityReqs > 0)
        {sRecipe = sRecipe + ", patron deity (" + sDeitiesLine + ")";}

    if (nSkillReqs > 0)
        {sRecipe = sRecipe + ", " + sSkillsLine;}
    if (nSkillORReqs > 0)
        {sRecipe = sRecipe + ", " + sSkillsORLine;}
    if (nLevelReqs > 0)
        {sRecipe = sRecipe + ", " + sLevelsLine;}
    if (nLevelORReqs > 0)
        {sRecipe = sRecipe + ", " + sLevelsORLine;}
    if (nItemReqs > 0)
        {sRecipe = sRecipe + ", " + sItemsLine;}
    if (nItemORReqs > 0)
        {sRecipe = sRecipe + ", " + sItemsORLine;}
    if (nResultItems > 0)
        {sRecipe = sResultLine + ":\n" +sRecipe + "\nMarket Price: " + IntToString(nMarketPrice) + " gp;\n";}

    sRecipe = sRecipe + "Cost to Create: " + IntToString(nGPtoCreate) + " gp";
    if (nItemReqs > 0)
        {sRecipe = sRecipe + " + (" + IntToString(nItemsCost) + " gp in items)";}
    sRecipe = sRecipe + " + " + IntToString(nXPtoCreate) + " XP";

    // Construct Missing Ingredients Report
    if ((nCasterLevelReqs > 0) && (nCasterLevelMatch == FALSE))
        {sMissing = sMissing + "You must have " + sCasterLevelLine + ";\n";}
    if ((nFeatReqs > 0) && (nFeatsMatch == FALSE))
        {sMissing = sMissing + sFeatsMiss;}
    if ((nFeatORReqs > 0) && (nFeatsORMatch == FALSE))
        {sMissing = sMissing + "You do not have the " + sFeatsORMiss + " feats\n";}
    if ((nSpellReqs > 0) && (nSpellsMatch == FALSE))
        {sMissing = sMissing + sSpellsMiss;}
    if ((nSpellORReqs > 0) && (nSpellsORMatch == FALSE))
        {sMissing = sMissing + "You do not have the " + sSpellsORMiss + " spells prepared\n";}

    if ((nAlignReqs > 0) && (nAlignMatch == FALSE))
        {sMissing = sMissing + "You do not meet the required alignment\n";}
    if ((nRaceReqs > 0) && (nRaceMatch == FALSE))
        {sMissing = sMissing + "You are not a " + sRacesMiss + "\n";}
    if ((nDeityReqs > 0) && (nDeityMatch == FALSE))
        {sMissing = sMissing + "Your patron deity is not " + sDeitiesMiss + "\n";}

    if ((nSkillReqs > 0) && (nSkillsMatch == FALSE))
        {sMissing = sMissing + sSkillsMiss;}
    if ((nSkillORReqs > 0) && (nSkillsORMatch == FALSE))
        {sMissing = sMissing + "You need " + sSkillsORMiss + "\n";}

    if ((nLevelReqs > 0) && (nLevelsMatch == FALSE))
        {sMissing = sMissing + sLevelsMiss;}
    if ((nLevelORReqs > 0) && (nLevelsORMatch == FALSE))
        {sMissing = sMissing + "You need " + sLevelsORMiss;}
    if ((nItemReqs > 0) && (nItemsMatch == FALSE))
        {sMissing = sMissing + sItemsMiss;}
    if ((nItemORReqs > 0) && (nItemsORMatch == FALSE))
        {sMissing = sMissing + "You need a " + sItemsORMiss + "\n";}

    // Calculate GP and XP requirements
    if (nGPtoCreate > 0)
        {
            nTemp = GetGold(OBJECT_SELF);
            if (nTemp >= nGPtoCreate)
                {nGoldMatch = TRUE;}
            else
                {
                    nGoldMatch = FALSE;
                    sMissing = sMissing + "You need " + IntToString(nGPtoCreate - nTemp) + " more gp\n";
                }
        }
    if (nXPtoCreate > 0)
        {
            nTemp = GetAvailXP(OBJECT_SELF);
            if (nTemp >= nXPtoCreate)
                {nXPMatch = TRUE;}
            else
                {
                    nXPMatch = FALSE;
                    sMissing = sMissing + "You need " + IntToString(nXPtoCreate - nTemp) + " more XP\n";
                }
        }


    // If all ireqs check out then return resref of the result.
    nTemp = TRUE;
    if (nFeatReqs > 0)
        {nTemp = nTemp && nFeatsMatch;}
    if (nSpellReqs > 0)
        {nTemp = nTemp && nSpellsMatch;}
    if (nItemReqs > 0)
        {nTemp = nTemp && nItemsMatch;}
    if (nSkillReqs > 0)
        {nTemp = nTemp && nSkillsMatch;}
    if (nLevelReqs > 0)
        {nTemp = nTemp && nLevelsMatch;}

    if (nRaceReqs > 0)
        {nTemp = nTemp && nRaceMatch;}
    if (nAlignReqs > 0)
        {nTemp = nTemp && nAlignMatch;}
    if (nDeityReqs > 0)
        {nTemp = nTemp && nDeityMatch;}

    if (nFeatORReqs > 0)
        {nTemp = nTemp && nFeatsORMatch;}
    if (nSpellORReqs > 0)
        {nTemp = nTemp && nSpellsORMatch;}
    if (nItemORReqs > 0)
        {nTemp = nTemp && nItemsORMatch;}
    if (nSkillORReqs > 0)
        {nTemp = nTemp && nSkillsORMatch;}
    if (nLevelORReqs > 0)
        {nTemp = nTemp && nLevelsORMatch;}
    nTemp = nTemp && nGoldMatch && nXPMatch;

    if ((nResultBaseItemType != BASE_ITEM_INVALID) && (nDisplay == TRUE))
        {SendMessageToPC(OBJECT_SELF, sRecipe + "\n");}

    // ireqreport
    iReport.baseitemtype = nResultBaseItemType;
    // if ireqs are fulfilled
    if (nResultBaseItemType == BASE_ITEM_INVALID)
        {
            iReport.result = "";
            iReport.marketprice = 0;
            return iReport;
        }
    else
        {
            if (nTemp)
                {
                    iReport.result = sResultResRef;
                    iReport.marketprice = nMarketPrice;
                    if (nDisplay)
                    {
                        // SendMessageToPC(OBJECT_SELF, "You have met all the requirements");
                        SendMessageToPC(OBJECT_SELF, "You have met all the requirements.");
                    }
                    if (nConsumeIReqs)
                    {
                        TakeGoldFromCreature(nGPtoCreate, OBJECT_SELF, TRUE);
                        SetXP(OBJECT_SELF, GetXP(OBJECT_SELF) - nXPtoCreate);
                        // SendMessageToPC(OBJECT_SELF, "You have met all the requirements");
                        SendMessageToPC(OBJECT_SELF, "You have met all the requirements.");
                        // Economic Reporting
                        // log gp consumed
                        // WriteTimestampedLogEntry(IntToString(nGPtoCreate) + "gp consumed (item creation attempt)");
                    }
                    return iReport;
                }
            else
                {
                    if ((nDisplay) || (nConsumeIReqs))
                    {
                        // SendMessageToPC(OBJECT_SELF, "You have not met all the requirements");
                        SendMessageToPC(OBJECT_SELF,  "You have not met all the requirements.");
                        SendMessageToPC(OBJECT_SELF, sMissing);
                    }
                    iReport.result = "";
                    iReport.marketprice = 0;
                    return iReport;
                }
        }
}

// GetFeatName: via lookup of the name strref from feat.2da
string GetFeatName(int nFeatID)
{
    string sName = GetStringByStrRef(StringToInt(Get2DAString("Feat", "FEAT" ,nFeatID)));
    if ((sName != "Bad Strref") && (sName != ""))
        {return sName;}
    else
        {return Get2DAString("Feat", "LABEL", nFeatID);}  // Get2DAString does not go beyond a certain limit!
}

// GetSpellName: via lookup of the name strref from spells.2da
string GetSpellName(int nSpellID)
{
    string sName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name" ,nSpellID)));
    if ((sName != "Bad Strref") && (sName != ""))
        {return sName;}
    else
        {return Get2DAString("spells", "Label", nSpellID);}
}

// GetSkillName: via lookup of the name strref from skills.2da
string GetSkillName(int nSkillID)
{
    // GetStringByStrRef(StringToInt(Get2DAString("skills", "Name" ,nSkillID)));
    string sName = GetStringByStrRef(StringToInt(Get2DAString("skills", "Name", nSkillID)));
    if ((sName != "Bad Strref") && (sName != ""))
        {return sName;}
    else
        {return Get2DAString("skills", "Label", nSkillID);}
}

// GetRaceName: via lookup of the name strref from racialtypes.2da
string GetRacialTypeName(int nRacialTypeID)
{
    // GetStringByStrRef(StringToInt(Get2DAString("racialtypes", "Name" ,nRacialTypeID)));
    string sName = GetStringByStrRef(StringToInt(Get2DAString("racialtypes", "Name", nRacialTypeID)));
    if ((sName != "Bad Strref") && (sName != ""))
        {return sName;}
    else
        {return Get2DAString("racialtypes", "Label", nRacialTypeID);}
}

string GetClassName(int nClassID)
{
    string sName = GetStringByStrRef(StringToInt(Get2DAString("classes", "Name", nClassID)));
    if ((sName != "Bad Strref") && (sName != ""))
        {return sName;}
    else
        {return Get2DAString("classes", "Label", nClassID);}
}

int HasItemByResRef(object oTarget, string sItemResRef)
{
    object oItem = GetFirstItemInInventory(oTarget);
    int nHasItem = FALSE;
    string sResRef;
    do
    {
        sResRef = GetResRef(oItem);
        if (sResRef == sItemResRef)
            {nHasItem = TRUE;}
        oItem = GetNextItemInInventory(oTarget);
    }
    while (sResRef != sItemResRef);
    return nHasItem;
}

string GetAlign(object oTarget=OBJECT_SELF)
{
    // Check Ethical Axis
    int nAlignEthical;
    nAlignEthical = GetAlignmentLawChaos(oTarget);
    string sAlignEthical;
    switch (nAlignEthical)
    {
        case ALIGNMENT_LAWFUL:
            sAlignEthical = "L";  break;
        case ALIGNMENT_NEUTRAL:
            sAlignEthical = "N";  break;
        case ALIGNMENT_CHAOTIC:
            sAlignEthical = "C";  break;
        default:
            sAlignEthical = "";  break;
    }
    // Check Moral Axis
    int nAlignMoral;
    nAlignMoral = GetAlignmentGoodEvil(oTarget);
    string sAlignMoral;
    switch (nAlignMoral)
    {
        case ALIGNMENT_GOOD:
            sAlignMoral = "G";  break;
        case ALIGNMENT_NEUTRAL:
            sAlignMoral = "N";  break;
        case ALIGNMENT_EVIL:
            sAlignMoral = "E";  break;
        default:
            sAlignMoral = "";  break;
    }
    // Reformat True Neutral
    string sPlayerAlign = sAlignEthical + sAlignMoral;
    if (sPlayerAlign == "NN")
        {sPlayerAlign = "N";}
    return sPlayerAlign;
}

int GetAvailXP(object oTarget=OBJECT_SELF)
{
    int nRow = GetCharacterLevel(oTarget) - 1;
    int nAvailXP = GetXP(oTarget) - StringToInt(Get2DAString("exptable", "XP", nRow));
    return nAvailXP;
}

// Functions for handling Item Creation Processes

// Set a process as a local variable
void SetLocalItemCreationProcess(object oObject, string sVarName, struct itemcreationprocess pProcess)
{
    SetLocalString(oObject, sVarName + ".result", pProcess.result);
    SetLocalInt(oObject, sVarName + ".marketprice", pProcess.marketprice);
    SetLocalInt(oObject, sVarName + ".lasttimestamp", pProcess.lasttimestamp);
    SetLocalFloat(oObject, sVarName + ".completeddays", pProcess.completeddays);
}

// Get a process as a local variable
struct itemcreationprocess GetLocalItemCreationProcess(object oObject, string sVarName)
{
    struct itemcreationprocess pProcess;
    pProcess.result = GetLocalString(oObject, sVarName + ".result");
    pProcess.marketprice = GetLocalInt(oObject, sVarName + ".marketprice");
    pProcess.lasttimestamp = GetLocalInt(oObject, sVarName + ".lasttimestamp");
    pProcess.completeddays = GetLocalFloat(oObject, sVarName + ".completeddays");
    return pProcess;
}

// Delete an item creation process stored in the campaign db.
void DeleteLocalItemCreationProcess(object oObject, string sVarName)
{
    DeleteLocalString(oObject, sVarName + ".result");
    DeleteLocalInt(oObject, sVarName + ".marketprice");
    DeleteLocalInt(oObject, sVarName + ".lasttimestamp");
    DeleteLocalFloat(oObject, sVarName + ".completeddays");
}

// Campaign itemcreationprocess functions
// Set a process in the campaign database
void SetCampaignItemCreationProcess(string sCampaignName, string sVarName, struct itemcreationprocess pProcess, object oObject=OBJECT_INVALID)
{
    SetCampaignString(sCampaignName, sVarName + ".result", pProcess.result, oObject);
    SetCampaignInt(sCampaignName, sVarName + ".marketprice", pProcess.marketprice, oObject);
    SetCampaignInt(sCampaignName, sVarName + ".lasttimestamp", pProcess.lasttimestamp, oObject);
    SetCampaignFloat(sCampaignName, sVarName + ".completeddays", pProcess.completeddays, oObject);
}

// Get a process in the campaign database
struct itemcreationprocess GetCampaignItemCreationProcess(string sCampaignName, string sVarName, object oObject=OBJECT_INVALID)
{
    struct itemcreationprocess pProcess;
    pProcess.result = GetCampaignString(sCampaignName, sVarName + ".result", oObject);
    pProcess.marketprice = GetCampaignInt(sCampaignName, sVarName + ".marketprice", oObject);
    pProcess.lasttimestamp = GetCampaignInt(sCampaignName, sVarName + ".lasttimestamp", oObject);
    pProcess.completeddays = GetCampaignFloat(sCampaignName, sVarName + ".completeddays", oObject);
    return pProcess;
}

// Delete a process in the campaign database
void DeleteCampaignItemCreationProcess(string sCampaignName, string sVarName, object oObject=OBJECT_INVALID)
{
    DeleteCampaignVariable(sCampaignName, sVarName + ".result", oObject);
    DeleteCampaignVariable(sCampaignName, sVarName + ".marketprice", oObject);
    DeleteCampaignVariable(sCampaignName, sVarName + ".lasttimestamp", oObject);
    DeleteCampaignVariable(sCampaignName, sVarName + ".completeddays", oObject);
}



// END include file



