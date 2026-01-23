# ELT Order Lifecycle – SCD Type 2 & Snapshots

## Overview

This repository represents a hands-on data engineering–focused project designed to model the full lifecycle of orders using an event-driven ELT architecture.

The project emphasizes data correctness, historical traceability, and reproducibility, implementing industry-grade concepts such as:

- Event-based raw ingestion  
- ELT layering (RAW → STAGING → SCD → SNAPSHOT → FINAL)  
- Slowly Changing Dimensions (SCD Type 2)  
- Daily snapshots  
- Idempotent data processing  

Rather than isolated SQL exercises, this repository models how real-world data platforms handle mutable business entities over time, with a strong focus on data versioning and temporal consistency.

---

## Project Goals

- Practice ELT architecture using SQL and relational modeling  
- Understand how business events translate into data state changes  
- Implement SCD Type 2 for historical versioning  
- Build daily snapshots to freeze system state in time  
- Ensure idempotent and reprocessable data pipelines  
- Clearly separate data responsibilities by layer  

This project prioritizes correctness and architecture clarity over query complexity.

---

## Conceptual Scope

The project models the order lifecycle as a sequence of events:

- Order creation  
- Status changes (pending, paid, canceled, refunded, etc.)  
- Monetary updates  
- Corrections and late-arriving events  

Each change is treated as a business event, not as a direct overwrite of data.

---

## Architecture Overview

The pipeline follows a strict ELT flow:

Events
↓
RAW (event storage)
↓
STAGING (validation & normalization)
↓
SCD Type 2 (state versioning)
↓
Daily SNAPSHOT (state freezing)
↓
FINAL (business-ready dataset)

Each layer has explicit responsibilities and clear boundaries, preventing rule leakage and preserving data lineage.

---

## Layer Responsibilities

### RAW – Event Storage

- Stores all incoming order-related events  
- Append-only and immutable  
- No validation, transformation, or business logic  
- Serves as the system of record for auditing and replay  

**Purpose:** Preserve the full history of what happened.

---

### STAGING – Event Validation

- Cleans and normalizes raw event data  
- Validates data types, formats, and required fields  
- Detects duplicates and invalid events  
- No business rules applied  

**Purpose:** Ensure events are structurally correct before use.

---

### SCD Type 2 – State Versioning

- Transforms events into entity state changes  
- Creates a new version only when a versionable attribute changes  
- Maintains full historical lineage using:  
  - `valid_from`  
  - `valid_to`  
  - `is_current`  

**Purpose:** Track how and when an order changed over time.

---

### SNAPSHOT – Daily State Freezing

- Freezes the valid state of each order for a specific date  
- Based on SCD temporal validity, not on current flags  
- Idempotent and append-only  
- Enables point-in-time analysis  

**Purpose:** Answer “how the system looked on day X”.

---

### FINAL – Business Consumption

- Derived from snapshots  
- Applies business rules (e.g. paid orders only)  
- Contains only current, valid records  
- No historical or technical metadata  

**Purpose:** Provide a clean, decision-ready dataset.

---

## Key Design Principles

- Immutability: historical data is never overwritten  
- Idempotency: pipelines can be safely re-run  
- Separation of concerns: each layer has a single responsibility  
- Temporal accuracy: all changes are time-aware  
- Reprocessability: history can be rebuilt from RAW  

---

## What This Project Demonstrates

- Practical understanding of ELT vs ETL  
- Event-driven data modeling  
- SCD Type 2 applied beyond theory  
- Snapshot design for temporal analytics  
- Data architecture reasoning, not just SQL syntax  

---

## Relationship to Other Projects

This repository complements the **SQL Analytics & Data Engineering Foundations** project.

While that project focuses on data consumption and analytics, this one focuses on data production and correctness, modeling how reliable analytical datasets are built upstream.

Together, they represent a full data lifecycle:

- This project → produces trusted, versioned data  
- Analytics project → consumes data for insights  

---

## Tools & Technologies

- SQL  
- MySQL  
- Relational data modeling  
- ELT architecture concepts  

---

## Ongoing Development

This project is intentionally designed for extension. Possible next steps include:

- CDC simulation  
- Event replay and late-arriving data handling  
- Incremental snapshot strategies  
- Performance considerations for large volumes  

---

## Notes

This repository is part of my professional preparation for an entry-level role in Data Engineering, with a strong emphasis on data modeling, data correctness, and system design, built through self-directed study and practical implementation.
