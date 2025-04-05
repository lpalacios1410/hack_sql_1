CREATE TABLE countries (
    id_country INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE roles (
    id_role INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE taxes (
    id_tax INT PRIMARY KEY,
    percentage DECIMAL(5,2) NOT NULL
);

CREATE TABLE offers (
    id_offer INT PRIMARY KEY,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE discounts (
    id_discount INT PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    percentage DECIMAL(5,2) NOT NULL
);

CREATE TABLE invoice_status (
    id_invoice_status INT PRIMARY KEY,
    status VARCHAR(30) NOT NULL
);

CREATE TABLE payments (
    id_payment INT PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

CREATE TABLE customers (
    email VARCHAR(255) PRIMARY KEY,
    id_country INT,
    id_role INT,
    name VARCHAR(100) NOT NULL,
    age INT,
    password VARCHAR(255) NOT NULL,
    physical_address TEXT,
    FOREIGN KEY (id_country) REFERENCES COUNTRIES(id_country),
    FOREIGN KEY (id_role) REFERENCES ROLES(id_role)
);

CREATE TABLE products (
    id_product INT PRIMARY KEY,
    id_discount INT,
    id_offer INT,
    id_tax INT,
    name VARCHAR(100) NOT NULL,
    details TEXT,
    minimum_stock INT NOT NULL,
    maximum_stock INT NOT NULL,
    current_stock INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    price_with_tax DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_discount) REFERENCES DISCOUNTS(id_discount),
    FOREIGN KEY (id_offer) REFERENCES OFFERS(id_offer),
    FOREIGN KEY (id_tax) REFERENCES TAXES(id_tax)
);

CREATE TABLE products_customers (
    id_product INT,
    id_customer VARCHAR(255),
    PRIMARY KEY (id_product, id_customer),
    FOREIGN KEY (id_product) REFERENCES PRODUCTS(id_product),
    FOREIGN KEY (id_customer) REFERENCES CUSTOMERS(email)
);

CREATE TABLE invoices (
    id_invoice INT PRIMARY KEY,
    id_customer VARCHAR(255),
    id_payment INT,
    id_invoice_status INT,
    date DATE NOT NULL,
    total_to_pay DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_customer) REFERENCES CUSTOMERS(email),
    FOREIGN KEY (id_payment) REFERENCES PAYMENTS(id_payment),
    FOREIGN KEY (id_invoice_status) REFERENCES INVOICE_STATUS(id_invoice_status)
);

CREATE TABLE orders (
    id_order INT PRIMARY KEY,
    id_invoice INT,
    id_product INT,
    detail TEXT,
    amount INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_invoice) REFERENCES INVOICES(id_invoice),
    FOREIGN KEY (id_product) REFERENCES PRODUCTS(id_product)
);
--
-- Inserts de datos
--

INSERT INTO countries (id_country, name) VALUES (1, 'Estados Unidos'), (2, 'Venezuela'), (3, 'Colombia');
SELECT * FROM countries

INSERT INTO roles (id_role, name) VALUES (1, 'Administrador'),(2, 'Cliente Premium'),(3, 'Cliente Regular');
SELECT * FROM roles

INSERT INTO taxes (id_tax, percentage) VALUES (1, 10.00), (2, 16.00), (3, 21.00); -- 10%, 16%, 21%
SELECT * FROM taxes

INSERT INTO offers (id_offer, status) VALUES (1, 'Activa'), (2, 'Inactiva'), (3, 'Pendiente');
SELECT * FROM offers

INSERT INTO discounts (id_discount, status, percentage) VALUES (1, 'Activo', 15.00), (2, 'Expirado', 20.00), (3, 'Activo', 10.00); -- 15%, 20%, 10%
SELECT * FROM discounts

INSERT INTO invoice_status (id_invoice_status, status) VALUES (1, 'Pagada'), (2, 'Pendiente'), (3, 'Cancelada');
SELECT * from invoice_status

INSERT INTO payments (id_payment, type) VALUES(1, 'Tarjeta Crédito'), (2, 'PayPal'), (3, 'Transferencia');
SELECT * FROM payments

INSERT INTO customers (email, id_country, id_role, name, age, password, physical_address) VALUES
('cliente1@gmail.com', 1, 1, 'Luis Palacios', 25, 'cliente123', 'Calle Principal 123, NY'),
('cliente2@hotmail.com', 2, 2, 'Armando Alonso', 48, 'cliente987', 'San Bernardino, Caracas'),
('cliente3@yahoo.com', 3, 3, 'Pedro Perez', 55, 'pass123', 'Av Comuneros, Medellin');
SELECT * FROM customers

INSERT INTO products (id_product, id_discount, id_offer, id_tax, name, details, minimum_stock, maximum_stock, current_stock, price, price_with_tax) VALUES
(101, 1, 1, 1, 'Laptop Pro', 'Laptop i7 16GB RAM', 5, 50, 25, 1200.00, 1320.00),
(102, NULL, 2, 2, 'Smartphone' 'Telefono 128GB', 10, 100, 30, 800.00, 928.00),
(103, 3, NULL, 3, 'Tablet', 'Xiaomi Tablet', 8, 80, 15, 300.00, 363.00);
SELECT * from products

INSERT INTO products_customers (id_product, id_customer) VALUES
(101, 'cliente1@gmail.com'),
(102, 'cliente3@yahoo.com'),
(103, 'cliente2@hotmail.com');
SELECT * FROM products_customers

-- F1
INSERT INTO invoices (id_invoice, id_customer, id_payment, id_invoice_status, date, total_to_pay) VALUES (1001, 'cliente1@gmail.com', 1, 1, '2024-05-15', 2640.00);
INSERT INTO orders (id_order, id_invoice, id_product, detail, amount, price) VALUES (1, 1001, 101, 'Laptop Pro', 2, 1320.00);

-- F2 
INSERT INTO invoices (id_invoice, id_customer, id_payment, id_invoice_status, date, total_to_pay) VALUES (1002, 'cliente3@yahoo.com', 2, 2, '2023-05-16', 1856.00);
INSERT INTO orders (id_order, id_invoice, id_product, detail, amount, price) VALUES (2, 1002, 102, 'Smartphone x2', 2, 928.00);

-- F3
INSERT INTO invoices (id_invoice, id_customer, id_payment, id_invoice_status, date, total_to_pay) VALUES (1003, 'cliente2@hotmail.com', 3, 3, '2022-05-17', 363.00);
INSERT INTO orders (id_order, id_invoice, id_product, detail, amount, price) VALUES (3, 1003, 103, 'Tablet', 1, 363.00);

SELECT * from orders

-- DELETE del primer usuairo:

-- 1. Eliminamos ordenes relacionadas con las facturas del cliente
DELETE FROM orders 
WHERE id_invoice IN (
    SELECT id_invoice FROM invoices 
    WHERE id_customer = (SELECT email FROM customers ORDER BY email ASC LIMIT 1)
);

-- 2. Eliminamos facturas del cliente
DELETE FROM invoices 
WHERE id_customer = (SELECT email FROM customers ORDER BY email ASC LIMIT 1);

-- 3. Eliminamos relaciones en products_customers
DELETE FROM products_customers 
WHERE id_customer = (SELECT email FROM customers ORDER BY email ASC LIMIT 1);

-- 4. Finalmente eliminamos al cliente
DELETE FROM customers 
WHERE email = (SELECT email FROM customers ORDER BY email ASC LIMIT 1);

SELECT * from customers

-- UPDATE del ultimo usuario: 

UPDATE customers
SET 
    id_role = 2,  -- rol Cliente Premium
    physical_address = 'Av Comuneros, Bogota',
    age = 55
WHERE email = (SELECT email FROM CUSTOMERS ORDER BY email DESC LIMIT 1);
SELECT * from customers

-- UPDATE de todos los "taxes";

UPDATE taxes
SET percentage = percentage + 4.00;

SELECT * from taxes

-- UPDATE de todos los "precios":
UPDATE products P
SET 
    price = ROUND(P.price * 1.05, 2),
    price_with_tax = ROUND(P.price * 1.05 * (1 + T.percentage/100), 2)
FROM taxes T
WHERE P.id_tax = T.id_tax;

SELECT price, price_with_tax from products