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
