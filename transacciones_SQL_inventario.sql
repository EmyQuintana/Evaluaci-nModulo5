/*Transacciones SQL - 'transacciones_SQL_inventario.sql'

  Realiza una transacción para registrar una compra de productos. Utiliza el comando BEGIN TRANSACTION, COMMIT y ROLLBACK para asegurar que los cambios se apliquen correctamente.

  Asegúrate de que los cambios en la cantidad de inventario y las transacciones se realicen de forma atómica.

  Utiliza el modo AUTOCOMMIT para manejar operaciones individuales si es necesario.*/

-- **Se utiliza la estructura de Stored Procedures para garantizar la atomicidad (BEGIN TRANSACTION / COMMIT / ROLLBACK)**

--  para registrar una COMPRA y actualizar el inventario
DELIMITER $$
DROP PROCEDURE IF EXISTS registrar_compra $$

CREATE PROCEDURE registrar_compra(
    IN p_cantidad INT,
    IN p_id_proveedor INT,
    IN p_id_producto INT
)
proc_compra: BEGIN
  DECLARE v_existe_producto INT DEFAULT 0;
  DECLARE v_existe_proveedor INT DEFAULT 0;

  START TRANSACTION;

  -- Validar parámetros
  IF p_id_producto IS NULL OR p_cantidad IS NULL OR p_id_proveedor IS NULL OR p_cantidad <= 0 THEN
    ROLLBACK;
    SELECT 'ERROR: parámetros inválidos o cantidad <= 0' AS estado;
    LEAVE proc_compra;
  END IF;

  -- Verificar que el producto y proveedor existan
  SELECT COUNT(*) INTO v_existe_producto FROM productos WHERE id_producto = p_id_producto;
  SELECT COUNT(*) INTO v_existe_proveedor FROM proveedores WHERE id_proveedor = p_id_proveedor;

  IF v_existe_producto = 0 THEN
    ROLLBACK;
    SELECT 'ERROR: el producto no existe' AS estado;
    LEAVE proc_compra;
  END IF;

  IF v_existe_proveedor = 0 THEN
    ROLLBACK;
    SELECT 'ERROR: el proveedor no existe' AS estado;
    LEAVE proc_compra;
  END IF;

  --  Insertar la transacción
  INSERT INTO transacciones (
    tipo_transaccion, 
    fecha_transaccion, 
    cantidad_producto, 
    id_proveedor, 
    id_producto
  )
  VALUES (
    'compra', 
    NOW(), 
    p_cantidad, 
    p_id_proveedor, 
    p_id_producto
  );

  -- Actualizar inventario: se suma los productos comprados
  UPDATE productos 
  SET cantidad_inventario = cantidad_inventario + p_cantidad 
  WHERE id_producto = p_id_producto;

  COMMIT;
  SELECT 'OK: compra registrada correctamente' AS estado;
END $$


-- Procedimiento almacenado para registrar una VENTA y actualizar el inventario (Garantiza stock suficiente)
DROP PROCEDURE IF EXISTS registrar_venta $$

CREATE PROCEDURE registrar_venta(
    IN p_cantidad INT,
    IN p_id_producto INT,
    IN p_id_cliente INT 
)
proc_venta: BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_existe_producto INT DEFAULT 0;

    START TRANSACTION;

    -- Validar parámetros y existencia de producto
    IF p_id_producto IS NULL OR p_cantidad IS NULL OR p_cantidad <= 0 THEN
        ROLLBACK;
        SELECT 'ERROR: parámetros inválidos o cantidad <= 0' AS estado;
        LEAVE proc_venta;
    END IF;
    
    SELECT COUNT(*) INTO v_existe_producto FROM productos WHERE id_producto = p_id_producto;
    IF v_existe_producto = 0 THEN
        ROLLBACK;
        SELECT 'ERROR: el producto no existe' AS estado;
        LEAVE proc_venta;
    END IF;

    -- Verificar stock suficiente (Garantizar que cantidad_inventario no sea negativa)
    SELECT cantidad_inventario INTO v_stock_actual FROM productos WHERE id_producto = p_id_producto;
    IF v_stock_actual < p_cantidad THEN
        ROLLBACK;
        SELECT CONCAT('ERROR: Inventario insuficiente. Stock actual: ', v_stock_actual) AS estado;
        LEAVE proc_venta;
    END IF;

    -- Registrar la transacción de venta
    INSERT INTO transacciones (
      tipo_transaccion, 
      fecha_transaccion, 
      cantidad_producto, 
      id_proveedor, -- Usamos el id_proveedor para el cliente/tercero
      id_producto
    )
    VALUES (
      'venta', 
      NOW(), 
      p_cantidad, 
      p_id_cliente, 
      p_id_producto
    ); 

    -- Actualizar inventario: se restan los productos vendidos
    UPDATE productos 
    SET cantidad_inventario = cantidad_inventario - p_cantidad 
    WHERE id_producto = p_id_producto;

    COMMIT;
    SELECT 'OK: venta registrada correctamente' AS estado;
END $$
DELIMITER ;

-- **Ejemplos**

-- Compra correcta 
CALL registrar_compra(50, 1, 3);

-- Venta correcta 
CALL registrar_venta(10, 1, 2);

-- Venta con error (stock insuficiente)
CALL registrar_venta(500, 1, 2);

-- Compra con error (producto no existe)
CALL registrar_compra(50, 1, 99);