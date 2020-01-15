Comercial l& e eirl
factura@comerciallieeirl.com
factura2020

inversones zayber
factura@inversioneszayber.com
factura2020

kalu
factura@kalu.com
factura2020


Corporacion zayber
factura@corporacionzayber.com
factura2020



--------------------------------- DATOS --------------------------
20601821801

* E&L
comercial av andres P.M.(Principal) 001
mazuco comercial                    002
colorado                            003

* inversiones ziber
andrez avelino caseres(principal)  001
colorado                           002

* corporacion zyber
jirorn tacna P.M (principal)        001
Mazuco                              002
Colorado                            003


edwin garcia guerra                 almacen         -> cambiar a almacen
karyna lendes                       venta y caja    -> cambiar a ventas1





SELECT * FROM `mante_producto_almacen` WHERE `IdProducto` = 127;

SELECT * FROM `mante_producto` WHERE `Producto` = 'FRUGOS DURAZNO';

SELECT * FROM `mante_kardex` WHERE `IdProducto` = 127;


DELETE FROM mante_producto_almacen WHERE `IdProducto` = 127 AND `estado` = 0 AND `Stock` = 0




SELECT IdProducto, Producto, COUNT(*) FROM mante_producto GROUP BY Producto HAVING COUNT(*) > 1