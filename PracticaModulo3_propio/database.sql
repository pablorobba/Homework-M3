USE PracticaModulo3_Propio;
DROP DATABASE PracticaModulo3_Propio;
CREATE DATABASE PracticaModulo3_Propio;
SET GLOBAL local_infile=1;

CREATE TABLE Venta(
idVenta INT PRIMARY KEY,
Fecha DATE,
Fecha_Entrega DATE,
IdCanal INT,
IdCliente INT,
IdSucursal INT,
IdEmpleado INT,
IdProducto INT,
Precio DECIMAL(15,3)
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/Venta.csv"
INTO TABLE Venta
CHARACTER SET utf8
FIELDS TERMINATED BY ","
IGNORE 1 LINES;

CREATE TABLE Empleado(
idEmpleado INT PRIMARY KEY,
Apellido VARCHAR(50),
Nombre VARCHAR(50),
Sucursal VARCHAR(50),
Sector VARCHAR(50),
Cargo VARCHAR(50),
Salario DECIMAL(15,2)
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/Empleados.csv"
INTO TABLE Empleado
CHARACTER SET utf8
FIELDS TERMINATED BY ";"
IGNORE 1 LINES;

CREATE TABLE Proveedor(
IdProvedor INT PRIMARY KEY,
Nombre VARCHAR(50),
Adress VARCHAR(50),
City VARCHAR(50),
State VARCHAR(50),
Country VARCHAR(50),
Department VARCHAR(50)
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/Proveedores.csv"
INTO TABLE Proveedor
CHARACTER SET utf8
FIELDS TERMINATED BY ";"
IGNORE 1 LINES;

CREATE TABLE Cliente(
IdCliente INT PRIMARY KEY,
Provincia VARCHAR(50),
NombreApellido VARCHAR(50),
Domicilio VARCHAR(50),
Telefono VARCHAR(50),
Edad INT,
Localidad VARCHAR(50),
X VARCHAR(50),
Y VARCHAR(50),
FechaAlta DATE,
UsuarioAlta VARCHAR(30),
FechaUltimaModificacion DATE,
UsuarioUltimaModificacion VARCHAR(30),
MarcaBaja INT
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/Clientes.csv"
INTO TABLE Cliente
CHARACTER SET utf8
FIELDS TERMINATED BY ";"
IGNORE 1 LINES;

DROP TABLE Producto;

CREATE TABLE Producto(
IdProducto INT PRIMARY KEY,
Concepto VARCHAR(50),
Tipo VARCHAR(50),
Precio DECIMAL(15,2)
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/PRODUCTOS.csv"
INTO TABLE Producto
CHARACTER SET utf8
FIELDS TERMINATED BY ";";
DELETE FROM Producto WHERE idproducto = 0;

CREATE TABLE CanalVenta(
IdCanalVenta INT PRIMARY KEY,
Descripcion VARCHAR(50)
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/CanalDeVenta.csv"
INTO TABLE CanalVenta
CHARACTER SET utf8
FIELDS TERMINATED BY ";";
DELETE FROM CanalVenta WHERE idCanalVenta  = 0;

CREATE TABLE Sucursal(
IdSucursal INT PRIMARY KEY,
Direccion VARCHAR(50),
Localidad VARCHAR(50),
Provincia VARCHAR(50),
Latitud VARCHAR(50),
Longitud VARCHAR(50)
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/Sucursales.csv"
INTO TABLE Sucursal
CHARACTER SET utf8
FIELDS TERMINATED BY ";"
IGNORE 1 LINES;

CREATE TABLE Compra(
IdCompra INT PRIMARY KEY,
Fecha DATE,
IDProducto INT,
Cantidad INT,
Precio DECIMAL(15,2),
IdProveedor INT
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/Compra.csv"
INTO TABLE Compra
CHARACTER SET utf8
FIELDS TERMINATED BY ","
IGNORE 1 LINES;

CREATE TABLE TipoDeGasto(
IdTipoGasto INT PRIMARY KEY,
Descripcion VARCHAR(50),
MontoAproximado INT
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/TiposDeGasto.csv"
INTO TABLE TipoDeGasto
CHARACTER SET utf8
FIELDS TERMINATED BY ",";
DELETE FROM TipoDeGasto WHERE idTipoGasto = 0;

CREATE TABLE Gasto(
IdGasto INT PRIMARY KEY,
IdSucursal INT,
IDTipoGasto INT,
Fecha DATE,
Monto DECIMAL(15,2)
);

LOAD DATA LOCAL INFILE "C:/Users/Pablo/Documents/Programacion/4 Henry/Curso/Modulos/M3/PracticaModulo3_propio/Archivos/Gasto.csv"
INTO TABLE Gasto
CHARACTER SET utf8
FIELDS TERMINATED BY ","
IGNORE 1 LINES;