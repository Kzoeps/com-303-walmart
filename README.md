# com-303-walmart
Repo for Walmart DB design

## Table of Contents
---
1. [Overview](#overview)
2. [Setup & Usage](#setup--usage)
3. [Core Functions](#core-functions)
   - [`process_reorders()`](#process_reorders)
   - [`fulfill_order(order_id)`](#fulfill_orderorder_id)
   - [`process_invoice(order_id)`](#process_invoiceorder_id)
4. [Database Tables Touched](#database-tables-touched)
5. [Design Rationale](#design-rationale)
6. [Dependencies](#dependencies)
---
**any time you install a new package freeze requiremenst using this command: `pip freeze > requirements.txt`**

## Overview

Our vendor order management consists of two Python scripts:

- **`vendor_order_management.py`** – interactive CLI to:
  1. reorder low-stock items
  2. fulfill existing orders (bump inventory)
  3. generate invoices

- **`vendor_invoice_generation.py`** – logic for creating an invoice and linking it back to a vendor order.

All operations use MySQL transactions for atomicity and consistency.

---

## Setup & Usage

1. **Create** a .env file in the root of the project and add your database credentials. Eg:
    ```python
    DB_USER="root"
    DB_PASSWORD="password"
    DB_NAME="Walmart"
    ```
    
2. **Install** dependencies:
   ```bash
   pip install mysql-connector-python
   pip install python-dotenv
   ```

3, **Run** the init script which initializes the schema and adds seed data:
    ```bash
    python init_db.py
    ```

4. **Run** the management script:
   ```bash
   python vendor_order_management.py
   ```

5. **Follow** prompts:
   - Enter `1` to process reorders
   - Enter `2` to fulfill an order (then supply Order ID)
   - Enter `3` to generate an invoice (then supply Order ID)

---

## Core Functions

### `process_reorders()`

1. **Fetch low‐stock items** from `Carries` where `quantity <= min_quantity`.
2. **Group** results by `(store_id, vendor_id)`.
3. **Insert** a new row into `Vendor_Order` for each group:
   - `fulfilled = FALSE` initially.
4. **Insert** one or more lines into `Order_Line`, pulling `quoted_cost` from `Vendor_Product`.
5. **Commit** the transaction.

| Table | Action |
|-------|--------|
| `Carries` | READ low-stock rows |
| `Vendor_Product` | READ quoted_cost |
| `Vendor_Order` | INSERT new order headers |
| `Order_Line` | INSERT one line per product |

### `fulfill_order(order_id)`

1. **Update** `Vendor_Order.fulfilled = TRUE` (only if not already fulfilled).
   - If `rowcount == 0`, skip bump.
2. **Fetch** `store_id` from `Vendor_Order`.
3. **Fetch** all `(product_id, quantity)` from `Order_Line` for this order.
4. **Update** `Carries.quantity += quantity` for each product in that store.
5. **Commit** the transaction.

| Table | Action |
|-------|--------|
| `Vendor_Order` | UPDATE fulfilled flag |
| `Order_Line` | READ line items |
| `Carries` | UPDATE inventory levels |

### `process_invoice(order_id)`

1. **Fetch** `vendor_id` from `Vendor_Order`.
2. **Fetch** `(product_id, quantity, unit_cost)` from `Order_Line`.
3. **Calculate** total: sum of `(quantity * unit_cost)`.
4. **Insert** an `Invoice` row with:
   - auto-generated `invoice_number` (e.g. `PO123-20250427`)
   - `due_date = today + 30 days`
   - `payment_status = 'UNPAID'`.
5. **Insert** one or more `Invoice_Line_Item` rows.
6. **Update** `Vendor_Order.invoice_id` to link back.
7. **Commit** the transaction.

| Table | Action |
|-------|--------|
| `Order_Line` | READ order lines |
| `Invoice` | INSERT header |
| `Invoice_Line_Item` | INSERT line items |
| `Vendor_Order` | UPDATE invoice_id |

---

## Notes 
- **30‑Day Payment Terms**: aligns with standard vendor net‑30 invoicing practices.

---

## Dependencies

- Python 3.9+
- `mysql-connector-python`
- `python-dotenv`

---
