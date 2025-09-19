INSERT INTO order_product (quantity, order_id, product_id)
SELECT 1 + (random()*5)::int,               -- 1..6
       gs,                                  -- ссылка на существующие orders
       1 + (random()*5)::int                -- 1..6
FROM generate_series(1,1000) AS gs;
