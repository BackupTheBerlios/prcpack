#include "mh_constante"

int StartingConditional()
{
    int iResult;

    iResult = GetHasFeat(FEAT_INSTRUMENT,GetPCSpeaker());
    return iResult;
}
