USE adventureworks;

-- 1)
DROP PROCEDURE ordenesIngresadas;
DELIMITER $$
CREATE PROCEDURE ordenesIngresadas (fecha DATE)
BEGIN
	SELECT OrderDate, count(PurchaseOrderID) as cantidadOrdenes
    FROM purchaseorderheader
    WHERE OrderDate = fecha
    GROUP BY OrderDate;
END $$
DELIMITER ;

call ordenesIngresadas('2001-05-17');

-- 2)
-- margenbruto = precio * margen
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION calculoValorNominal (precio decimal(15,3), margen decimal(15,3)) RETURNS DECIMAL (15,3)
BEGIN
	DECLARE margenPrecio DECIMAL (15,3);
    SET margenPrecio = precio * margen;
    RETURN margenPrecio;
END $$
DELIMITER ;
#probar función:
SELECT calculoValorNominal(15.5,6.9);

-- 3)
SELECT p.Name as nombre, calculoValorNominal(pu.UnitPrice,0.20)
FROM product p
JOIN purchaseorderdetail pu ON (p.productID = pu.productID)
ORDER BY nombre;

-- 4)
DROP PROCEDURE masCosto;
DELIMITER $$
CREATE PROCEDURE masCosto (fechaIncio DATE, fechaFin DATE)
BEGIN
	SELECT sum(Freight) as precioEnvio, CustomerID 
    FROM salesorderheader
	WHERE OrderDate BETWEEN fechaIncio AND fechaFin
    GROUP BY CustomerID
    ORDER BY precioEnvio DESC
    LIMIT 10;
END $$
DELIMITER ;

CALL masCosto('2002-01-01','2002-01-31');

-- 5)
DELIMITER $$
CREATE PROCEDURE añadirShipmethod(Nombre VARCHAR(50), Base DOUBLE, Rate DOUBLE)
BEGIN
	INSERT INTO shipmethod (Name,Shipbase,rowguid,ModifiedDate)
    VALUES (Nombre,Base,Rate, NOW());
END $$
DELIMITER ;

CALL añadirShipmethod('Prueba', 1.5, 3.5);

SELECT * FROM shipmethod;