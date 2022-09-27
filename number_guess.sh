#!/bin/bash 
# $PSQL variable for interacting with the DB
PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

echo -e "\n~~~~ Number Guessing Game ~~~~\n"

main_menu () {
  echo Enter your username: 
  read PLAYER
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$PLAYER';")
  # If player is not in database
  if [[ -z $USER_ID ]]
  then
    echo -e "\nWelcome, $PLAYER! It looks like this is your first time here."
    INSERT_PLAYER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$PLAYER');")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$PLAYER';")
    guessing_game $USER_ID
  else # Get player stats 
    GAMES_PLAYED=$($PSQL "SELECT count(game_id) FROM GAMES WHERE user_id=$USER_ID")
    BEST_GAME=$($PSQL "SELECT min(user_guesses) FROM GAMES WHeRE user_id=$USER_ID")
    echo -e "\n"
    echo "Welcome back, $PLAYER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    
    guessing_game $USER_ID 
  fi
}

guessing_game () {
  SECRET_NUMBER=$[ $RANDOM % 1000 + 1 ]
  NUMBER_OF_GUESSES=1
  echo -e "\n"
  echo -e "Guess the secret number between 1 and 1000:"
  echo -e "\nHINT: The secret number is $SECRET_NUMBER \n"
  read PLAYER_GUESS
  while [[ $PLAYER_GUESS != $SECRET_NUMBER ]]
  do
    if ! [[ $PLAYER_GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "That is not an integer, guess again:"
      NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))
      #echo $NUMBER_OF_GUESSES
      read PLAYER_GUESS
    elif [ $PLAYER_GUESS -gt $SECRET_NUMBER ]
    then
      echo -e "It's lower than that, guess again:"
      NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))
      #echo $NUMBER_OF_GUESSES
      read PLAYER_GUESS
    elif [ $PLAYER_GUESS -lt $SECRET_NUMBER ]
    then
      echo -e "It's higher than that, guess again:"
      NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))
      #echo $NUMBER_OF_GUESSES
      read PLAYER_GUESS
    fi
  done

  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, user_guesses, user_guessed_secret, secret_number) VALUES($1, $NUMBER_OF_GUESSES, True, $SECRET_NUMBER)")
  #echo $INSERT_GAME_RESULT
  # echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
  # echo -e "\n"
}

main_menu