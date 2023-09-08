USE practicamodulo3_propio;
-- 1
SELECT FechaUltimaModificacion as actualizacion
FROM cliente
ORDER BY actualizacion DESC;
#Podemos ver claramente que no está actualizada
SELECT Fecha as actualizacion
FROM compra
ORDER BY actualizacion DESC
LIMIT 1;
#Está actualizada hasta el 25-12-2020
SELECT Fecha as actualizacion
FROM gasto
ORDER BY actualizacion DESC
LIMIT 1;
#Está actualizada hasta el 01-12-2020
SELECT Fecha as actualizacion
FROM venta
ORDER BY actualizacion DESC
LIMIT 1;
#Está actualizada hasta el 30-12-2020
#######################################
#Podemos concluir que:
#a - No está actualizado a este año
#b - Las fechas son disimiles, por lo cual faltarían datos

-- 2) Hay datos faltantes en proveedor
-- 3) Se saben el origen de tres: de ventas, gastos y compras, tres archivos CSV generados a partir del sistema transaccional de la empresa.

SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS `UC_Words`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
     BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendario VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                        MONTH(currentdate),
                        DAY(currentdate),
                        QUARTER(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

/*Se genera la dimension calendario*/
DROP TABLE IF EXISTS `calendario`;
CREATE TABLE calendario (
        id                      INTEGER PRIMARY KEY,  -- year*10000+month*100+day
        fecha                 	DATE NOT NULL,
        anio                    INTEGER NOT NULL,
        mes                   	INTEGER NOT NULL, -- 1 to 12
        dia                     INTEGER NOT NULL, -- 1 to 31
        trimestre               INTEGER NOT NULL, -- 1 to 4
        semana                  INTEGER NOT NULL, -- 1 to 52/53
        dia_nombre              VARCHAR(9) NOT NULL, -- 'Monday', 'Tuesday'...
        mes_nombre              VARCHAR(9) NOT NULL -- 'January', 'February'...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

ALTER TABLE `calendario` ADD UNIQUE(`fecha`);
CALL Llenar_dimension_calendario('2015-01-01', '2020-12-31');

/*LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Calendario.csv' 
INTO TABLE calendario
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;*/

DROP TABLE IF EXISTS sucursal;
CREATE TABLE IF NOT EXISTS sucursal (
	ID			INTEGER,
	Sucursal	VARCHAR(40),
	Domicilio	VARCHAR(150),
	Localidad	VARCHAR(80),
	Provincia	VARCHAR(50),
	Latitud	VARCHAR(30),
	Longitud	VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Sucursales_ANSI.csv' 
INTO TABLE sucursal
CHARACTER SET latin1 
FIELDS TERMINATED BY ';' ENCLOSED BY '\"' ESCAPED BY '\"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;
SELECT * FROM sucursal;
TRUNCATE TABLE sucursal;

ALTER TABLE empleado 
RENAME COLUMN idEmpleado TO IdEmpleado;

ALTER TABLE cliente 
RENAME COLUMN X TO Longitud,
RENAME COLUMN Y TO Latitud;

ALTER TABLE cliente 
DROP COLUMN FechaUltimaModificacion,
DROP COLUMN UsuarioUltimaModificacion,
DROP COLUMN MarcaBaja,
DROP COLUMN UsuarioAlta;


DELETE FROM cliente 
WHERE IdCliente = Null and NombreApellido = Null;

ALTER TABLE compra 
RENAME COLUMN IDProducto TO IdProducto;

ALTER TABLE gasto 
RENAME COLUMN IDTipoGasto TO IdTipoGasto;

ALTER TABLE proveedor
RENAME COLUMN Adress TO Domicilio,
RENAME COLUMN City TO Localidad,
RENAME COLUMN State TO Provincia,
DROP COLUMN  Country,
RENAME COLUMN Department TO Departamento;

ALTER TABLE venta
RENAME COLUMN idVenta to IdVenta,
RENAME COLUMN Fecha_Entrega to FechaEntrega;

UPDATE cliente
SET Domicilio = UC_Words(TRIM(Domicilio)),
	Localidad = UC_Words(TRIM(Localidad)),
	NombreApellido = UC_Words(TRIM(NombreApellido));
    
UPDATE Proveedor
SET Domicilio = UC_Words(TRIM(Domicilio)),
	Localidad = UC_Words(TRIM(Localidad)),
	Provincia = UC_Words(TRIM(Provincia)),
    Departamento = UC_Words(TRIM(Departamento));
    
UPDATE Producto
SET Concepto = UC_Words(TRIM(Concepto)),
	Tipo = UC_Words(TRIM(Tipo));

ALTER TABLE empleado
DROP COLUMN NombreApellido;

#ALTER TABLE empleado ADD COLUMN NombreApellido VARCHAR(50) GENERATED ALWAYS AS (concat(nombre," ",apellido)) STORED,
#DROP COLUMN Apellido,
#DROP COLUMN Nombre;

CREATE TABLE IF NOT EXISTS cargo (
	IdCargo	INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Cargo	VARCHAR(40) NOT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO cargo (Cargo) 
SELECT DISTINCT Cargo 
FROM empleado 
ORDER BY Cargo;

CREATE TABLE IF NOT EXISTS sector (
	IdSector	INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Sector	VARCHAR(40) NOT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO sector (sector) 
SELECT DISTINCT Sector
FROM empleado 
ORDER BY Sector;

CREATE TABLE IF NOT EXISTS tipoDeProducto (
	IdTipoDeProducto	INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	TipoDeProducto	VARCHAR(40) NOT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO tipoDeProducto (tipodeproducto) 
SELECT DISTINCT Tipo
FROM producto
ORDER BY Tipo;
