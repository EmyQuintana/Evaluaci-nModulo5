/*Manipulación de Datos (DML) - 'DML_inventario.sql'

    Inserta datos en las tablas productos, proveedores y transacciones.

    Actualiza la cantidad de inventario de un producto después de una venta o compra. (Se utiliza una sentencia UPDATE directa)

    Elimina un producto de la base de datos si ya no está disponible. (Solo se permite si el producto no tiene transacciones asociadas gracias a la restricción ON DELETE RESTRICT)

    Al eliminar un producto, se debe aplicar integridad referencial al actualizar o eliminar registros relacionados.*/


--Inserta datos adicionales
INSERT INTO productos (nombre_producto, cantidad_inventario, precio_producto, descripcion_producto) VALUES
('Mascarilla Facial de Arcilla', 50, 12.50, 'Mascarilla purificante con carbón activado'),
('Limpiador Facial Suave', 200, 10.00, 'Limpiador en gel para piel sensible'),
('Tónico Exfoliante', 90, 20.00, 'Tónico con AHA y BHA para uso nocturno');

-- Se añaden 2 proveedores
INSERT INTO proveedores (nombre_proveedor, direccion_proveedor, telefono_proveedor, correo_proveedor) VALUES
('Suministros Estéticos', '123 Zona Franca, Panamá', '123-456-7890', 'RcA9o@example.com'),
('Distribuidora Belleza Total', '456 Centro Comercial, Madrid', '987-654-3210', 'H2P4L@example.com');

-- Se añaden 3 transacciones
INSERT INTO transacciones (tipo_transaccion, fecha_transaccion, cantidad_producto, id_proveedor, id_producto) VALUES
('compra', '2024-01-15 10:00:00', 25, 5, 4), -- Compra de Mascarilla (id=4)
('compra', '2024-01-17 09:15:00', 50, 3, 3), -- Compra de Protector Solar (id=3)
('venta', '2024-01-18 11:45:00', 15, 4, 6);  -- Venta de Tónico Exfoliante (id=6)


-- -----------------------------------------------------------------------
-- Actualiza la cantidad de inventario de un producto después de una venta o compra.

-- Ejemplo de ACTUALIZACIÓN de Inventario por COMPRA 
UPDATE productos 
SET cantidad_inventario = cantidad_inventario + 50 
WHERE id_producto = 5;

-- Ejemplo de ACTUALIZACIÓN de Inventario por VENTA 
UPDATE productos 
SET cantidad_inventario = cantidad_inventario - 5 
WHERE id_producto = 6;

-- -----------------------------------------------------------------------
-- Ejemplo de ELIMINACIÓN de un producto que no tiene transacciones asociadas.

-- Primero insertamos un producto de prueba nuevo para eliminarlo:
INSERT INTO productos (nombre_producto, cantidad_inventario, precio_producto, descripcion_producto) VALUES ('Aceite de Rosas', 10, 15.00, 'Aceite facial nutritivo');

-- Luego lo eliminamos. Esto se ejecuta correctamente ya que NO tiene registros en la tabla TRANSACCIONES.
DELETE FROM productos WHERE nombre_producto = 'Aceite de Rosas'; 

-- 3. Intento de eliminar un producto con transacciones (id_producto = 1: Serum Vitamina C).
-- ESTA SENTENCIA FALLARÁ debido a la restricción ON DELETE RESTRICT, garantizando la integridad.
-- DELETE FROM productos WHERE id_producto = 1;
-- -----------------------------------------------------------------------