/**
 * Master of Shrouds: AI/utility functions
 * 2004/02/17
 * Brian Greinke
 */

// Finds a valid target for the summoned spirit to attack, in this order:
// Most Damaged Enemy > Nearest NPC > Master of Shrouds > Unsummon
object DetermineTarget( object summoner, object targeter=OBJECT_SELF );

// Unsummons the spirit
void UnsummonMe();

object DetermineTarget( object summoner, object targeter=OBJECT_SELF )
{
    int i = 1;
    object enemy = GetFactionMostDamagedMember( targeter, TRUE );
    //SpeakString( InsertString(" is checking for targets", GetName(OBJECT_SELF), 0) );
    while ( GetIsObjectValid(enemy) )
    {
        //SpeakString( InsertString(" is being checked", GetName(enemy), 0) );
        if ( !TestStringAgainstPattern("*a_SUMM", GetResRef(enemy)) && 
             !GetAge(enemy) )
        {
            //SpeakString( "Attacking" );
            break;
        }
        else 
        {
            //SpeakString( "Getting next" ); 
            enemy = GetNearestCreature( CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, i );
            i++;
        }
    }
    if ( !GetIsObjectValid(enemy) ) //no more enemies; turn on the summoner
    {
        if ( !GetIsDead(summoner) )
        {
            //SpeakString( "No valid targets left; attacking summoner" );
            //SpeakString( GetName(summoner) );
            enemy = summoner;
        }
        else UnsummonMe();
    }

    return enemy;
}

void UnsummonMe()
{
    DestroyObject( OBJECT_SELF );
}