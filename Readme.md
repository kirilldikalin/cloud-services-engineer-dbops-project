# dbops-project

## Создание БД 

```sql
CREATE DATABASE store;
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$STORE_USER') THEN
    CREATE ROLE "$STORE_USER" LOGIN PASSWORD '$STORE_PASS';
  ELSE
    ALTER ROLE "$STORE_USER" LOGIN PASSWORD '$STORE_PASS';
  END IF;
END\$\$;
GRANT CONNECT ON DATABASE store TO "$STORE_USER";
```

## Права в самой БД

```sql
GRANT USAGE, CREATE ON SCHEMA public TO "$STORE_USER";
ALTER ROLE "$STORE_USER" SET search_path TO public;
```

Пароль берётся из секретов

## Шаг 10

```sql
\timing on
\pset pager off
SELECT o.date_created::date AS order_date,
       SUM(op.quantity)     AS total_qty
FROM orders AS o
JOIN order_product AS op ON o.id = op.order_id
WHERE o.status = 'shipped'
  AND o.date_created >= CURRENT_DATE - INTERVAL '7 days'
  AND o.date_created <  CURRENT_DATE
GROUP BY order_date
ORDER BY order_date;
```

Результат:

```
 order_date | total_qty 
------------+-----------
 2025-09-12 |        45
 2025-09-13 |        88
 2025-09-14 |        56
 2025-09-15 |        71
 2025-09-16 |        40
 2025-09-17 |        69
 2025-09-18 |        44
(7 rows)

Time: 2.190 ms
```