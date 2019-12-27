-------------------
# Sistema de ventas ZYBER primeros cambios
SQL
    ALTER TABLE mante_almacen ADD COLUMN ColorFondo VARCHAR(16);
    ALTER TABLE mante_almacen ADD COLUMN ColorTexto VARCHAR(16);
--> Procedure == mante_save_almacen

    DELIMITER $$

    USE `zayber`$$

    DROP PROCEDURE IF EXISTS `mante_save_almacen`$$

    CREATE DEFINER=`root`@`localhost` PROCEDURE `mante_save_almacen`(`pId` INT(11), `pAlm` VARCHAR(150), `pSimbolo` VARCHAR(25), `pDescrip` VARCHAR(150), `pRuc` VARCHAR(50), `pRS` VARCHAR(200), `pDireccion` VARCHAR(150), `pColorFondo` VARCHAR(16), `pColorTexto` VARCHAR(16),   `pEstado` INT(1))
    BEGIN
        DECLARE cont INT(11);
        IF(pId>0)THEN
            UPDATE `mante_almacen` SET Almacen=pAlm,Simbolo=pSimbolo,Descripcion=pDescrip,Ruc=pRuc,RazonSocial=pRS,
                Direccion=pDireccion, `ColorFondo`=pColorFondo, `ColorTexto`=pColorTexto, `Estado`=pEstado
            WHERE IdAlmacen=pId;
        ELSE
            SELECT IFNULL(COUNT(*),0) INTO cont FROM `mante_almacen` WHERE Almacen=pAlm;
            IF(cont=0)THEN
                SELECT IFNULL(MAX(IdAlmacen+1),1) INTO pId FROM mante_almacen;
                INSERT INTO mante_almacen VALUES(pId,pAlm,pSimbolo,pEstado,pDescrip,pRuc,pRS,pDireccion,pColorFondo,pColorTexto);
            END IF;
        END IF;
        END$$

    DELIMITER ;

--> ALTER TABLE
    ALTER TABLE `mante_registro_nota_pedido` CHANGE `IdVenta` `IdVenta` INT(11) NOT NULL AUTO_INCREMENT;

Update
    -homeModel.php
    -homeController.php
    -panel_Html.js
    -ManteAlmacen.js
    -Mante.php
    -Procesos.php
    -RegistroVenta.js

-> Mejorar Sistema de ventas
    - Nota de pedido => Agregar nombre cliente.
                     => Manejo de stock
    - Venta rapida importar nota de pedido.
        -> ya no se permite modificar la cantidad **check*
        -> quitar el manejo del stock **ckeck**

        // if ($aIdProducto!='-1') {//en caso de que sea un producto que existe, ya que -1 indica producto no existente
        // 	$query1234="UPDATE `mante_producto_almacen` SET Stock=Stock-'".$aCantidad."'
        // 					WHERE IdAlmacen='".$aIdAlm."' AND IdProducto='".$aIdProducto."';";
        // 	$sql3 = $pdo->prepare($query1234);
        // 	if($sql3->execute()){
        // 		$queryGast="SELECT fn_save_kardex_Venta('".$IdUser."','".$pOrigen."','".$pDestino."','".$aIdAlm."',
        // 					'".$aIdProducto."','".addslashes($aDescripcion)."','".$aCantidad."','".$aPU."',
        // 					'".$aImporte."','".$IdTipoEnt."','".$aComprob."') as con;";
        // 		//echo $queryGast;
        // 		$sql4 = $pdo->prepare($queryGast);				
        // 		if($sql4->execute()){
        // 			$fila4=$sql4->fetchAll();
        // 			$valor=$fila4[0]["con"];
        // 			if($valor==1){$valido=true;}else{$valido=false;}
        // 		}
        // 	}else{$valido=false;}
        // }