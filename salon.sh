#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e  "\n~~~~~ Long Hair Salon ~~~~~\n"

MAIN_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # opening message
  echo -e "\nWelcome to Long Hair Salon, how can I help you?"

  # show services
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME BAR
  do
    echo "$SERVICE_ID) $NAME"
  done
  # selecting service
  read SERVICE_ID_SELECTED
  
  # chceck if option selected is number and is on the list
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ || -z $($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'") ]]
  then
    # if it is not on the list sent to main menu with message "Sorry, no such service"
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # getting phone number
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
 
    # checking if phone number is in database
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'" | sed 's/ //g')
    

    if [[ -z $CUSTOMER_NAME ]]
    then 
      # get customer name
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME 
      CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed 's/ //g')

      #insert customer info into customers
      INSERTING_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

      # get service name
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'" | sed 's/ //g')
      
      # get time of the visit
      echo -e "\nWhat time would you like your, $SERVICE_NAME $CUSTOMER_NAME?"
      read SERVICE_TIME

      # get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'"| sed 's/ //g')
  
      # insert data into appointments
      APPOINTMENT_INSERTION=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'" | sed 's/ //g')

      # get service name
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'" | sed 's/ //g')
      
      # get time of the visit
      echo -e "\nWhat time would you like your, $SERVICE_NAME $CUSTOMER_NAME?"
      read SERVICE_TIME

      # get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'"| sed 's/ //g')
  
      # insert data into appointments
      APPOINTMENT_INSERTION=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      exit 0
    fi
  fi

}

MAIN_MENU 
