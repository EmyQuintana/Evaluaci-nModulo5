/*Consultas Complejas - 'consultas_complejas_inventario.sql'

    Realiza una consulta que recupere el total de ventas de un producto durante el mes anterior.

    Utiliza JOINs (INNER, LEFT) para obtener información relacionada entre las tablas productos, proveedores y transacciones.

    Implementa una consulta con subconsultas (subqueries) para obtener productos que no se han vendido durante un período determinado.*/


-- 1. Total de ventas de un producto durante el mes anterior (Consulta DINÁMICA)
SELECT 
    P.nombre_producto, 
    SUM(T.cantidad_producto) AS total_unidades_vendidas,
    SUM(T.cantidad_producto * P.precio_producto) AS valor_total_ventas
FROM transacciones T
JOIN productos P ON T.id_producto = P.id_producto
WHERE T.tipo_transaccion = 'venta'
  -- Periodo dinámico: Mes anterior
  AND T.fecha_transaccion >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
  AND T.fecha_transaccion < DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY P.nombre_producto
ORDER BY valor_total_ventas DESC;


-- 2. Uso de JOINs (INNER y LEFT) para obtener información relacionada
-- Muestra todas las transacciones realizadas (INNER JOIN)
SELECT 
    p.nombre_producto, 
    t.tipo_transaccion, 
    t.fecha_transaccion, 
    t.cantidad_producto, 
    pr.nombre_proveedor
FROM transacciones t
INNER JOIN productos p ON t.id_producto = p.id_producto
INNER JOIN proveedores pr ON t.id_proveedor = pr.id_proveedor
ORDER BY t.fecha_transaccion ASC;

-- Muestra todos los productos
SELECT 
    p.nombre_producto, 
    t.tipo_transaccion, 
    t.fecha_transaccion, 
    t.cantidad_producto, 
    pr.nombre_proveedor
FROM productos p
LEFT JOIN transacciones t ON p.id_producto = t.id_producto
LEFT JOIN proveedores pr ON t.id_proveedor = pr.id_proveedor
ORDER BY p.nombre_producto;

-- 3. Consulta con Subconsulta (subqueries) para obtener productos que no se han vendido en el último año.
SELECT nombre_producto
FROM productos
WHERE id_producto NOT IN (
    SELECT id_producto
    FROM transacciones
    WHERE tipo_transaccion = 'venta'
    AND fecha_transaccion >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) 
);