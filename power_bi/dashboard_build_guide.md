# Power BI dashboard build guide

## Data model
Load all four CSVs. Rename queries to `FactFlights`, `FactBookings`, `DimAirports`, `DimAirlines`.
Create two airport dimension copies: `DimOriginAirport` and `DimDestinationAirport`.
Relationships:
- DimAirlines[airline_id] 1:* FactFlights[airline_id]
- DimOriginAirport[airport_code] 1:* FactFlights[origin_airport]
- DimDestinationAirport[airport_code] 1:* FactFlights[destination_airport]
- FactFlights[flight_id] 1:* FactBookings[flight_id] (single direction)
- Date[Date] 1:* FactFlights[flight_date]

Keep flight and booking measures separate: booking rows can multiply flight rows in a joined table and inflate flight revenue.

## Page 1 — Executive Overview
KPI cards: Scheduled Flights, Departure OTP %, Load Factor %, Cancellation Rate %, Flight Revenue (INR).
Line chart: monthly flight revenue. Bar chart: revenue by airline. Bar chart: passengers by origin city.
Slicers: date, airline, origin city.

## Page 2 — Operations & Delays
Cards: Average Departure Delay, Total Delay Minutes, Cancelled Flights.
Column chart: average delay by departure time band. Bar chart: delay reason by total delay minutes.
Matrix: route with flights, OTP, load factor, average delay.
Slicers: airline, route, date.

## Page 3 — Route & Revenue
Bar chart: top 10 routes by flight revenue. Scatter: load factor vs average fare, bubble size by passengers.
Monthly revenue trend and route detail table.

## Page 4 — Booking Insights
Cards: Eligible Bookings, Booking Revenue, Ancillary Revenue.
Stacked bar: booking channel by cabin class. Donut: booking status.
Bar chart: ancillary revenue by channel.

## Design and storytelling
Use an airline-inspired navy/blue/teal palette, clear titles and INR formatting. Add tooltip definitions for OTP and load factor, conditional formatting, reset filters and page navigation. Validate totals against SQL.
Tell the story from operational baseline → delay bottlenecks → route economics → booking mix → quantified improvement scenarios. Label scenarios as estimates, never realized savings.
