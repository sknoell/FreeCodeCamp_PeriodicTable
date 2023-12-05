#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

OUTPUT_ELEMENT() {
  TYPE=$($PSQL "select type from properties full join types on properties.type_id=types.type_id where atomic_number=$1")
  MASS=$($PSQL "select atomic_mass from properties where atomic_number=$1")
  MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$1")
  BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$1")
  echo "The element with atomic number $1 is $2 ($3). It's a $TYPE, with a mass of $MASS amu. $2 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

#If Input Argument is provided
if [[ $1 ]]
then

  #If Input is a number
  if [[ $1 =~ ^[0-9]+$ ]] 
  then
    ATOMIC_NUMBER=$1
    SYMBOL=$($PSQL "Select symbol from elements where atomic_number=$1")
    #If symbol not in database
      if [[ -z $SYMBOL ]]
      then
        echo "I could not find that element in the database."

      else
        NAME=$($PSQL "Select name from elements where atomic_number=$1")
        OUTPUT_ELEMENT $ATOMIC_NUMBER $NAME $SYMBOL
      fi
  #If Symbol provided
  elif [[ $1 =~ ^[A-Z][a-z]{0,1}$ ]]
  then
    SYMBOL=$1
    ATOMIC_NUMBER=$($PSQL "Select atomic_number from elements where symbol='$SYMBOL'")

    #If Atomic number not in database
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."

    else
    NAME=$($PSQL "Select name from elements where atomic_number=$ATOMIC_NUMBER")
    OUTPUT_ELEMENT $ATOMIC_NUMBER $NAME $SYMBOL

    fi
  #Name provided
  else
    NAME=$1
    ATOMIC_NUMBER=$($PSQL "Select atomic_number from elements where name='$NAME'")
   #If Atomic number not in database
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."

    else
    SYMBOL=$($PSQL "Select symbol from elements where atomic_number=$ATOMIC_NUMBER")
    OUTPUT_ELEMENT $ATOMIC_NUMBER $NAME $SYMBOL

    fi

  fi


else
echo Please provide an element as an argument.
fi 




