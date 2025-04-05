CREATE TABLE countries (
    id_country INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE priorities (
    id_priority INT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL
);

CREATE TABLE contact_request (
    id_email VARCHAR(255) PRIMARY KEY,
    id_country INT,
    id_priority INT,
    name VARCHAR(100) NOT NULL,
    detail TEXT,
    physical_address TEXT,
    FOREIGN KEY (id_country) REFERENCES countries(id_country),
    FOREIGN KEY (id_priority) REFERENCES priorities(id_priority)
);

INSERT INTO countries (id_country, name) VALUES
(1, 'Estados Unidos'),
(2, 'Venezuela'),
(3, 'Canadá'),
(4, 'Colombia'),
(5, 'Argentina');

SELECT * from countries

INSERT INTO priorities (id_priority, type_name) VALUES
(1, 'Alta'),
(2, 'Media'),
(3, 'Baja');

SELECT * FROM priorities

INSERT INTO contact_request (id_email, id_country, id_priority, name, detail, physical_address) VALUES
('cliente1@example.com', 1, 1, 'Luis Palacios', 'Consulta sobre productos', 'Time Square, NY'),
('cliente2@example.com', 2, 2, 'Armando Alonso', 'Soporte técnico requerido', 'Av Carabobo, Valencia'),
('cliente3@example.com', 4, 3, 'Pedro Perez', 'Información general', 'Av Comuneros, Medellin');

SELECT * from contact_request

DELETE FROM contact_request 
WHERE id_email = (SELECT id_email FROM contact_request ORDER BY id_email DESC LIMIT 1);

SELECT * from contact_request

UPDATE contact_request 
SET 
    id_priority = 2,
    detail = 'Consulta actualizada sobre productos',
    physical_address = 'Time Square, NY'
WHERE id_email = (SELECT id_email FROM contact_request ORDER BY id_email ASC LIMIT 1);

SELECT * from contact_request