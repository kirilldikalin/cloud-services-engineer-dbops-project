-- добавить недостающие атрибуты в текущие таблицы
ALTER TABLE IF EXISTS product ADD COLUMN IF NOT EXISTS price double precision;
ALTER TABLE IF EXISTS orders  ADD COLUMN IF NOT EXISTS date_created date DEFAULT current_date;
