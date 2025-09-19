-- минимальная инициализация orders, достаточно ненулевого количества строк
INSERT INTO orders (id, status, date_created)
SELECT gs AS id,
       (ARRAY['pending','shipped','cancelled'])[1 + (random()*2)::int],
       CURRENT_DATE - ((random()*30)::int)
FROM generate_series(1,1000) AS gs
ON CONFLICT DO NOTHING;
