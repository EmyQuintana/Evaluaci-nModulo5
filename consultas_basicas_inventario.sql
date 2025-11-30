/*Consultas Básicas - 'consultas_basicas_inventario.sql'

    Realiza consultas básicas utilizando el lenguaje SQL:

    Recupera todos los productos disponibles en el inventario.

    Recupera todos los proveedores que suministran productos específicos.

    Consulta las transacciones realizadas en una fecha específica.

    Realiza consultas de selección con funciones de agrupación, como COUNT() y SUM(), para calcular el número total de productos vendidos o el valor total de las compras.*/


-- 1. Recupera todos los productos disponibles en el inventario.
SELECT p.id_producto, p.nombre_producto, p.cantidad_inventario, p.precio_producto
FROM productos p
WHERE p.cantidad_inventario >= 1
ORDER BY p.nombre_producto;

-- 2. Recupera todos los proveedores que suministran un producto específico 
SELECT pr.nombre_proveedor
FROM proveedores pr
JOIN transacciones t ON pr.id_proveedor = t.id_proveedor
JOIN productos p ON t.id_producto = p.id_producto
WHERE p.nombre_producto = 'Serum Vitamina C' AND t.tipo_transaccion = 'compra'
GROUP BY pr.nombre_proveedor;

-- 3. Consulta las transacciones realizadas en una fecha específica 
SELECT *
FROM transacciones
WHERE DATE(fecha_transaccion) = '2024-01-15';


-- 4. Consultas de selección con funciones de agrupación para calcular el número total de productos vendidos o el valor total de las compras.

SELECT 
    p.nombre_producto, 
    SUM(t.cantidad_producto) AS cantidad_vendida, 
    SUM(t.cantidad_producto * p.precio_producto) AS total_ingresos_venta
FROM productos p
JOIN transacciones t ON p.id_producto = t.id_producto
WHERE t.tipo_transaccion = 'venta'
GROUP BY p.nombre_producto
ORDER BY total_ingresos_venta DESC;