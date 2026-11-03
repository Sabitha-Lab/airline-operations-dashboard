-- 1. OTP by airline (departure delay <= 15 min)
SELECT a.airline_name,
 ROUND(100.0*AVG(CASE WHEN f.delay_minutes<=15 THEN 1.0 ELSE 0.0 END),2) otp_pct
FROM fact_flights f JOIN dim_airlines a USING(airline_id)
WHERE f.cancelled_flag=0 GROUP BY a.airline_name ORDER BY otp_pct DESC;

-- 2. Route performance and revenue
SELECT origin_airport,destination_airport,COUNT(*) flights,SUM(passengers) passengers,
 ROUND(100.0*SUM(passengers)::numeric/NULLIF(SUM(aircraft_capacity),0),2) load_factor_pct,
 ROUND(SUM(flight_revenue_inr),0) flight_revenue_inr,ROUND(AVG(delay_minutes),1) avg_delay_min
FROM fact_flights WHERE cancelled_flag=0
GROUP BY origin_airport,destination_airport HAVING COUNT(*)>=30
ORDER BY flight_revenue_inr DESC;

-- 3. Delay root causes
SELECT delay_reason,COUNT(*) flights,ROUND(AVG(delay_minutes),1) avg_delay_min,
 SUM(delay_minutes) total_delay_min
FROM fact_flights WHERE cancelled_flag=0 AND delay_minutes>0
GROUP BY delay_reason ORDER BY total_delay_min DESC;

-- 4. Departure time bands
WITH bands AS (
 SELECT cancelled_flag,delay_minutes,
 CASE WHEN EXTRACT(HOUR FROM scheduled_departure) BETWEEN 5 AND 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM scheduled_departure) BETWEEN 11 AND 16 THEN 'Afternoon'
      ELSE 'Evening' END departure_band
 FROM fact_flights
)
SELECT departure_band,COUNT(*) flights,ROUND(AVG(delay_minutes),1) avg_delay_min
FROM bands WHERE cancelled_flag=0 GROUP BY departure_band ORDER BY flights DESC;

-- 5. Booking channel performance (booking-grain revenue)
SELECT booking_channel,cabin_class,COUNT(*) bookings,
 ROUND(SUM(ticket_fare_inr+ancillary_revenue_inr),0) booking_revenue_inr
FROM fact_bookings WHERE booking_status IN ('Confirmed','Flown')
GROUP BY booking_channel,cabin_class ORDER BY booking_revenue_inr DESC;

-- 6. Window function: rank routes by revenue within origin
WITH route_rev AS (
 SELECT origin_airport,destination_airport,SUM(flight_revenue_inr) revenue_inr
 FROM fact_flights WHERE cancelled_flag=0 GROUP BY origin_airport,destination_airport
)
SELECT *,DENSE_RANK() OVER(PARTITION BY origin_airport ORDER BY revenue_inr DESC) route_rank
FROM route_rev ORDER BY origin_airport,route_rank;

-- 7. CTE + LAG: monthly revenue change
WITH monthly AS (
 SELECT DATE_TRUNC('month',flight_date)::date month_start,SUM(flight_revenue_inr) revenue_inr
 FROM fact_flights WHERE cancelled_flag=0 GROUP BY 1
), prior AS (
 SELECT *,LAG(revenue_inr) OVER(ORDER BY month_start) previous_month_revenue FROM monthly
)
SELECT month_start,ROUND(revenue_inr,0) revenue_inr,
 ROUND(100.0*(revenue_inr-previous_month_revenue)/NULLIF(previous_month_revenue,0),2) mom_change_pct
FROM prior ORDER BY month_start;
