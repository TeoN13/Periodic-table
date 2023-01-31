PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ $1 ]]
then
  # check if element is in db
  # check if input is digit or text
  if [[ '^[1-9]+$' =~ $1 ]]
  then
    ELEMENT_ID=$($PSQL "SELECT atomic_number from elements WHERE atomic_number=$1;")
  else
    ELEMENT_ID=$($PSQL "SELECT atomic_number from elements WHERE symbol='$1' OR name='$1';")
  fi
  if [[ -z $ELEMENT_ID ]]
  then
    # element not in db
    echo "I could not find that element in the database."
  else
    # element found
    # get data from elements table
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT_ID")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT_ID")
    # get data from properties table
    ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT_ID")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$ELEMENT_TYPE_ID")
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_ID")
    ELEMENT_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")
    ELEMENT_BIOL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")
    echo "The element with atomic number $ELEMENT_ID is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELT celsius and a boiling point of $ELEMENT_BIOL celsius."
  fi
else
  echo "Please provide an element as an argument."
fi
