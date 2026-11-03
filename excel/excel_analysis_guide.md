# Advanced Excel analysis guide

Import CSVs as Excel Tables: `tblFlights`, `tblBookings`, `tblAirports`, `tblAirlines`.

## Useful Excel 365 formulas
- Route: `=[@origin_airport]&" - "&[@destination_airport]`
- Departure hour: `=HOUR([@scheduled_departure])`
- Time band: `=IFS(HOUR([@scheduled_departure])<11,"Morning",HOUR([@scheduled_departure])<17,"Afternoon",TRUE,"Evening")`
- On-time flag: `=--AND([@cancelled_flag]=0,[@delay_minutes]<=15)`
- Load factor: `=IFERROR([@passengers]/[@aircraft_capacity],0)`
- Airline lookup: `=XLOOKUP([@airline_id],tblAirlines[airline_id],tblAirlines[airline_name],"Unknown")`
- Origin city: `=XLOOKUP([@origin_airport],tblAirports[airport_code],tblAirports[city],"Unknown")`

## PivotTable practice
1. Flight count and average delay by airline.
2. OTP by origin and departure time band.
3. Load factor and revenue by route.
4. Booking count and booking revenue by channel and cabin class.
5. Ancillary revenue by booking channel.

Validate row counts, unique IDs, blanks, invalid passenger counts and cancelled flights. Do not add flight-level revenue and booking-level revenue together.
