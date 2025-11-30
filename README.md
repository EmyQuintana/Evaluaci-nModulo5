🚀 EVALUACIÓN DE MÓDULO 5: GESTIÓN MAESTRA DE INVENTARIO SKINCARE

Este proyecto presenta un Sistema de Gestión de Inventario Inteligente, diseñado específicamente para una empresa de ventas de productos de cuidado de la piel (skincare). El sistema utiliza un RDBMS para la administración crítica de Productos, Proveedores y Transacciones.

El enfoque principal es garantizar la integridad de los datos y la atomicidad en todas las operaciones de negocio (compras y ventas), asegurando que la información de inventario sea siempre precisa y confiable.

📐 ESTRUCTURA SÓLIDA: MODELO RELACIONAL Y REGLAS DE ORO
El diseño de la base de datos está normalizado hasta la Tercera Forma Normal (3NF), minimizando la redundancia y optimizando la coherencia.

Restricciones Esenciales de Integridad
Se implementaron controles estrictos para garantizar la calidad y validez de los datos:

    Atomicidad y Precisión Monetaria: El campo precio_producto utiliza DECIMAL(10, 2) para garantizar la exactitud en los cálculos financieros, evitando errores de punto flotante.

    Integridad Referencial: Las Claves Foráneas (FOREIGN KEY) en la tabla transacciones se establecieron con la regla ON DELETE RESTRICT. Esto prohíbe la eliminación de un producto o proveedor si existen registros históricos asociados, protegiendo así el historial de transacciones.

    Validación de Dominio: Se aplica la restricción CHECK para asegurar que la cantidad_inventario nunca sea negativa y que la cantidad de producto en una transacción sea siempre mayor a cero.

⚡ AUTOMATIZACIÓN AVANZADA: TRANSACCIONES ATÓMICAS
Para que la actualización de inventario y el registro de la transacción sean operaciones únicas e indivisibles, se utilizan Procedimientos Almacenados y control explícito de transacciones:

    registrar_compra: Utiliza BEGIN TRANSACTION y COMMIT para sumar unidades al inventario y registrar la compra. Incorpora validaciones y usa ROLLBACK si el producto o proveedor no existe.

    registrar_venta: Incluye una validación de stock preventiva. Si el stock_actual es insuficiente para la cantidad solicitada, la transacción se anula inmediatamente mediante ROLLBACK, garantizando que el inventario nunca caiga por debajo de cero.

📊 REQUISITOS DEL PROYECTO: DETALLE DE IMPLEMENTACIÓN
I. Diseño y Estructura
Diseño del Modelo Relacional: Se tradujo el modelo Entidad-Relación (ER) a las tablas Productos, Proveedores y Transacciones, asegurando la identificación de claves primarias y foráneas.

Normalización y Desnormalización: Las tablas cumplen con 3NF. Se incluyó una discusión sobre el uso potencial de desnormalización (ej. añadir precio_transaccion a la tabla de transacciones) para optimizar el rendimiento de los reportes históricos.

Manejo de Restricciones: Implementación de restricciones CHECK y NOT NULL en campos clave para validar la calidad de los datos.

II. Creación de la Base de Datos y Tablas (DDL)
Utilización de SQL para crear las tablas, definiendo correctamente los tipos de dato (ej. DECIMAL para precios) y las restricciones (NOT NULL, PRIMARY KEY, FOREIGN KEY).

III. Manipulación y Consultas Básicas (DML)
Manipulación de Datos (DML): Inserción de datos iniciales en las tres tablas, junto con la demostración de la actualización de inventario y la eliminación segura de productos.

Consultas Básicas: Se realizaron consultas para recuperar productos disponibles, proveedores por producto y transacciones por fecha.

Funciones de Agrupación: Uso de COUNT() y SUM() para calcular el total de unidades vendidas y el valor total de las compras.

IV. Consultas Complejas
Reporte Dinámico: Consulta que recupera el total de ventas de un producto durante el mes anterior, utilizando funciones de fecha dinámicas.

Uniones Avanzadas: Uso de JOINs (INNER, LEFT) para relacionar información entre las tres tablas.

Subconsultas: Implementación de consultas anidadas (subqueries) para obtener productos que no han sido vendidos durante un periodo determinado.