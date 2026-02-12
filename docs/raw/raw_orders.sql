/*
===============================================================================
Table: raw_orders
Layer: RAW
Database: PostgreSQL
Domain: Orders
-------------------------------------------------------------------------------
Purpose:
Preserve raw records of the order domain without transformation, supporting
traceability, auditing, and reprocessing.

Data Characteristics:
- Does not validate data and may contain inconsistencies
  (e.g., missing fields, non-standardized data, duplicates).
- Ingestion velocity is hybrid, combining streaming (event-driven) and
  batch processing (snapshots).
- Data volume depends on event occurrence and snapshot frequency.
- Designed to tolerate upstream schema changes and support scalability
  as data volume grows.

Grain:
- One row per ingested record, representing either an event or a snapshot.

Key Fields:
- order_id: Business key used to identify an order.
- load_id: Surrogate technical key used for ingestion traceability and auditing.

Constraints & Guarantees:
- Preserves the original ingestion payload for traceability.
- Append-only, ensuring data immutability and enabling auditing and reprocessing.
- Guarantees the ingestion timestamp for temporal consistency.

Downstream Usage:
- Serves as a source for downstream layers.
- Used for traceability, auditing, and reprocessing.
===============================================================================
*/

CREATE TABLE raw_orders (
    order_id VARCHAR(255),
    load_id VARCHAR(50),
    raw_payload JSONB,
    data_type VARCHAR(20) CHECK (data_type IN ('EVENT', 'SNAPSHOT')) NOT NULL,
    event_timestamp TIMESTAMPTZ,
    ingestion_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    source_system VARCHAR(255),
    source_filename VARCHAR(255)
);
