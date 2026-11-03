# Airline Operations & Revenue Tracking System Dashboard

End-to-end BI portfolio project using SQL, Advanced Excel, Power Query, Power BI and DAX.

> **Data disclosure:** All included records are synthetic, generated for portfolio practice. They do not represent a real airline or real passengers. Present all findings as simulated results. Do not claim a real-world 14% revenue gain unless a documented scenario calculation from your analysis supports it.

## Dataset
- `fact_flights.csv`: 30,000 flight-operation records
- `fact_bookings.csv`: 100,000 passenger booking records
- `dim_airports.csv`: airport lookup
- `dim_airlines.csv`: airline lookup
- `data_dictionary.csv`: field descriptions
- Total fact records: 130,000. Coverage: calendar year 2025. Currency: INR.

## Business questions
1. What is departure on-time performance (OTP)?
2. Which routes and departure time bands experience the most delays?
3. Which routes carry the most passengers and have the highest load factor?
4. Which routes and airlines generate the highest flight revenue?
5. How do booking channel, cabin class and booking status affect booking revenue?
6. Where could revenue be improved through load-factor or ancillary-sales scenarios?

## Suggested star schema
- `FactFlights` (one row per flight; grain = flight)
- `FactBookings` (one row per booking; grain = booking)
- `DimAirports` (role-playing copies for origin and destination)
- `DimAirlines`
- `Date` calendar dimension

Keep the two fact tables at their own grains. Do not join booking rows to flights and then sum flight revenue, as this duplicates flight-level values.

## Repository layout
```text
airline-operations-revenue-dashboard/
├── data/                 # synthetic CSV data + data dictionary
├── sql/                  # schema, quality checks, analysis queries
├── power_bi/             # DAX, Power Query M, dashboard guide
├── excel/                # Excel analysis exercises
└── README.md
```

## Getting started
1. Create a PostgreSQL database, e.g. `airline_analytics`.
2. Run `sql/01_create_tables.sql`.
3. Import the four CSV files into their matching tables using pgAdmin Import/Export or `\copy`.
4. Run `sql/02_data_quality_checks.sql`, then `sql/03_business_analysis.sql`.
5. In Power BI Desktop, load the CSVs or connect to PostgreSQL.
6. Apply the model and report design in `power_bi/dashboard_build_guide.md`.
7. Add measures from `power_bi/dax_measures.dax` and validate against SQL.

## KPI definitions
- **Departure OTP:** non-cancelled flights with departure delay <= 15 minutes / all non-cancelled flights.
- **Load factor:** passengers / aircraft capacity, excluding cancelled flights.
- **Cancellation rate:** cancelled scheduled flights / all scheduled flights.
- **Average delay:** average departure delay for non-cancelled flights.
- **Flight revenue:** sum of flight-level revenue in `FactFlights`.
- **Booking revenue:** ticket fare + ancillary revenue for Confirmed or Flown bookings. It is a separate booking-grain view; do not add it to flight revenue.


