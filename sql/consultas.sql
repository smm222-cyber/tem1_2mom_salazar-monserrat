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