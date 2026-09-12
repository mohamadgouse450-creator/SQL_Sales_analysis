# SQL Project: Sales Insights on Superstore Dataset

A single-file SQL project that demonstrates data-driven analysis on the classic **Sample Superstore** sales dataset, written for **Oracle 10g**.

The script builds the schema, loads sample data, and walks through progressively advanced SQL concepts — from basic filtering to window functions, pivots, and set operations — all as runnable, commented queries.

---

## 📁 Files

| File | Description |
|---|---|
| `sql_project.sql` | Full SQL script: table creation, sample data, and all analysis queries |

---

## 🗄️ Database & Schema

**Target RDBMS:** Oracle 10g

### `samplesuperstore`
Main fact table holding order-level sales transactions.

| Column | Type | Notes |
|---|---|---|
| Ship Mode | VARCHAR2(50) | quoted identifier (space in name) |
| Segment | VARCHAR2(50) | |
| Country | VARCHAR2(50) | |
| City | VARCHAR2(100) | |
| State | VARCHAR2(100) | |
| Postal Code | VARCHAR2(20) | quoted identifier |
| Region | VARCHAR2(50) | |
| Category | VARCHAR2(50) | |
| Sub-Category | VARCHAR2(50) | quoted identifier (hyphen in name) |
| Sales | NUMBER(12,4) | |
| Quantity | NUMBER(6) | |
| Discount | NUMBER(5,2) | |
| Profit | NUMBER(12,4) | |

### `region_details`
Lookup table used to demonstrate joins.

| Column | Type |
|---|---|
| Region | VARCHAR2(50) |
| Region_Description | VARCHAR2(255) |

> The script includes 8 sample rows for quick testing. The original project dataset has 9,500+ rows — see [Loading the full dataset](#-loading-the-full-dataset) below.

---

## 🔧 Oracle 10g Conversion Notes

This script was adapted from a MySQL version, with the following changes:

- `VARCHAR` → `VARCHAR2`, `DECIMAL`/`INT` → `NUMBER`
- Backticks (`` ` ``) replaced with double quotes `"..."` for identifiers containing spaces/hyphens (e.g. `"Sub-Category"`, `"Postal Code"`)
- No native `DROP TABLE IF EXISTS` → wrapped in a `BEGIN...EXCEPTION` block catching `ORA-00942`
- No multi-row `VALUES (...), (...)` syntax (pre-23c) → one `INSERT` per row
- No `LIMIT` → `ROWNUM` over an ordered subquery
- `MINUS` and `INTERSECT` are native in Oracle (no `EXCEPT`/`INTERSECT` workaround needed, unlike MySQL)

---

## 📊 SQL Concepts Covered

1. **Table Creation** — schema design with quoted identifiers
2. **Sample Data** — row-by-row inserts (Oracle 10g-compatible)
3. **SELECT statements** — basic retrieval
4. **WHERE filtering** — e.g. loss-making transactions
5. **ORDER BY** — multi-column sorting
6. **JOINS** — inner, left, right outer joins
7. **Aggregation** — `SUM`, `AVG`, `MAX`
8. **GROUP BY** — sales/profit by region and segment
9. **HAVING** — filtering aggregated groups
10. **Subqueries** — correlated and scalar
11. **CTEs** — `WITH` clause for top-N profitable sub-categories
12. **Nested Queries** — multi-level `IN`/`HAVING` conditions
13. **Window Functions** — `RANK() OVER (PARTITION BY ...)`
14. **Pivot Tables** — `CASE`/`SUM` pivot pattern (10g has no native `PIVOT`)
15. **Set Operations** — `MINUS` and `INTERSECT`

---

## ▶️ How to Run

1. Open the script in Oracle SQL Developer (or any Oracle 10g-compatible client).
2. Run the script top to bottom — it will:
   - Drop and recreate `samplesuperstore` and `region_details`
   - Insert sample rows
   - Run each analysis query in sequence
3. Review each section's output; sections are separated by comment headers for easy navigation.

---

## 📥 Loading the Full Dataset

The script ships with 8 sample rows for demonstration. To use the complete ~9,500-row Superstore dataset, load your CSV via **SQL*Loader** instead of manual inserts:

```sql
LOAD DATA
INFILE 'SampleSuperstore.csv'
INTO TABLE samplesuperstore
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
("Ship Mode", Segment, Country, City, State, "Postal Code",
 Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
```

Run with: `sqlldr userid=<user>/<pass>@<db> control=load.ctl`

---

## 🧠 Key Insights the Script Can Surface

- Which sub-categories are consistently unprofitable (`HAVING AVG(profit) < 0`)
- Top 5 most profitable sub-categories (CTE + `ROWNUM`)
- Regions outperforming Central in total profit (correlated subquery)
- Category-wise sales split across regions (pivot)
- Cities exclusive to South vs. West, and cities common to both (`MINUS` / `INTERSECT`)

---

## 🛠️ Tech Stack

- **Database:** Oracle 10g
- **Dataset:** Sample Superstore (public retail sales dataset)

---

## 📌 Author

Mohamad Gouse M (Bas)
