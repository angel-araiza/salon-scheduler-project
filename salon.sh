#! /bin/bash
PSQL="psql -U freecodecamp -d salon -t -c"

SERVICE_ID=$($PSQL "SELECT service_id, name FROM services")
SERVICE_ID_F=$(echo "$SERVICE_ID" | sed 's/ |/)/g')

echo -e "Please pick a service:\n"
echo "$SERVICE_ID_F"
read SERVICE_ID_SELECTED

NOT_OPTION() {
  echo -e "$SERVICE_ID_F"
  echo "$1"
}

if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
then
  NOT_OPTION "That is not a listed service."
else
  echo "Please enter your phone number:"
  read CUSTOMER_PHONE

  CHECK_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CHECK_PHONE ]]
  then
    echo "What is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  else 
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  echo "When would you like to schedule your appointment?"
  read SERVICE_TIME

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  echo "I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
fi
