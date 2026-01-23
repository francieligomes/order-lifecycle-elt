# Logical Data Flow – Event-Driven Order Pipeline

## Purpose

This diagram represents the high-level logical flow of data across an event-driven data pipeline, from raw ingestion to final consumption layers.

## Logical Flow Overview
[ Business Events ]
        |
        v
+-------------------+
|   RAW_EVENTS      |
|-------------------|
| event_id          |
| order_id          |
| event_type        |
| event_timestamp   |
| payload           |
+-------------------+
        |
        v
+-------------------+
| STG_EVENTS        |
|-------------------|
| event_id          |
| order_id          |
| event_type        |
| event_timestamp   |
| normalized fields |
| is_valid_event    |
| is_duplicate      |
+-------------------+
        |
        v
+-------------------+
| SCD_ORDERS        |
|-------------------|
| scd_id            |
| order_id          |
| user_id           |
| order_status      |
| order_amount      |
| valid_from        |
| valid_to          |
| is_current        |
+-------------------+
        |
        v
+-------------------+
| SNAPSHOT_ORDERS   |
|-------------------|
| snapshot_date     |
| order_id          |
| user_id           |
| order_status      |
| order_amount      |
+-------------------+
        |
        v
+-------------------+
| FINAL_ORDERS      |
|-------------------|
| order_id          |
| user_id           |
| order_date        |
| order_amount      |
+-------------------+

## Layer Responsibilities

- RAW_EVENTS: Preserves immutable event records exactly as received, ensuring reliable temporal ordering. This layer serves as the foundation for CDC-like behavior and enables full state reconstruction through event replay.

- STG_EVENTS: Responsible for normalizing and validating incoming events, ensuring idempotence and logical discarding of invalid or duplicate records without altering the RAW_EVENTS layer.

- SCD_ORDERS: Responsible for maintaining the historical versioning of order data, using the fields valid_from, valid_to, and is_current to ensure that only one version of each order is active at a time, while closing previous versions when changes occur.

- SNAPSHOT_ORDERS: Responsible for capturing the state of an entity at specific points in time, independently of whether changes occur or not. It is used to represent how an order looked at a given moment.

- FINAL_ORDERS: The layer where business rules and analytical metrics are defined, following the company’s policies.

## Why Event-Driven + SCD + Snapshots?

This combination is powerful for historical data storage and system observability, as each layer answers a specific question and complements the others.

The Events layer records when changes occur, providing a precise view of how orders evolve over time. The SCD layer preserves the full version history of those orders, while Snapshots capture how the system looked at specific points in time.
