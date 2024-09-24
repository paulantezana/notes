DROP DATABASE Sales;
GO
CREATE DATABASE Sales;
GO
USE Sales;

-- Crear la tabla de productos
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Crear la tabla de opciones de productos (Talla, Color, etc.)
CREATE TABLE product_options (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,  -- Ejemplo: 'Talla', 'Color'
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Crear la tabla de valores de opciones (S, M, L, Rojo, Azul, etc.)
CREATE TABLE product_option_values (
    id INT IDENTITY(1,1) PRIMARY KEY,
    option_id INT NOT NULL,
    value NVARCHAR(255) NOT NULL,  -- Ejemplo: 'S', 'M', 'L', 'Rojo', 'Azul'
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (option_id) REFERENCES product_options(id) ON DELETE CASCADE
);

-- Crear la tabla de variantes de productos
CREATE TABLE product_variants (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    sku NVARCHAR(255) UNIQUE,  -- Identificador único para la variante
    price DECIMAL(10, 2) NOT NULL,  -- Precio de la variante
    stock INT NOT NULL DEFAULT 0,  -- Inventario disponible para la variante
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Crear la tabla de valores de opciones asociados a cada variante
CREATE TABLE variant_option_values (
    id INT IDENTITY(1,1) PRIMARY KEY,
    variant_id INT NOT NULL,
    option_value_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE NO ACTION,
    FOREIGN KEY (option_value_id) REFERENCES product_option_values(id) ON DELETE NO ACTION
);

-- Ejemplo de inserción de datos

-- Insertar productos
INSERT INTO products (name, description, price) 
VALUES ('Camiseta', 'Camiseta de algodón', 15.00);

-- Insertar opciones para el producto 'Camiseta' (Talla y Color)
INSERT INTO product_options (product_id, name) VALUES (1, 'Talla');
INSERT INTO product_options (product_id, name) VALUES (1, 'Color');
INSERT INTO product_options (product_id, name) VALUES (1, 'Material');

-- Insertar valores para las opciones (Tallas: S, M, Colores: Rojo, Azul, Materiales: Algodón, Poliéster)
INSERT INTO product_option_values (option_id, value) VALUES (1, 'S');
INSERT INTO product_option_values (option_id, value) VALUES (1, 'M');
INSERT INTO product_option_values (option_id, value) VALUES (2, 'Rojo');
INSERT INTO product_option_values (option_id, value) VALUES (2, 'Azul');
INSERT INTO product_option_values (option_id, value) VALUES (3, 'Algodón');
INSERT INTO product_option_values (option_id, value) VALUES (3, 'Poliéster');

-- Insertar variantes de productos con SKU y stock (ejemplo para combinaciones de opciones)
INSERT INTO product_variants (product_id, sku, price, stock) 
VALUES (1, 'SKU12345', 15.00, 100);  -- Talla M, Color Rojo, Material Algodón
INSERT INTO product_variants (product_id, sku, price, stock) 
VALUES (1, 'SKU12346', 15.00, 50);   -- Talla S, Color Azul, Material Poliéster

-- Relacionar las variantes con sus opciones (Variant 1: Talla M, Color Rojo, Material Algodón)
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (1, 2);  -- M
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (1, 3);  -- Rojo
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (1, 5);  -- Algodón

-- Relacionar la segunda variante (Variant 2: Talla S, Color Azul, Material Poliéster)
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (2, 1);  -- S
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (2, 4);  -- Azul
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (2, 6);  -- Poliéster

-- Insertar más variantes si es necesario...

-- Select para obtener el inventario completo con todas las variantes y sus opciones
SELECT 
    p.name AS product_name,
    pv.sku,
    STRING_AGG(CONCAT(po.name, ': ', pov.value), ', ') WITHIN GROUP (ORDER BY po.id) AS variant_options,
    pv.stock
FROM 
    product_variants pv
JOIN 
    products p ON pv.product_id = p.id
JOIN 
    variant_option_values vov ON pv.id = vov.variant_id
JOIN 
    product_option_values pov ON vov.option_value_id = pov.id
JOIN 
    product_options po ON pov.option_id = po.id
GROUP BY 
    pv.id, p.name, pv.sku, pv.stock;



    -- Insertar nuevas opciones para el producto 'Camiseta' (Tipo de Longitud y Cuello)
INSERT INTO product_options (product_id, name) VALUES (1, 'Tipo de Longitud');
INSERT INTO product_options (product_id, name) VALUES (1, 'Cuello');



-- Insertar valores para la opción 'Tipo de Longitud' (Corto, Largo)
INSERT INTO product_option_values (option_id, value) VALUES (4, 'Corto');
INSERT INTO product_option_values (option_id, value) VALUES (4, 'Largo');

-- Insertar valores para la opción 'Cuello' (Redondo, V)
INSERT INTO product_option_values (option_id, value) VALUES (5, 'Redondo');
INSERT INTO product_option_values (option_id, value) VALUES (5, 'V');



--//
-- Insertar nuevas variantes con todas las combinaciones de opciones (Talla, Color, Material, Tipo de Longitud, Cuello)
INSERT INTO product_variants (product_id, sku, price, stock) 
VALUES (1, 'SKU12347', 20.00, 75);   -- Talla M, Color Azul, Material Algodón, Tipo de Longitud Corto, Cuello Redondo

-- Relacionar la nueva variante (Variant 3: Talla M, Color Azul, Material Algodón, Tipo de Longitud Corto, Cuello Redondo)
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (3, 2);  -- Talla M
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (3, 4);  -- Color Azul
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (3, 5);  -- Material Algodón
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (3, 7);  -- Tipo de Longitud Corto
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (3, 9);  -- Cuello Redondo

-- Insertar otra variante con diferentes combinaciones
INSERT INTO product_variants (product_id, sku, price, stock) 
VALUES (1, 'SKU12348', 22.00, 50);   -- Talla S, Color Rojo, Material Poliéster, Tipo de Longitud Largo, Cuello V

-- Relacionar la nueva variante (Variant 4: Talla S, Color Rojo, Material Poliéster, Tipo de Longitud Largo, Cuello V)
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (4, 1);  -- Talla S
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (4, 3);  -- Color Rojo
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (4, 6);  -- Material Poliéster
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (4, 8);  -- Tipo de Longitud Largo
INSERT INTO variant_option_values (variant_id, option_value_id) VALUES (4, 10); -- Cuello V
