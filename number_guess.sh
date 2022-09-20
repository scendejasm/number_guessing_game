#!/bin/bash 
# $PSQL variable for interacting with the DB
PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

echo -e "\n~~~~ Number Guessing Game ~~~~\n"

main_menu () {
  echo Enter your username: 
  read PLAYER
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$PLAYER';")
  if [[ -z $USER_ID ]]
  then
    echo -e "\nWelcome, $PLAYER! It looks like this is your first time here."
    INSERT_PLAYER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$PLAYER');")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$PLAYER';")
    guessing_game $USER_ID
  else
    echo -e "\nWelcome back, $PLAYER"
    guessing_game $USER_ID 
  fi
}

guessing_game () {
  echo -e "\n TEST: $1 :Endgame"
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    echo $1 is a user_id
  else
    echo $1 is a username
  fi
}

main_menu