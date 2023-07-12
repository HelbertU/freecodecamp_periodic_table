#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
NUMBER_FUNCTION(){
  NUMBER_CORRECTION=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$1; ")
  echo $NUMBER_CORRECTION 

}
if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else 

  SYMBOL_CORRECTION=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'; ")
 
  if [[ -z $SYMBOL_CORRECTION ]] 
  then 
    NAME_CORRECTION=$($PSQL "SELECT name FROM elements WHERE name='$1'")

    if [[ -z $NAME_CORRECTION ]]
    then
      if [[ $1 =~ ^[0-9]+$ ]]
      then
        NUMBER_CORRECTION=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
        if [[ -z $NUMBER_CORRECTION ]]
        then 
        echo "I could not find that element in the database."
        else
        TOTAL_DATA=$($PSQL "SELECT elements.atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$1 ; ")
        echo $TOTAL_DATA | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius." 
        done 
        fi
      else
        echo "I could not find that element in the database."
      fi
    else
      TOTAL_DATA=$($PSQL "SELECT elements.atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE name='$1' ; ")
    echo $TOTAL_DATA | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius." 
    done 
    fi
  else
    TOTAL_DATA=$($PSQL "SELECT elements.atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON properties.type_id=types.type_id WHERE symbol='$1' ; ")
    echo $TOTAL_DATA | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done 
  fi
fi
