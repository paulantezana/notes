CREATE TABLE Alumno(
    ID_Alu INT NOT NULL IDENTITY PRIMARY KEY,
    Nom_alu VARCHAR(128) DEFAULT '', 
    Ap_alu VARCHAR(128) DEFAULT '', 
    Am_alu VARCHAR(128) DEFAULT '', 
    Sex_alu VARCHAR(12) DEFAULT '', 
    Fnac_alu DATETIME DEFAULT NULL, 
    Ciu_alu VARCHAR(128) DEFAULT '', 
    Fot_alu VARCHAR(128) DEFAULT ''
);

GO
CREATE TABLE Matricula(
ID_Alu
ID_Sec
Fec_mat
Repite
);

GO
CREATE TABLE Nota(
ID_Alu
ID_Sec
ID_Cur
Nota
);

GO
CREATE TABLE Curso(
ID_Cur INT NOT NULL IDENTITY PRIMARY KEY,
Nom_cur
ID_Prof
);

GO
CREATE TABLE Seccion(
ID_Sec INT NOT NULL IDENTITY PRIMARY KEY,
Grado
Tutor
);

GO
CREATE TABLE Profesor(
ID_Prof INT NOT NULL IDENTITY PRIMARY KEY,
Nom_pro
Ape_pro
Dir_pro
Tel_pro
FN_pro
Grad_pro
FC_pro
Foto
);















CREATE TABLE Distrito(
IdDistrito INT NOT NULL IDENTITY PRIMARY KEY,
Distrito
Provincia
Departamento
);

GO
CREATE TABLE Cliente(
IdCliente INT NOT NULL IDENTITY PRIMARY KEY,
Apellido
Nombres
NroRUC
Direccion
IdDistrito
Telefono
Foto
E_mail
);

GO
CREATE TABLE Empleado(
IdEmpleado INT NOT NULL IDENTITY PRIMARY KEY,
Nombre
Apellido
Direccion
Ciudad
Estado_civil
Fecha_nac
Cargo
Fecha_Contrato
Telefono
Foto
);

GO
CREATE TABLE Periodo(
NroPed
Fecha_pedido
Fecha_entrega
Id_Cliente
IdEmpleado
);

GO
CREATE TABLE DetallePedido(
NroPedido
IdProducto
Cantidad
Descuento
);

GO
CREATE TABLE Proveedor(
IdProveedor INT NOT NULL IDENTITY PRIMARY KEY,
NombreCompania
NombreContacto
Cargo
Direccion
Ciudad
Telefono
Pais
Foto
);

GO
CREATE TABLE Categoria(
IdCategoria INT NOT NULL IDENTITY PRIMARY KEY,
Nombre
Desc_cate
);

GO
CREATE TABLE Producto(
IdProducto INT NOT NULL IDENTITY PRIMARY KEY,
NomProducto
PrecioUnit
Stock
Foto
IdCategoria
IdProveedor
);