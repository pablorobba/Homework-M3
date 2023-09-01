use henry;
-- Alumno/s que ingresaron primero
SELECT nombre, apellido, fechaIngreso
FROM alumno
WHERE fechaIngreso = (SELECT MIN(fechaIngreso)
						FROM alumno);
                        
-- Obtener un listado de las cohortes que no tienen alumnos asignados
SELECT *
FROM cohorte
WHERE idCohorte NOT IN (SELECT DISTINCT idCohorte FROM alumno);


CREATE VIEW alumnos_ingresaron_primero AS
SELECT nombre, apellido, fechaIngreso
FROM alumno
WHERE fechaIngreso = (SELECT MIN(fechaIngreso)
						FROM alumno);
                        
ALTER VIEW cohortes_sin_alumnos AS
SELECT *
FROM cohorte
WHERE idCohorte NOT IN (SELECT DISTINCT idCohorte FROM alumno)
ORDER BY 1 DESC;


use checkpoint_m2;

SELECT v.Fecha,
		v.Precio * v.Cantidad as Venta,
        v2.promedio_venta
        -- v.Precio * v.Cantidad / v2.promedio_venta AS proporcion
FROM venta v JOIN (SELECT Fecha, AVG(Precio * Cantidad) AS promedio_venta
					FROM venta
					GROUP BY Fecha) v2
			ON (v.Fecha = v2.Fecha)
ORDER BY v.Fecha;

-- Funciones ventana
SELECT v.Fecha,
		v.Precio * v.Cantidad as Venta,
        AVG(Precio * Cantidad) OVER (PARTITION BY v.Fecha) AS promedio_venta
FROM venta v;

SELECT v.Fecha,
		v.Precio * v.Cantidad as Venta,
        AVG(Precio * Cantidad) OVER (PARTITION BY v.Fecha ROWS BETWEEN UNBOUNDED PRECEDING
										AND CURRENT ROW) AS acumulado
FROM venta v;

SELECT DENSE_RANK() OVER (PARTITION BY v.Fecha ORDER BY v.Precio * v.Cantidad DESC) AS ranking_venta,
	v.Fecha,
    v.IdCliente,
    v.Precio,
    v.Cantidad,
	v.Precio * v.Cantidad as Venta
FROM venta v;


                        
