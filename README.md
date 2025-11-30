EVALUACION DE MODULO 5 - PROYECTO: GESTIÓN INTELIGENTE DE INVENTARIO DE SKINCARE

Este proyecto presenta un sistema de gestión de inventario, diseñado específicamente para una empresa de ventas de productos de cuidado de la piel (skincare). Utiliza un Sistema Gestor de Bases de Datos Relacionales (RDBMS) para almacenar, consultar y administrar de manera eficiente la información crítica sobre Productos, Proveedores y Transacciones.

El objetivo principal es asegurar la integridad de los datos y la atomicidad en las operaciones de compra y venta, garantizando que el inventario se mantenga siempre preciso.

El diseño del sistema se basa en un modelo Entidad-Relación normalizado a la Tercera Forma Normal (3NF), lo que minimiza la redundancia y maximiza la coherencia.

Seimplementaron restricciones estrictas para asegurar la calidad de los datos:

Claves Foráneas (FOREIGN KEY): Establecidas con la regla ON DELETE RESTRICT en la tabla transacciones para evitar la eliminación accidental de un producto o proveedor si existen registros históricos asociados.

Precisión Monetaria: El campo precio_producto utiliza el tipo de dato DECIMAL(10, 2) en lugar de FLOAT para garantizar la exactitud en los cálculos financieros.

Validación de Inventario: Se usa la restricción CHECK para asegurar que la cantidad_inventario nunca sea negativa y que la cantidad de producto en una transacción sea siempre mayor a cero.

Para garantizar que la actualización de inventario y el registro de la transacción sean una operación única e indivisible, se utilizan Procedimientos Almacenados y comandos transaccionales:

registrar_compra: Usa BEGIN TRANSACTION y COMMIT para sumar unidades al inventario y registrar la compra simultáneamente. Incluye validaciones para la existencia de producto/proveedor y usa ROLLBACK en caso de error.

registrar_venta: Incluye una validación de stock. Si el stock_actual es insuficiente para la cantidad_producto, la transacción se anula mediante ROLLBACK, evitando inventarios negativos.

Instrucciones de Implementación y Ejecución
Para poner en marcha el sistema, siga los siguientes pasos en su cliente de MySQL/MariaDB (como MySQL Workbench o VS Code con extensión SQL):

1. Configuración del Esquema (DDL)
Ejecutar tablas_inventario.sql: Ejecute este script completo para crear la base de datos inventario y las tres tablas (productos, proveedores, transacciones). Este script también inserta los datos iniciales.

2. Poblar y Demostrar Manipulación (DML)
Ejecutar DML_inventario.sql: Ejecute este script para:

Insertar productos y proveedores adicionales.

Ver demostraciones de actualización de inventario (suma y resta de unidades) y de eliminación segura de un producto que no infrinja la integridad referencial.

3. Implementar y Probar la Atomicidad (Transacciones)
Ejecutar transacciones_SQL_inventario.sql: Ejecute este script para definir los procedimientos almacenados registrar_compra y registrar_venta.

Pruebas de CALL: Ejecute las llamadas de ejemplo (CALL registrar_compra... y CALL registrar_venta...) incluidas al final del script para verificar la funcionalidad: observe cómo las llamadas exitosas aplican el COMMIT y cómo las llamadas fallidas (ej. stock insuficiente) aplican el ROLLBACK.

4. Ejecutar Consultas para Reportes
Ejecutar consultas_basicas_inventario.sql: Pruebe las consultas básicas, incluyendo las funciones de agregación.

Ejecutar consultas_complejas_inventario.sql: Pruebe las consultas avanzadas, especialmente las dinámicas de fechas, para validar el análisis de reportes.

5. Documentación del Diseño
El archivo documentacion.txt contiene el informe detallado sobre el diseño de las tablas, las decisiones de normalización y la explicación de las consultas clave utilizadas en el sistema.