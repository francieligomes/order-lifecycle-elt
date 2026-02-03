# Orders — Raw Layer

## Description
Represents the raw ingestion of order data as received from source systems.
The original format and granularity are preserved to support historical retention,
auditing, and reprocessing. No business rules or transformations are applied at this stage.

## Layer
RAW

## Grain
- One row per order event extracted from the source system

## Source
- Operational orders system

## Ingestion Behavior
- Append-only
- No updates or deletes
- No business logic applied
- Reprocessing may generate duplicate records

## Business Rules
- No business rules are applied at this layer

## Data Quality Expectations
- Data types and values are not validated
- Nulls and inconsistencies are allowed
- Schema may evolve over time according to the source system

## Notes
- This layer serves as a historical record of source data
- Used for reprocessing, auditing, and data lineage tracking
