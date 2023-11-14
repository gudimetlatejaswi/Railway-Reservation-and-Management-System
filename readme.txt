This is a readme file that explains how the tables are created and the data is inserted.

Below is the list of tables in the database:
• trains (train_number, train_name, from_station_code, departure, to_station_code, arrival, distance, duration_hours, duration_minutes, sleeper, chair_car, first_class, first_ac, second_ac, third_ac, return_train, train_type, total_seats) 
• stations (station_code, station_name,station_zone,station_state,station_address)
• schedules (schedule_id, train_number, station_code, arrival,departure)
• passengers (passenger_id, passenger_fname ,passenger_lname ,passenger_phone ,passenger_email ,passenger_city ,passenger_state )
• employees (emp_id, station_id, emp_fname, emp_lname, emp_contact_number,emp_email, emp_yoj, emp_city, emp_state, emp_designation, emp_salary)
• seat_availability (train_number, date,total_available)
• reservations (reservation_id, passenger_id, date, train_number, departure, from_station_code, to_station_code, arrival,  seat_number)


To insert the data into these tables, we have used the csv files and also the Faker Module in Python. 
The create and load files are provided along with this package to directly load the data into database without the need of running the python code again.

Please execute the below files in order : 

1. Create DB.sql

This file has the SQL statement to create a database.


2. Create Tables.sql

This SQL file consists of CREATE statements to create the tables along with primary and foreign key constraints.


3. Load Tables.sql

This SQL file consists of INSERT statements for all the tables.

Executing the above files will create the Database, create the tables and load the data into them (along with the constraints).



