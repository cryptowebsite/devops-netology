UPDATE clients SET order_id = (SELECT id FROM orders WHERE product_name = 'Книга')
WHERE full_name = 'Иванов Иван Иванович';

UPDATE clients SET order_id = (SELECT id FROM orders WHERE product_name = 'Монитор')
WHERE full_name = 'Петров Петр Петрович';

UPDATE clients SET order_id = (SELECT id FROM orders WHERE product_name = 'Гитара')
WHERE full_name = 'Иоганн Себастьян Бах';