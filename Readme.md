# Создание БД store

```sql
CREATE DATABASE store;
```

# Создание пользователя для миграций и автотестов

```sql
CREATE ROLE store_user LOGIN PASSWORD '<секрет>';
GRANT CONNECT ON DATABASE store TO store_user;
\c store
GRANT USAGE, CREATE ON SCHEMA public TO store_user;
ALTER ROLE store_user SET search_path TO public;
```

# Запрос отчета, сколько сосисок продано за каждый день предыдущей недели

```sql
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