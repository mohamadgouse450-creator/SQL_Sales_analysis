-- =====================================================================
-- SQL PROJECT: Sales Project on Superstore
-- Data-Driven Insights from Sales Dataset
-- Database: Oracle 10g
-- =====================================================================
-- Notes on Oracle 10g conversion from MySQL:
--  * VARCHAR  -> VARCHAR2 ; DECIMAL -> NUMBER ; INT -> NUMBER
--  * Backticks `..` are not valid in Oracle -> replaced with double
--    quotes "..", required because "Sub-Category" and "Postal Code"
--    contain a hyphen / space (Oracle keeps them case-sensitive too,
--    so always refer to them in double quotes exactly as created).
--  * Oracle 10g has no "DROP TABLE IF EXISTS" -> wrapped in PL/SQL
--    with an exception handler (ORA-00942 = table does not exist).
--  * Oracle has no multi-row VALUES(...),(...) syntax pre-23c ->
--    one INSERT statement per row.
--  * No LIMIT clause -> use ROWNUM over an ordered subquery.
--  * MySQL's workaround for EXCEPT/INTERSECT is not needed here -
--    Oracle natively supports MINUS and INTERSECT.
-- =====================================================================


-- =====================================================================
-- 1. TABLE CREATION
-- =====================================================================

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE samplesuperstore';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE samplesuperstore (
    "Ship Mode"    VARCHAR2(50),
    Segment        VARCHAR2(50),
    Country        VARCHAR2(50),
    City           VARCHAR2(100),
    State          VARCHAR2(100),
    "Postal Code"  VARCHAR2(20),
    Region         VARCHAR2(50),
    Category       VARCHAR2(50),
    "Sub-Category" VARCHAR2(50),
    Sales          NUMBER(12,4),
    Quantity       NUMBER(6),
    Discount       NUMBER(5,2),
    Profit         NUMBER(12,4)
);

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE region_details';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Lookup table used for the JOIN examples
CREATE TABLE region_details (
    Region             VARCHAR2(50),
    Region_Description VARCHAR2(255)
);


-- =====================================================================
-- 2. SAMPLE DATA
-- (one INSERT per row - Oracle 10g does not support multi-row VALUES)
-- =====================================================================

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Second Class', 'Consumer', 'United States', 'Henderson', 'Kentucky', '42420', 'South', 'Furniture', 'Bookcases', 261.9600, 2, 0.00, 41.9136);

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Second Class', 'Consumer', 'United States', 'Henderson', 'Kentucky', '42420', 'South', 'Furniture', 'Chairs', 731.9400, 3, 0.00, 219.5820);

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Second Class', 'Corporate', 'United States', 'Los Angeles', 'California', '90036', 'West', 'Office Supplies', 'Labels', 14.6200, 2, 0.00, 6.8714);

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Standard Class', 'Consumer', 'United States', 'Fort Lauderdale', 'Florida', '33311', 'South', 'Furniture', 'Tables', 957.5775, 5, 0.45, -383.0310);

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Standard Class', 'Consumer', 'United States', 'Fort Lauderdale', 'Florida', '33311', 'South', 'Office Supplies', 'Storage', 22.3680, 2, 0.20, 2.5164);

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Standard Class', 'Consumer', 'United States', 'Los Angeles', 'California', '90032', 'West', 'Furniture', 'Furnishings', 48.8600, 7, 0.00, 14.1694);

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Standard Class', 'Consumer', 'United States', 'Los Angeles', 'California', '90032', 'West', 'Office Supplies', 'Art', 7.2800, 4, 0.00, 1.9656);

INSERT INTO samplesuperstore
("Ship Mode", Segment, Country, City, State, "Postal Code", Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)
VALUES ('Standard Class', 'Consumer', 'United States', 'Los Angeles', 'California', '90032', 'West', 'Technology', 'Phones', 907.1520, 6, 0.20, 90.7152);

-- NOTE: The full dataset used in the project has 9500+ rows.
-- Import your complete CSV export using SQL*Loader or an ETL tool
-- rather than typing each row - e.g. a control file such as:
--
-- LOAD DATA
-- INFILE 'SampleSuperstore.csv'
-- INTO TABLE samplesuperstore
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- TRAILING NULLCOLS
-- ("Ship Mode", Segment, Country, City, State, "Postal Code",
--  Region, Category, "Sub-Category", Sales, Quantity, Discount, Profit)

INSERT INTO region_details (Region, Region_Description) VALUES ('South', 'Represents the southern states');
INSERT INTO region_details (Region, Region_Description) VALUES ('West', 'Covers the western regions');
INSERT INTO region_details (Region, Region_Description) VALUES ('Central', 'Includes the central part of the country');
INSERT INTO region_details (Region, Region_Description) VALUES ('East', 'Covers the eastern regions');

COMMIT;


-- =====================================================================
-- 3. SELECTION STATEMENT
-- =====================================================================

-- Retrieve all columns for records where ship mode is "Standard Class"
SELECT *
FROM samplesuperstore
WHERE "Ship Mode" = 'Standard Class';


-- =====================================================================
-- 4. FILTERING WITH WHERE CLAUSE
-- =====================================================================

