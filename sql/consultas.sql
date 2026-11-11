-- Pregunta 2: Auditoria de calidad e integración de datos.
SELECT
  COUNT(*) AS total_registros,
  COUNT(DISTINCT row_id) AS filas_unicas,
  COUNT(*) - COUNT(DISTINCT row_id) AS identificadores_duplicados,
  COUNT(DISTINCT order_id) AS ordenes_unicas,
  COUNT(DISTINCT customer_id) AS clientes_unicos,
  SUM(CASE WHEN row_id IS NULL THEN 1 ELSE 0 END) AS null_row_id,
  SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS null_order_id,
  SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS fechas_pedido_invalidas,
  SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS fechas_envio_invalidas,
  SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS ventas_no_positivas,
  SUM(CASE WHEN discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS descuentos_fuera_rango,
  SUM(CASE WHEN UNIX_TIMESTAMP(ship_date, 'M/d/yyyy')
    < UNIX_TIMESTAMP(order_date, 'M/d/yyyy') THEN 1 ELSE 0 END)
    AS envios_antes_del_pedido
FROM superstore;
--INTERPRETACIÓN Y CONCLUSIÓN
Con estos resultados se puede identificar el estado de la calidad de los datos en la tabla superstore.
 Se observa que su total de registros, filas únicas, identificadores duplicados, órdenes únicas y clientes únicos.
  Además, se identifican posibles problemas de calidad de datos, como valores nulos en campos clave, fechas de pedido y envío inválidas, ventas que no son positivas, y otros datos irregulares.
-- Pregunta 3: Analisis de evolucion comercial

--Pregunta 5: Ranking de producto según rentabilidad
SELECT
  product_id,
  product_name,
  ROUND(SUM(sales), 2) AS ventas,
  ROUND(SUM(profit), 2) AS ganancia,
  RANK() OVER (ORDER BY SUM(profit) DESC) AS lugar_ganancia
FROM superstore
GROUP BY product_id, product_name
ORDER BY lugar_ganancia
LIMIT 20;

SELECT
  product_id,
  product_name,
  ROUND(SUM(sales), 2) AS ventas,
  RANK() OVER (ORDER BY SUM(sales) DESC) AS lugar_ventas
FROM superstore
GROUP BY product_id, product_name
ORDER BY lugar_ventas
LIMIT 20;

SELECT
  product_id,
  product_name,
  ROUND(100 * SUM(profit) / SUM(sales), 2) AS margen,
  RANK() OVER (ORDER BY SUM(profit) / SUM(sales) ASC) AS lugar_margen
FROM superstore
GROUP BY product_id, product_name
HAVING SUM(sales) > 0
ORDER BY lugar_margen
LIMIT 20;
--INTERPRETACIÓN Y CONCLUSIÓN
-- Con estos resultados se puede identificar los productos más rentables, los productos con mayores ventas y 
--los productos con menor margen de ganancia para poder tomar decisiones de negocio informadas.
--Pregunta 6: Analisis de descuentos

SELECT
  CASE
    WHEN discount = 0 THEN 'Sin descuento'
    WHEN discount <= 0.20 THEN 'Descuento bajo'
    WHEN discount <= 0.50 THEN 'Descuento medio'
    ELSE 'Descuento alto'
  END AS rango_descuento,
  COUNT(*) AS registros,
  ROUND(SUM(profit), 2) AS ganancia,
  ROUND(100 * SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) / COUNT(*), 2)
    AS porcentaje_no_rentable
FROM superstore
GROUP BY
  CASE
    WHEN discount = 0 THEN 'Sin descuento'
    WHEN discount <= 0.20 THEN 'Descuento bajo'
    WHEN discount <= 0.50 THEN 'Descuento medio'
    ELSE 'Descuento alto'
  END
ORDER BY porcentaje_no_rentable DESC;

SELECT
  category,
  sub_category,
  ROUND(AVG(discount), 2) AS descuento_promedio,
  ROUND(SUM(profit), 2) AS ganancia
FROM superstore
GROUP BY category, sub_category
ORDER BY ganancia ASC
LIMIT 20;

-- INTERPRETACIÓN Y CONCLUSIÓN
-- Con estos resultados se puede identificar el impacto de los descuentos en la rentabilidad de los productos,
--saber esto nos ayudará a tomar decisiones sobre la estrategia de precios y descuentos para maximizar la rentabilidad.

-- Pregunta 7: Analisis de tendencias temporales
