# Orders Domain – Conceptual Model

## Purpose
This domain represents Order data related to users, payments and addresses, covering the lifecycle end-to-end status of orders using event-driven architecture to capture changes based on timestamp. At this stage this bounded context does not contain data governance.

## Core Concepts
- Order: An entity that represents a commercial transaction performed by a user.
- User: The customer responsible for placing an order.
- Address: The address associated with an order.
- Payment: Represents payment events associated with a user.
- Event: An immutable fact that represents a change in an order over time.
   
## Order Lifecycle
The order lifecycle is based on events recording when a change occurs in the versionable attributes of an order. This process results in historical data preservation.

## Why Event-Driven
To ensure data quality and maintain lineage, this project uses events instead of updates directly in the order entity. This approach enables traceability and retains immutable records for auditing and reprocessing.
