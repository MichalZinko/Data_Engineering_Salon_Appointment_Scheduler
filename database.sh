#! /bin/bash
#variable to get to SQL
PSQL="psql --username=freecodecamp --dbname=postgres" 

#variable to get to salon database
PSQL_SALON="psql --username=freecodecamp --dbname=salon -c"


# chceck if database exist 
$PSQL -lqt | cut -d \| -f 1 | grep -qw salon
SALON_DATABASE_EXISTANCE=$?

if [[ $SALON_DATABASE_EXISTANCE == 0 ]]
then
  # if exists delete
 echo $($PSQL -t --no-align -c "DROP DATABASE salon;")
fi
# create database 
echo $($PSQL -t --no-align -c "CREATE DATABASE salon;")

# create tables
echo $($PSQL_SALON "CREATE TABLE customers(customer_id SERIAL PRIMARY KEY NOT NULL, name VARCHAR(20) NOT NULL, phone VARCHAR(12) UNIQUE NOT NULL)")
echo $($PSQL_SALON "CREATE TABLE appointments(appointment_id SERIAL PRIMARY KEY NOT NULL, customer_id INT NOT NULL, service_id INT NOT NULL, time VARCHAR(20) NOT NULL)")
echo $($PSQL_SALON "CREATE TABLE services(service_ID SERIAL PRIMARY KEY NOT NULL, name VARCHAR(20) NOT NULL)")
echo $($PSQL_SALON "ALTER TABLE appointments ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id)")
echo $($PSQL_SALON "ALTER TABLE appointments ADD FOREIGN KEY(service_id) REFERENCES serviceS(service_id)")

# insert data
echo $($PSQL_SALON "INSERT INTO services(name) VALUES('cut'), ('color'), ('perm')")