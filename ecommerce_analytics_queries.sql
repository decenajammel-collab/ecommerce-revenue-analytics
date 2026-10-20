SELECT 
    "CustomerID",
    MAX("InvoiceDate"::timestamp) AS last_purchase_date,
    COUNT(DISTINCT "InvoiceNo") AS frequency,
    ROUND(SUM("Quantity" * "UnitPrice")::numeric, 2) AS monetary_value
FROM newtable
WHERE "CustomerID" IS NOT NULL
GROUP BY "CustomerID"
ORDER BY monetary_value DESC
LIMIT 10;

SELECT 
    DATE_TRUNC('month', "InvoiceDate"::timestamp) AS sales_month,
    COUNT(DISTINCT "InvoiceNo") AS total_orders,
    ROUND(SUM("Quantity" * "UnitPrice")::numeric, 2) AS monthly_revenue
FROM newtable
GROUP BY sales_month
ORDER BY sales_month ASC;

SELECT 
    "Description",
    SUM("Quantity") AS total_quantity_sold,
    ROUND(SUM("Quantity" * "UnitPrice")::numeric, 2) AS total_revenue
FROM newtable
WHERE "Description" IS NOT NULL
GROUP BY "Description"
ORDER BY total_revenue DESC
LIMIT 10;

WITH customer_orders AS (
    SELECT 
        "CustomerID",
        COUNT(DISTINCT "InvoiceNo") AS order_count
    FROM newtable
    WHERE "CustomerID" IS NOT NULL
    GROUP BY "CustomerID"
)
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        (SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)::numeric / COUNT(*)) * 100, 
        2
    ) AS repeat_purchase_rate_pct
FROM customer_orders;