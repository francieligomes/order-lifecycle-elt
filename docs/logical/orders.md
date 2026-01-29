# Orders Domain – Logical Model

## Purpose
The purpose of this logical model is to specify order attributes independent of storage engine. The fields are defined as mandatory or optional, and versionable or immutable.

## Attributes Table
- order_id: identifier, mandatory, immutable
- user_id: identifier, mandatory, immutable
- order_date: timestamp, mandatory, immutable
- created_at: timestamp, mandatory, immutable
- order_status: string, mandatory, versionable
- payment_status: string, mandatory, versionable
- order_channel: string, mandatory, immutable
- shipping_method: string, mandatory, versionable
- order_amount: monetary, mandatory, versionable
- currency: string, mandatory, immutable
- street: string, mandatory, immutable
- street_number: string, mandatory, immutable
- address_complement: string, optional, immutable
- district: string, optional, immutable
- city: string, mandatory, immutable
- state: string, mandatory, immutable
- postal_code: string, mandatory, immutable
- country: string, mandatory, immutable

## Notes On Versioning
This section covers versioning rules as applied to slowly changing dimensions (SCD).

### Versionable Attributes
- Derives from events 
- Represents state changes of an order
- Always trigger a new version in the SCD layer
- Expires the previous version

### Immutable Attributes
- Identify the order and its ownership
- Does not change after the creation
- Does not create a new version
- Reused in all versions
  
## Modeling Decisions

This logical model makes explicit design choices to support an event-driven ELT architecture and Slowly Changing Dimensions (SCD).

- Address-related attributes are modeled as immutable. Any change in address information is treated as a new version of the order state, rather than an in-place update.
- Monetary context attributes, such as currency, are immutable to avoid semantic inconsistencies within the same order lifecycle.
- Only attributes that represent business state transitions (e.g. order_status, payment_status, order_amount) are classified as versionable.
- Technical timestamps such as created_at are immutable and represent record creation, not business changes.

These decisions aim to preserve historical accuracy, enable reproducibility, and ensure clear separation between business events and static contextual data.
