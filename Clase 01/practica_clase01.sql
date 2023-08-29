use henry;
#Variable de usuario
SET @anio = 2020;

SELECT *
FROM alumno
WHERE year(fechaIngreso) = @anio;

SELECT @test := idAlumno FROM alumno WHERE idAlumno = 3;
SELECT @test;

SELECT @promedio := avg(idAlumno) FROM alumno;
SELECT @promedio;

show variables;

#Para poder crear funciones
SET GLOBAL log_bin_trust_function_creators = 1;

#Funciones
DROP FUNCTION antMeses;
DELIMITER $$
CREATE FUNCTION antMeses(fechaIngresoAlumno DATE) RETURNS INT
BEGIN
	DECLARE meses INT;
    SET meses = timestampdiff(month, fechaIngresoAlumno, curdate());
    RETURN meses;
END$$
DELIMITER ; 


SELECT antMeses('2018-05-06');

#Procedimientos almacenados
DELIMITER $$
CREATE PROCEDURE getTotalAlumnos()
BEGIN
	DECLARE total_alumnos INT DEFAULT 0;
    SELECT count(*)
    INTO total_alumnos
    FROM alumno;
    SELECT total_alumnos;
END$$
DELIMITER ; 

CALL getTotalAlumnos();

use test;
DELIMITER $$
CREATE PROCEDURE suma_incremento (IN num1 INT, IN num2 INT, OUT resultado INT, INOUT num1_mas_10 INT)
BEGIN
		SET resultado = num1 + num2;
        SET num1_mas_10 = resultado + 10;
END$$
DELIMITER ;
CALL suma_incremento(8, 7, @result, @suma_plus);

SELECT @result;
SELECT @suma_plus;




