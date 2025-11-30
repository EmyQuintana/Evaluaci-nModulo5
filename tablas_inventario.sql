-- Active: 1755737509921@@127.0.0.1@3306@mysql
/*Creación de la Base de Datos y Tablas - 'tablas_inventario.sql'

  Utiliza SQL para crear las tablas productos, proveedores y transacciones en la base de datos.

  Define las restricciones de nulidad, llaves primarias y llaves foráneas para garantizar la integridad de los datos.

  Establece el tipo de dato adecuado para cada atributo (por ejemplo, VARCHAR, INT, DECIMAL).*/


-- Tablas para inventario empresa - productocos, proveedores y transacciones
DROP DATABASE IF EXISTS inventario;
CREATE DATABASE IF NOT EXISTS inventario;
USE inventario;

-- 1. Tabla Productos
CREATE TABLE productos
(
  id_producto          INT          NOT NULL AUTO_INCREMENT,
  nombre_producto      VARCHAR(100) NOT NULL,
  cantidad_inventario  INT          NOT NULL CHECK (cantidad_inventario >= 0), -- Restricción: Cantidad >= 0
  precio_producto      DECIMAL(10, 2) NOT NULL CHECK (precio_producto >= 0),  -- DECIMAL para precisión monetaria
  descripcion_producto TEXT,
  PRIMARY KEY (id_producto)
);

ALTER TABLE productos
  ADD CONSTRAINT UQ_id_producto UNIQUE (id_producto);

ALTER TABLE productos
  ADD CONSTRAINT UQ_nombre_producto UNIQUE (nombre_producto);

-- 2. Tabla Proveedores
CREATE TABLE proveedores
(
  id_proveedor        INT          NOT NULL AUTO_INCREMENT,
  nombre_proveedor    VARCHAR(100) NOT NULL,
  direccion_proveedor VARCHAR(100) NOT NULL,
  telefono_proveedor  VARCHAR(15)  NOT NULL,
  correo_proveedor    VARCHAR(50)  NOT NULL,
  PRIMARY KEY (id_proveedor)
);

ALTER TABLE proveedores
  ADD CONSTRAINT UQ_id_proveedor UNIQUE (id_proveedor);

-- 3. Tabla Transacciones
CREATE TABLE transacciones
(
  id_transaccion    INT        NOT NULL AUTO_INCREMENT,
  tipo_transaccion  ENUM('compra', 'venta') NOT NULL, -- ENUM para tipos de transacción
  fecha_transaccion DATETIME   NOT NULL,
  cantidad_producto INT        NOT NULL CHECK (cantidad_producto > 0), -- Restricción: Cantidad > 0
  id_proveedor      INT        NOT NULL, -- Se mantiene NOT NULL según el modelo
  id_producto       INT        NOT NULL,
  PRIMARY KEY (id_transaccion)
);

ALTER TABLE transacciones
  ADD CONSTRAINT UQ_id_transaccion UNIQUE (id_transaccion);

-- Integridad Referencial Mejorada: ON DELETE RESTRICT
ALTER TABLE transacciones
  ADD CONSTRAINT FK_proveedores_TO_transacciones
    FOREIGN KEY (id_proveedor)
    REFERENCES proveedores (id_proveedor)
    ON DELETE RESTRICT -- Impide borrar proveedor con transacciones
    ON UPDATE CASCADE;

ALTER TABLE transacciones
  ADD CONSTRAINT FK_productos_TO_transacciones
    FOREIGN KEY (id_producto)
    REFERENCES productos (id_producto)
    ON DELETE RESTRICT -- Impide borrar producto con transacciones
    ON UPDATE CASCADE;

-- datos de ejemplo iniciales (Productos de Skincare)
INSERT INTO productos (nombre_producto, cantidad_inventario, precio_producto, descripcion_producto) VALUES
('Serum Vitamina C', 80, 25.50, 'Serum antioxidante con ácido ascórbico al 15%'),
('Crema Hidratante', 150, 18.00, 'Crema facial diaria con ácido hialurónico'),
('Protector Solar FPS 50', 120, 30.00, 'Protector solar de amplio espectro, toque seco');

INSERT INTO proveedores (nombre_proveedor, direccion_proveedor, telefono_proveedor, correo_proveedor) VALUES
('Laboratorios Piel Sana', '123 Calle Belleza, Bogotá, COL', '555-1234', 'contacto@pielsana.com'),
('Cosméticos Bio', '456 Av. Natural, Lima, PER', '555-5678', 'ventas@bio.com'),
('Insumos Dermatológicos', '789 Carr. Pura, Santiago, CHL', '555-9012', 'info@dermatologicos.cl');  

-- Transacciones 
INSERT INTO transacciones (tipo_transaccion, fecha_transaccion, cantidad_producto, id_proveedor, id_producto) VALUES
('compra', '2024-01-15 10:00:00', 40, 1, 1), 
('venta', '2024-01-16 11:30:00', 30, 2, 2),  
('venta', '2024-01-18 14:45:00', 10, 1, 1),  
('venta', '2024-01-20 09:15:00', 5, 1, 3);   