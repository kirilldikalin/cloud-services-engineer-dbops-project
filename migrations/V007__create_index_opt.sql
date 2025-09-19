-- ускорение фильтрации и группировки по статусу и дате
CREATE INDEX IF NOT EXISTS idx_orders_status_date
  ON orders(status, date_created);

-- опционально актуализировать статистику
ANALYZE orders;
ANALYZE order_product;
