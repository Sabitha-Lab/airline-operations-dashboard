-- PostgreSQL schema
CREATE TABLE dim_airports (airport_code VARCHAR(3) PRIMARY KEY, city VARCHAR(80), country VARCHAR(80), city_tier VARCHAR(20));
CREATE TABLE dim_airlines (airline_id VARCHAR(5) PRIMARY KEY, airline_name VARCHAR(80));
CREATE TABLE fact_flights (
 flight_id VARCHAR(10) PRIMARY KEY, flight_date DATE NOT NULL,
 airline_id VARCHAR(5) REFERENCES dim_airlines(airline_id),
 origin_airport VARCHAR(3) REFERENCES dim_airports(airport_code),
 destination_airport VARCHAR(3) REFERENCES dim_airports(airport_code),
 scheduled_departure TIMESTAMP, actual_departure TIMESTAMP,
 scheduled_arrival TIMESTAMP, actual_arrival TIMESTAMP,
 distance_km INTEGER, aircraft_capacity INTEGER, passengers INTEGER,
 delay_minutes INTEGER, cancelled_flag INTEGER,
 average_ticket_fare_inr NUMERIC(12,2), flight_revenue_inr NUMERIC(14,2), delay_reason VARCHAR(40)
);
CREATE TABLE fact_bookings (
 booking_id VARCHAR(12) PRIMARY KEY, flight_id VARCHAR(10) REFERENCES fact_flights(flight_id),
 booking_date DATE, passenger_type VARCHAR(20), booking_channel VARCHAR(30),
 cabin_class VARCHAR(20), booking_status VARCHAR(20),
 ticket_fare_inr NUMERIC(12,2), ancillary_revenue_inr NUMERIC(12,2)
);
-- Import CSVs using pgAdmin or psql \copy:
-- \copy dim_airports FROM '/path/dim_airports.csv' CSV HEADER
-- \copy dim_airlines FROM '/path/dim_airlines.csv' CSV HEADER
-- \copy fact_flights FROM '/path/fact_flights.csv' CSV HEADER
-- \copy fact_bookings FROM '/path/fact_bookings.csv' CSV HEADER