-- Loss-making transactions
SELECT *
FROM samplesuperstore
WHERE profit < 0;


-- =====================================================================
-- 5. ORDER BY CLAUSE
-- =====================================================================

-- Sorted by region (ascending), then by profit (descending)
SELECT *
FROM samplesuperstore
ORDER BY region ASC, profit DESC;


-- =====================================================================
-- 6. JOINS
-- =====================================================================

-- Inner join to get region descriptions
SELECT sss.region, rd.Region_Description
FROM samplesuperstore sss
INNER JOIN region_details rd
    ON sss.Region = rd.Region;

-- Left outer join
SELECT sss.region, rd.region_description
FROM samplesuperstore sss
LEFT JOIN region_details rd
    ON sss.region = rd.region;

-- Right outer join
SELECT sss.region, rd.region_description
FROM samplesuperstore sss
RIGHT JOIN region_details rd
    ON sss.region = rd.region;

-- (Oracle also supports the legacy (+) outer-join syntax, e.g.:
--  SELECT sss.region, rd.region_description
--  FROM samplesuperstore sss, region_details rd
--  WHERE sss.region = rd.region (+);   -- left outer join, old style )


-- =====================================================================
-- 7. AGGREGATION
-- =====================================================================

-- Total sales, average profit, and maximum discount across all transactions
SELECT
    SUM(Sales)    AS Total_Sales,
    AVG(Profit)   AS Avg_Profit,
    MAX(Discount) AS Max_Discount
FROM samplesuperstore;


-- =====================================================================
-- 8. GROUPING AND AGGREGATION
-- =====================================================================

-- Total sales and profit per region
SELECT
    region,
    SUM(sales)  AS Total_sales,
    SUM(profit) AS Total_profit
FROM samplesuperstore
GROUP BY region;

-- Average discount and total quantity sold per segment
SELECT
    segment,
    AVG(discount) AS Avg_discount,
    SUM(Quantity) AS Count_quantity
FROM samplesuperstore
GROUP BY segment;


-- =====================================================================
-- 9. HAVING CLAUSE
-- =====================================================================

-- Sub-categories where the average profit is less than 0
SELECT "Sub-Category", AVG(profit)
FROM samplesuperstore
GROUP BY "Sub-Category"
HAVING AVG(profit) < 0;


-- =====================================================================
-- 10. SUBQUERIES
-- =====================================================================

-- Transactions with sales greater than the average sales
SELECT *
FROM samplesuperstore
WHERE sales > (
    SELECT AVG(sales)
    FROM samplesuperstore
);

-- Regions where total profit exceeds the total profit of the "Central" region
SELECT region
FROM samplesuperstore
GROUP BY region
HAVING SUM(profit) > (
    SELECT SUM(profit)
    FROM samplesuperstore
    WHERE region = 'Central'
);


-- =====================================================================
-- 11. CTEs (COMMON TABLE EXPRESSIONS)
-- =====================================================================

-- Top 5 profitable sub-categories
WITH SubCategory_Profit AS (
    SELECT "Sub-Category", SUM(Profit) AS Total_Profit
    FROM samplesuperstore
    GROUP BY "Sub-Category"
)
SELECT *
FROM (
    SELECT *
    FROM SubCategory_Profit
    ORDER BY Total_Profit DESC
)
WHERE ROWNUM <= 5;


-- =====================================================================
-- 12. NESTED QUERIES
-- =====================================================================

-- Cities where the highest sales exceed the average sales across all regions
SELECT city
FROM samplesuperstore
WHERE sales IN (
    SELECT MAX(sales)
    FROM samplesuperstore
    GROUP BY region
    HAVING MAX(sales) > (SELECT AVG(sales) FROM samplesuperstore)
);


-- =====================================================================
-- 13. WINDOW (ANALYTIC) FUNCTIONS
-- =====================================================================

-- Rank products by profit within each category
SELECT
    Category,
    "Sub-Category",
    Profit,
    RANK() OVER (PARTITION BY Category ORDER BY Profit DESC) AS Profit_Rank
FROM samplesuperstore;


-- =====================================================================
-- 14. PIVOT TABLE
-- =====================================================================

-- Total sales for each category, pivoted across regions
SELECT
    Region,
    SUM(CASE WHEN Category = 'Furniture'       THEN Sales ELSE 0 END) AS Furniture_Sales,
    SUM(CASE WHEN Category = 'Office Supplies' THEN Sales ELSE 0 END) AS Office_Supplies_Sales,
    SUM(CASE WHEN Category = 'Technology'      THEN Sales ELSE 0 END) AS Technology_Sales
FROM samplesuperstore
GROUP BY Region;


-- =====================================================================
-- 15. SET OPERATIONS
-- =====================================================================

-- MINUS (equivalent to EXCEPT):
-- Cities that appear in 'South' region but never in 'West' region
SELECT city FROM samplesuperstore WHERE region = 'South'
MINUS
SELECT city FROM samplesuperstore WHERE region = 'West';

-- INTERSECT:
-- Cities that appear in BOTH 'South' and 'West' regions
SELECT city FROM samplesuperstore WHERE region = 'South'
INTERSECT
SELECT city FROM samplesuperstore WHERE region = 'West';

-----END OF PROJECT-----
