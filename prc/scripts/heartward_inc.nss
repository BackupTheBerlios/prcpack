
int CLASS_TYPE_STORMLORD   = 86;
int CLASS_TYPE_HEARTWARDER = 87;
int CLASS_TYPE_FISTRAZIEL  = 88;

int FEAT_SANCTIFY_MARTIAL_CLUB        = 3194;
int FEAT_SANCTIFY_MARTIAL_DAGGER      = 3195;
int FEAT_SANCTIFY_MARTIAL_MACE        = 3196;
int FEAT_SANCTIFY_MARTIAL_MORNINGSTAR = 3197;
int FEAT_SANCTIFY_MARTIAL_QUATERSTAFF = 3198;
int FEAT_SANCTIFY_MARTIAL_SPEAR       = 3199;
int FEAT_SANCTIFY_MARTIAL_SHORTSWORD  = 3200;
int FEAT_SANCTIFY_MARTIAL_RAPIER      = 3201;
int FEAT_SANCTIFY_MARTIAL_SCIMITAR    = 3202;
int FEAT_SANCTIFY_MARTIAL_LONGSWORD   = 3203;
int FEAT_SANCTIFY_MARTIAL_GREATSWORD  = 3204;
int FEAT_SANCTIFY_MARTIAL_HANDAXE     = 3205;
int FEAT_SANCTIFY_MARTIAL_BATTLEAXE   = 3206;
int FEAT_SANCTIFY_MARTIAL_GREATAXE    = 3207;
int FEAT_SANCTIFY_MARTIAL_HALBERD     = 3208;
int FEAT_SANCTIFY_MARTIAL_LIGHTHAMMER = 3209;
int FEAT_SANCTIFY_MARTIAL_LIGHTFLAIL  = 3210;
int FEAT_SANCTIFY_MARTIAL_WARHAMMER    = 3211;
int FEAT_SANCTIFY_MARTIAL_HEAVYFLAIL  = 3212;
int FEAT_SANCTIFY_MARTIAL_SCYTHE      = 3213;
int FEAT_SANCTIFY_MARTIAL_KATANA      = 3214;
int FEAT_SANCTIFY_MARTIAL_BASTARDSWORD = 3215;
int FEAT_SANCTIFY_MARTIAL_DIREMACE    = 3216;
int FEAT_SANCTIFY_MARTIAL_DOUBLEAXE   = 3217;
int FEAT_SANCTIFY_MARTIAL_TWOBLADED   = 3218;
int FEAT_SANCTIFY_MARTIAL_KAMA        = 3219;
int FEAT_SANCTIFY_MARTIAL_KUKRI       = 3220;
int FEAT_SANCTIFY_MARTIAL_HEAVYCROSSBOW = 3221;
int FEAT_SANCTIFY_MARTIAL_LIGHTCROSSBOW = 3222;
int FEAT_SANCTIFY_MARTIAL_SLING       = 3223;
int FEAT_SANCTIFY_MARTIAL_LONGBOW     = 3224;
int FEAT_SANCTIFY_MARTIAL_SHORTBOW    = 3225;
int FEAT_SANCTIFY_MARTIAL_SHURIKEN    = 3226;
int FEAT_SANCTIFY_MARTIAL_DART        = 3227;




int FEAT_CHARISMA_INC1     = 3230;
int FEAT_CHARISMA_INC2     = 3231;
int FEAT_CHARISMA_INC3     = 3232;
int FEAT_CHARISMA_INC4     = 3233;
int FEAT_CHARISMA_INC5     = 3234;
int FEAT_HEART_PASSION     = 3235;
int FEAT_LIPS_RAPTUR       = 3236;
int FEAT_VOICE_SIREN       = 3237;
int FEAT_TEARS_EVERGOLD    = 3238;
int FEAT_FEY_METAMORPH     = 3239;
int FEAT_ELECTRIC_RES_10   = 3240;
int FEAT_ELECTRIC_RES_15   = 3241;
int FEAT_ELECTRIC_RES_20   = 3242;
int FEAT_ELECTRIC_RES_30   = 3243;
int FEAT_SHOCK_WEAPON      = 3244;
int FEAT_THUNDER_WEAPON    = 3245;
int FEAT_SHOCKING_WEAPON   = 3246;
int FEAT_ELEMENTAL_CONFLAG = 3247;

int FEAT_SMITE_CONFIRMING  = 3255;
int FEAT_SMITE_HOLY        = 3257;
int FEAT_SMITE_FIEND       = 3258;


int SPELL_LIPS_RAPTUR      = 2210;
int SPELL_TEARS_EVERGOLD   = 2211;
int SPELL_ELE_CONF_FIRE    = 2213;
int SPELL_ELE_CONF_WATER   = 2214;
int SPELL_ELE_CONF_EARTH   = 2215;
int SPELL_ELE_CONF_AIR     = 2216;

int IP_CONST_CASTSPELL_LIPS_RAPTURE_1 =550;



int Sanctify_Feat(int iTypeWeap)
{
       switch(iTypeWeap)
            {
                case BASE_ITEM_BASTARDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BASTARDSWORD);
                case BASE_ITEM_BATTLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BATTLEAXE);
                case BASE_ITEM_CLUB: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_CLUB);
                case BASE_ITEM_DAGGER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DAGGER);
                case BASE_ITEM_DART: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DART);
                case BASE_ITEM_DIREMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DIREMACE);
                case BASE_ITEM_DOUBLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DOUBLEAXE);
              //  case BASE_ITEM_DWARVENWARAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DWAXE);
                case BASE_ITEM_GREATAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATAXE);
                case BASE_ITEM_GREATSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATSWORD);
                case BASE_ITEM_HALBERD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HALBERD);
                case BASE_ITEM_HANDAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HANDAXE);
                case BASE_ITEM_HEAVYCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYCROSSBOW);
                case BASE_ITEM_HEAVYFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYFLAIL);
                case BASE_ITEM_KAMA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KAMA);
                case BASE_ITEM_KATANA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KATANA);
                case BASE_ITEM_KUKRI: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KUKRI);
                case BASE_ITEM_LIGHTCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTCROSSBOW);
                case BASE_ITEM_LIGHTFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTFLAIL);
                case BASE_ITEM_LIGHTHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTHAMMER);
                case BASE_ITEM_LIGHTMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MACE);
                case BASE_ITEM_LONGBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGBOW);
                case BASE_ITEM_LONGSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGSWORD);
                case BASE_ITEM_MORNINGSTAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MORNINGSTAR);
                case BASE_ITEM_QUARTERSTAFF: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_QUATERSTAFF);
                case BASE_ITEM_RAPIER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_RAPIER);
                case BASE_ITEM_SCIMITAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCIMITAR);
                case BASE_ITEM_SCYTHE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCYTHE);
                case BASE_ITEM_SHORTBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTBOW);
                case BASE_ITEM_SHORTSPEAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SPEAR);
                case BASE_ITEM_SHORTSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTSWORD);
                case BASE_ITEM_SHURIKEN: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHURIKEN);
                case BASE_ITEM_SLING: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
                case BASE_ITEM_TWOBLADEDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_TWOBLADED);
                case BASE_ITEM_WARHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_WARHAMMER);
                case BASE_ITEM_WHIP: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
            }
    return 0;
}