USE adventureworks;

-- 1)
SELECT DISTINCT sm.name as transporte, co.FirstName, co.lastname,  psc.Name as subcategoria
FROM salesorderheader soh
JOIN shipmethod sm ON ( soh.ShipMethodID = sm.ShipMethodID)
JOIN contact co ON (soh.ContactID = co.ContactID)
JOIN salesorderdetail sod on (soh.SalesOrderID = sod.SalesOrderID)
JOIN product p on (sod.ProductID = p.ProductID)
JOIN productsubcategory psc on (p.ProductSubcategoryID = psc.ProductSubcategoryID)
WHERE psc.Name like "Mountain Bikes" and year(soh.OrderDate) BETWEEN 2000 and 2003 and sm.name = "CARGO TRANSPORT 5";
 
 -- 2)
SELECT DISTINCT CONCAT(co.FirstName," " ,co.lastname) as nombre, count(soh.SalesOrderID), sum(SubTotal) as ventas
FROM salesorderheader soh
JOIN shipmethod sm ON ( soh.ShipMethodID = sm.ShipMethodID)
JOIN contact co ON (soh.ContactID = co.ContactID)
JOIN salesorderdetail sod on (soh.SalesOrderID = sod.SalesOrderID)
JOIN product p on (sod.ProductID = p.ProductID)
JOIN productsubcategory psc on (p.ProductSubcategoryID = psc.ProductSubcategoryID)
WHERE psc.Name like "Mountain Bikes" and year(soh.OrderDate) BETWEEN 2000 and 2003 and sm.name = "CARGO TRANSPORT 5"
GROUP BY nombre
ORDER BY ventas DESC;

-- 3)
SELECT sum(OrderQty) as cantidad, year(OrderDate) as año, sm.name as transporte
FROM salesorderheader sh
JOIN salesorderdetail sd on (sh.SalesOrderID = sd.SalesOrderID)
JOIN shipmethod sm ON ( sh.ShipMethodID = sm.ShipMethodID)
GROUP BY año, transporte;

-- 4)
SELECT sum(soh.SubTotal) as ganancias, p.name as productos, count(soh.SalesOrderID) as cantidadDeVentas
FROM salesorderheader soh
JOIN salesorderdetail sod on (soh.SalesOrderID = sod.SalesOrderID)
JOIN product p on (sod.ProductID = p.ProductID)
GROUP BY productos;

-- 5)
SELECT stp.CountryRegionCode as Lugar,  p.name as productos, sum(soh.SubTotal * soh.SalesOrderID)
FROM salesorderheader soh
JOIN salesorderdetail sod on (soh.SalesOrderID = sod.SalesOrderID)
JOIN product p on (sod.ProductID = p.ProductID)
JOIN stateprovince stp on (soh.TerritoryID = stp.TerritoryID)
GROUP BY Lugar, productos;

-- 6)
USE henry;

SELECT  c.IdCohorte
FROM cohorte c
LEFT JOIN Alumno a ON (a.Idcohorte = c.IdCohorte)
WHERE a.IdCohorte IS NULL;

