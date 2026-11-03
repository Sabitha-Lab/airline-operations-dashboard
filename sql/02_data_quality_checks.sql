-- Row counts (expected: 30,000 flights; 100,000 bookings)
SELECT 'flights' table_name, COUNT(*) row_count FROM fact_flights
UNION ALL SELECT 'bookings', COUNT(*) FROM fact_bookings;
-- Duplicate primary keys (should return no rows)
SELECT flight_id, COUNT(*) FROM fact_flights GROUP BY flight_id HAVING COUNT(*)>1;
SELECT booking_id, COUNT(*) FROM fact_bookings GROUP BY booking_id HAVING COUNT(*)>1;
-- Missing critical fields
SELECT COUNT(*) FILTER (WHERE flight_date IS NULL) missing_date,
       COUNT(*) FILTER (WHERE origin_airport IS NULL) missing_origin
FROM fact_flights;
-- Invalid passenger counts
SELECT COUNT(*) invalid_capacity
FROM fact_flights WHERE passengers<0 OR passengers>aircraft_capacity;
-- Orphan bookings (should be zero)
SELECT COUNT(*) orphan_bookings FROM fact_bookings b
LEFT JOIN fact_flights f ON b.flight_id=f.flight_id WHERE f.flight_id IS NULL;
