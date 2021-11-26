CREATE TABLE IF NOT EXISTS orders
(
    id SERIAL PRIMARY KEY,
    product_name CHARACTER VARYING(50),
    price INTEGER
);

CREATE TABLE IF NOT EXISTS clients
(
    id SERIAL PRIMARY KEY,
    full_name CHARACTER VARYING(50),
    country CHARACTER VARYING(50),
    order_id INTEGER REFERENCES orders (id)
);

CREATE INDEX IF NOT EXISTS idx_clients_country ON clients (country);
