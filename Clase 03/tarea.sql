-- 1)1. Obtener un listado de cuál fue el volumen de ventas (cantidad) por año
-- y método de envío mostrando para cada registro, qué porcentaje representa del total del año. 
-- Resolver utilizando Subconsultas y Funciones Ventana, luego comparar la diferencia en la demora de las consultas.
USE adventureworks;

#subconsulta
SELECT  sum(sd.OrderQty) as cantidad ,sm.name as transporte, sum(sd.OrderQty)/cantidad_total *100 as porcentaje, año 
FROM salesorderheader soh 
JOIN shipmethod sm ON (soh.ShipMethodID = sm.ShipMethodID)
JOIN salesorderdetail sd ON (sd.salesorderID = soh.salesorderID)
JOIN (SELECT sum(sod.OrderQty) as cantidad_total, YEAR(soh.OrderDate) as año
								FROM salesorderheader soh
                                JOIN salesorderdetail sod 
                                ON (sod.SalesOrderID = soh.SalesOrderID)
                                GROUP BY año) as v 
							ON (YEAR(soh.OrderDate) = v.Año)
GROUP BY año, transporte; 

##########################0.594 seg##################################################
SELECT año,transporte,cantidad, cantidad/sum(cantidad) OVER (PARTITION BY año)*100 as porcentajeaño
FROM
(SELECT sm.name as transporte, year(soh.orderdate) as año, sum(sod.OrderQty) as cantidad
FROM salesorderheader soh
JOIN salesorderdetail sod ON (soh.SalesOrderID = sod.SalesOrderID)
JOIN shipmethod sm on (soh.ShipMethodID = sm.ShipMethodID)
GROUP BY año, transporte) as v;
##########################0.235 seg##################################################


-- 2. Obtener un listado por categoría de productos, con el valor total de ventas y
-- productos vendidos, mostrando para ambos, su porcentaje respecto del total.
SELECT cantidad,categoria, cantidad/sum(cantidad) OVER ()*100 as porcentaje_categoria,
							venta/sum(venta) OVER ()*100 as porcentaje_venta
FROM
(SELECT sum(sod.OrderQty) as cantidad, pc.Name as categoria,SUM(sod.LineTotal) as Venta
FROM salesorderdetail sod
JOIN product p ON (sod.ProductID =p.ProductID)
JOIN productcategory pc ON (p.ProductSubcategoryID = pc.ProductCategoryID)
GROUP BY categoria) v;

-- 3. Obtener un listado por país (según la dirección de envío), 
-- con el valor total de ventas y productos vendidos, mostrando para ambos, 
-- su porcentaje respecto del total.

SELECT cod_pais,cantidad,venta, cantidad/sum(cantidad) OVER ()*100 as porcentaje_categoria,
							venta/sum(venta) OVER ()*100 as porcentaje_venta
FROM
(SELECT sum(sod.OrderQty) as cantidad, SUM(sod.LineTotal) as Venta, sp.StateProvinceCode as cod_pais
FROM salesorderheader soh
JOIN stateprovince sp ON (soh.TerritoryID = sp.TerritoryID)
JOIN salesorderdetail sod ON (soh.SalesOrderID = sod.SalesOrderID)
GROUP BY cod_pais) v;

-- 4. Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal), 
-- sobre las ordenes realizadas. Investigar las funciones FLOOR() y CEILING().
SELECT sod.ProductID as productoID, AVG(sod.LineTotal) as mediana
FROM salesorderdetail sod
GROUP BY productoID;



