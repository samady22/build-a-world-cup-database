#! /bin/bash

#create a dump database using this command in bash terminal not psql.
#pg_dump -cC --inserts -U freecodecamp worldcup > worldcup.sql

#you can rebuild a database using this comman in where .sql is not in psql. 
#psql -U postgres < worldcup.sql

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo "$($PSQL "TRUNCATE games, teams")"

cat games.csv | while IFS="," read  YEAR ROUND WINNER OPPONENT W_GOAL O_GOAL 
do 
  if [[ $YEAR != year ]]
  then
  #get winner id
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  #if not found
  if [[ -z $WINNER_ID ]] 
  then 
  #insert winner team
  INSERT_TEAMS_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
  if [[ $INSERT_TEAMS_RESULT == "INSERT 0 1" ]]
  then
  echo "Inserted into teams, $WINNER"
  fi
 #get new winner it
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  fi


  #get opponent id
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  #if not found
  if [[ -z $OPPONENT_ID ]]
  then
  #insert oppoment team
  INSERT_TEAMS_RESULT="$($PSQL "insert into teams(name) values('$OPPONENT')")"
   if [[ $INSERT_TEAMS_RESULT == "INSERT 0 1" ]]
  then
    echo "Inserted into teams $OPPONENT"
    fi
  #get new opponent id
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  fi

  #insert into games
  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOAL, $O_GOAL)")
  if [[ $INSERT_GAMES_RESULT == 'INSERT 0 1' ]]
  then 
  echo "Inserted into games, $YEAR : '$ROUND' : '$WINNER' : '$OPPONENT'"
  fi
  fi
done 



# Do not change code above this line. Use the PSQL variable above to query your database.
