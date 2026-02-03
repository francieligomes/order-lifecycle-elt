/*
===============================================================================
Table: orders
Layer: FINAL / CORE ENTITY
Domain: Orders
Description:
    This dataset represents the latest valid state of an order. Exposing only analytics-ready data for business intelligence, in accordance with organizational policies.
Grain:
    - one row per order

Primary Key:
    - order_id

Source:
    - SCD orders with daily snapshots 

Business Rules:
Defines the business rules applied to curated order data.

-  return only the latest version of an order
-  return orders in final business states (paid, shipped, delivered, completed)
-  ensure payment_status is consistent with order_status

SCD Behavior:

SCD behavior is based on SCD Type 2 to ensure historical records. When a versioned field changes, the current record is expired by updating its valid_to date and setting is_current to false. Additionally, the pipeline captures daily snapshots to support historical traceability.

Data Quality Constraints:

To ensure data reliability, the pipeline enforces the following data quality constraints.
- order_id must be unique.
- user_id must reference a valid record in the users domain.
- mandatory attributes must not contain NULL values.
- for each versioned record, valid_from must be less than or equal to valid_to.
- order_date must be less than or equal to created_at.
- currency values must follow ISO 4217.
- status-related fields must contain only predefined and allowed values.
- order_amount must be greater than zero.

Notes:
Every decision in this physical orders model is an intentional trade-off to facilitate maintenance and improve readability.

- embedded address attributes are denormalized to reduce the need for joins, lower analytical query cost, and preserve the historical integrity of orders.
- the order domain uses VARCHAR with CHECK constraints instead of ENUM to provide greater flexibility across different databases and improve portability.
- district and address_complement are optional, reflecting real-world scenarios where such information is not required or available in all countries.
- currency is defined as CHAR(3) following the ISO 4217 standard to ensure consistency, reduce ambiguity, and simplify filtering and aggregation in analytical workloads.
- temporal validity fields are managed at the snapshot layer.
===============================================================================
*/

CREATE TABLE orders (
    order_id UUID PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    order_date TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    order_status VARCHAR (30) CHECK (order_status IN ('pending', 'processing', 'paid', 'on_hold', 'shipped', 'delivered', 'completed', 'canceled', 'refunded', 'failed')) NOT NULL,
    payment_status VARCHAR (30) CHECK (payment_status IN ('pending', 'processing', 'paid', 'on_hold', 'canceled', 'refunded', 'failed')) NOT NULL,
    order_channel VARCHAR (30) CHECK (order_channel IN ('web', 'mobile_app', 'marketplace', 'api')) NOT NULL,
    shipping_method VARCHAR (30) CHECK (shipping_method IN ('standard', 'express', 'pickup_in_store')) NOT NULL,
    order_amount DECIMAL (10,2) NOT NULL,
    currency CHAR (3) NOT NULL,
    street VARCHAR (50) NOT NULL,
    street_number VARCHAR (20) NOT NULL,
    address_complement VARCHAR (20),
    district VARCHAR (50),
    city VARCHAR (50) NOT NULL,
    state VARCHAR (50) NOT NULL,
    postal_code VARCHAR (20) NOT NULL,
    country VARCHAR (20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
