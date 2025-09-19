BEGIN;

-- 1. Добавить недостающие колонки
ALTER TABLE product ADD COLUMN IF NOT EXISTS price double precision;
ALTER TABLE orders  ADD COLUMN IF NOT EXISTS date_created date;

-- 2. Перенести данные из временных таблиц, если они есть
UPDATE product p
SET price = pi.price
FROM product_info pi
WHERE pi.product_id = p.id
  AND p.price IS NULL;

UPDATE orders o
SET date_created = COALESCE(o.date_created, CURRENT_DATE);

-- 3. PK на product.id и orders.id, если ещё не заданы
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    WHERE t.relname = 'product' AND c.contype = 'p'
  ) THEN
    ALTER TABLE product ADD CONSTRAINT product_pkey PRIMARY KEY (id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    WHERE t.relname = 'orders' AND c.contype = 'p'
  ) THEN
    ALTER TABLE orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
  END IF;
END $$;

-- 4. FK на order_product.order_id -> orders.id и order_product.product_id -> product.id
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE table_name='order_product' AND constraint_name='fk_order_product_order'
  ) THEN
    ALTER TABLE order_product
      ADD CONSTRAINT fk_order_product_order
      FOREIGN KEY (order_id) REFERENCES orders(id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE table_name='order_product' AND constraint_name='fk_order_product_product'
  ) THEN
    ALTER TABLE order_product
      ADD CONSTRAINT fk_order_product_product
      FOREIGN KEY (product_id) REFERENCES product(id);
  END IF;
END $$;

-- 5. Удалить больше неиспользуемые таблицы
DROP TABLE IF EXISTS product_info;
DROP TABLE IF EXISTS orders_date;

COMMIT;
