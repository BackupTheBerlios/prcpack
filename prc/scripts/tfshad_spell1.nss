#include "heartward_inc"

void main()
{

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();

   string SpellN;
   int iLevel=GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);

    if(nSpell == SHADOWLORD_BLINDNESS)
    {
        SpellN = "tfshad_blindness";
    }
    else if (nSpell == SHADOWLORD_DARKNESS)
    {
        SpellN = "tfshad_darkness";
    }
    else if (nSpell == SHADOWLORD_INVISIBILITY)
    {
        SpellN = "tfshad_invis";
    }
    else if(nSpell == SHADOWLORD_HASTE)
    {
        SpellN = "tfshad_haste";
    }
    else if (nSpell == SHADOWLORD_IMPROVINVIS)
    {
        SpellN = "tfshad_imprinvis";
    }
    else if (nSpell == SHADOWLORD_VAMPITOUCH)
    {
        SpellN = "tfshad_vamptch";
    }
    else if (nSpell == SHADOWLORD_CONFUSION)
    {
        SpellN = "tfshad_confusion";
    }
    else if (nSpell == SHADOWLORD_INVISPHERE)
    {
        SpellN = "tfshad_invsph";
    }
    ExecuteScript(SpellN,OBJECT_SELF);
}

