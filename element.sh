#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 ]]
then

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get ATOMIC_NUMBER by number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  else 
    # check number of characters
    CHARACTER_COUNT_RESULT=$(echo -n $1 | wc -c)
    # if a word
    if [[ $CHARACTER_COUNT_RESULT -gt 2 ]]
    then
      # get ATOMIC_MASS by name
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
    else
      # get ATOMIC_MASS by symbol
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
    fi
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo -e "I could not find that element in the database."
  else

    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")

    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER;")
  
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")

    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
