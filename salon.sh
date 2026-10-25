#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAKE_APPOINTMENT(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  CREATE_APPOINTMENT(){
    echo -e "\nWhat time would you like to $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name = '$SERVICE_NAME'")
    APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
    if [[ $APPOINTMENT_RESULT == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  }

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    CUSTOMER_NAME_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    if [[ $CUSTOMER_NAME_RESULT == "INSERT 0 1" ]]
    then
      CREATE_APPOINTMENT
    fi
  else
    CREATE_APPOINTMENT
  fi
}

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to My Salon, how can I help you?"

  SERVICES=$($PSQL "SELECT service_id, name FROM services")

  if [[ -z $SERVICES ]]
  then
    INSERT_SERVICE=$($PSQL "INSERT INTO services(name) VALUES('cut'), ('color'), ('perm'), ('style'), ('trim')")
    SERVICES=$($PSQL "SELECT service_id, name FROM services")
  fi

  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT ;;
    2) MAKE_APPOINTMENT ;;
    3) MAKE_APPOINTMENT ;;
    4) MAKE_APPOINTMENT ;;
    5) MAKE_APPOINTMENT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

MAIN_MENU