CREATE TABLE IF NOT EXISTS stations
(
    station_code VARCHAR(20)  NOT NULL,
    station_name VARCHAR(100) ,
    station_zone VARCHAR(20) ,
    station_state VARCHAR(20) ,
    station_address VARCHAR(150) ,
    CONSTRAINT stations_pkey PRIMARY KEY (station_code)
)


CREATE TABLE IF NOT EXISTS passengers
(
    passenger_id integer NOT NULL,
    passenger_fname VARCHAR(50) ,
    passenger_lname VARCHAR(50) ,
    passenger_phone VARCHAR(20) ,
    passenger_email VARCHAR(100) ,
    passenger_city VARCHAR(100) ,
    passenger_state VARCHAR(100) ,
    CONSTRAINT passengers_pkey PRIMARY KEY (passenger_id)
)


CREATE TABLE IF NOT EXISTS employees
(
    emp_id integer NOT NULL,
    station_id VARCHAR(20) ,
    emp_fname VARCHAR(50) ,
    emp_lname VARCHAR(50) ,
    emp_contact_number VARCHAR(15)  NOT NULL,
    emp_email VARCHAR(50) ,
    emp_yoj integer,
    emp_city VARCHAR(30) ,
    emp_state VARCHAR(30) ,
    emp_designation VARCHAR(30) ,
    emp_salary integer,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_id),
    CONSTRAINT employees_station_id_fkey FOREIGN KEY (station_id)
        REFERENCES stations (station_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)


CREATE TABLE IF NOT EXISTS trains
(
    train_number VARCHAR(20) NOT NULL,
    train_name VARCHAR(100) NOT NULL,
    from_station_code VARCHAR(20) ,
    departure time without time zone,
    to_station_code VARCHAR(20) ,
    arrival time without time zone,
    distance smallint,
    duration_hours smallint,
    duration_minutes smallint,
    sleeper boolean,
    chair_car boolean,
    first_class boolean,
    first_ac boolean,
    second_ac boolean,
    third_ac boolean,
    return_train VARCHAR(20) ,
    train_type VARCHAR(20) ,
	total_seats smallint,
    CONSTRAINT trains_pkey PRIMARY KEY (train_number),
    CONSTRAINT trains_from_station_code_fkey FOREIGN KEY (from_station_code)
        REFERENCES stations (station_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT trains_to_station_code_fkey FOREIGN KEY (to_station_code)
        REFERENCES stations (station_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)


CREATE TABLE IF NOT EXISTS schedules
(
    schedule_id character varying(20) NOT NULL,
    train_number character varying(20) ,
    station_code character varying(20) ,
    arrival time without time zone,
    departure time without time zone,
    CONSTRAINT schedules_pkey PRIMARY KEY (schedule_id),
    CONSTRAINT schedules_station_code_fkey FOREIGN KEY (station_code)
        REFERENCES stations (station_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)


CREATE TABLE IF NOT EXISTS reservations
(
	reservation_id integer NOT NULL,
    passenger_id integer NOT NULL,
    date date NOT NULL,
    train_number VARCHAR(50)  NOT NULL,
    departure time without time zone,
    from_station_code VARCHAR(20) ,
    to_station_code VARCHAR(20) ,
    arrival time without time zone,
    seat_number VARCHAR(10) ,
    CONSTRAINT reservations_pkey PRIMARY KEY (reservation_id),
    CONSTRAINT res_pid_fkey FOREIGN KEY (passenger_id)
        REFERENCES passengers (passenger_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT res_train_number_fkey FOREIGN KEY (train_number)
        REFERENCES trains (train_number) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)


CREATE TABLE IF NOT EXISTS seat_availability
(
    train_number VARCHAR(20)  NOT NULL,
    date date NOT NULL,
    total_available integer,
    CONSTRAINT seat_availability_pkey PRIMARY KEY (train_number, date),
    CONSTRAINT seat_train_number_fkey FOREIGN KEY (train_number)
        REFERENCES trains (train_number) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

CREATE OR REPLACE FUNCTION update_seat_availability()
RETURNS TRIGGER AS $$
BEGIN
    -- Reduce the total_available in seat_availability
    UPDATE seat_availability
    SET total_available = total_available - 1
    WHERE train_number = NEW.train_number AND date = NEW.date;

    -- Return the new row
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reduce_seat_availability
AFTER INSERT ON Reservations
FOR EACH ROW
EXECUTE FUNCTION update_seat_availability();