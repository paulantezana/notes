<?php
    require_once 'XLSXReader.php';
    if(isset($_FILES['archivo'])){

        $pdo = new PDO('mysql:host=localhost;dbname=db_zayber','root','');
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->beginTransaction();

        try{
            // Leer archivo excel
            $path = $_FILES['archivo']['tmp_name'];
            $xlsx = new XLSXReader($path);
            $hojas = $xlsx->getSheetNames();
            $hojaDatos = $xlsx->getSheetData($hojas[1]);
    
            // 0 = codigo
            // 1 = descripcion
            // 2 = pCompra
            // 3 = pPublico
            // 4 = pDistribuidor
            // 5 = pBase
            // 6 = pMarca
            // 7 = pModelo
            // 8 = pCantidad
    
    
            
            $valido = false;
            $mensage ='';
    
            $idAlmacen = 2;
            $almacen = 'T.P. KALU';
            $controlStock = false;
            
            $aResponsable='Inportacion';
            $aTotal=0;
        
            $IdVenta=1;
            $IdTipoEnt=2;
            $pOrigen='Compra Simple I';
            $pDestino=$almacen;
            
            $aFechaE = date("Y-m-d", (strtotime ("-5 Hours")));
            $FechaHr = date("Y-m-d H:i:s", (strtotime ("-5 Hours")));
        
            $cantidadCount = 0;
    
            // Calculando totales y control de stock
            for ($i=1; $i < count($hojaDatos); $i++) {
                $fila = $hojaDatos[$i];
    
                $cantidad = isset($fila[8]) ? trim($fila[8]): 0;
                if($cantidad > 0){
                    $cantidadCount++;
                }
    
                $aTotal += (float)$fila[2] * (float)$cantidad;
            }
            if($cantidadCount == 0){
                $controlStock = false;
            }
    
            if($controlStock){
                $sql="SELECT IFNULL(MAX(IdCompraS+1),1) AS Com FROM mante_compra_simple";
                $stm = $pdo->prepare($sql);
                if($stm->execute()){
                    $data = $stm->fetch();
                    $IdVenta = $data["Com"];
                    $sql="INSERT INTO mante_compra_simple VALUES(".$idAlmacen.",".$IdVenta.",'".$FechaHr."',".$IdUser.",
                                '".addslashes($aResponsable)."',1,'".$aTotal."','');";
    
                    $stm = $pdo->prepare($sql);
                    if(!$stm->execute()){
                        throw new Exception('Error al realizar la compra simple');	
                    }
                }
            }

            for ($i=1; $i < count($hojaDatos); $i++) {
                $fila = $hojaDatos[$i];
                // if(empty($fila["codigo"]) ){
                //     throw new Exception('El producto debe contener un codigo');
                // }
                // if(!isset($fila["compra"])){
                //     throw new Exception('El campo compra es requerido');
                // }
                // if(!isset($fila["mayor"])){
                //     throw new Exception('El campo mayor es requerido');
                // }
                // if(!isset($fila["menor"])){
                //     throw new Exception('El campo menor es requerido');
                // }
                // if(!isset($fila["publico"])){
                //     throw new Exception('El campo publico es requerido');
                // }
                // if(!isset($fila["IdMarca"])){
                //     throw new Exception('El campo marca es requerido');
                // }
                // if(!isset($fila["IdModelo"])){
                //     throw new Exception('El campo modelo es requerido');
                // }
                // if ($controlStock) {
                //     if(!isset($fila["cantidad"])){
                //         throw new Exception('El campo cantidad es requerido');
                //     }
                // }
                // $Codigo=$fila["codigo"];
    
                $codigo = $fila[0];
                $descripcion = $fila[1];
                $pCompra = $fila[2];
                $pPublico = $fila[3];
                $pDistribuidor = $fila[4];
                $pBase = $fila[5];
                $pMarca = $fila[6];
                $pModelo = $fila[7];
                $cantidad = $fila[8];
    
                $pMayor = $pDistribuidor;
                $pMenor = $pBase;
                $textMarca = '';
                $textModelo = '';
                $idMarca = '1';
                $idModelo = '1';
    
    
                $sql="SELECT fn_Save_Productos_importP('".addslashes($codigo)."','".addslashes($descripcion)."',
                '".$idMarca."','".$idModelo."','".trim($pCompra)."','".trim($pMayor)."','".trim($pMenor)."','".trim($pPublico)."',".$idAlmacen.") as id";
    
                $stm = $pdo->prepare($sql);
                if(!$stm->execute()){
                    throw new Exception('No se pudo guardar el producto');
                }
                $aIdProducto = $stm->fetch()['id'];
                if($aIdProducto <= 0){
                    throw new Exception('No se encontro el producto');
                }
    
                if($controlStock && $cantidad > 0){
                    $aDescripcion = $descripcion . ' ' . $textMarca . ' ' . $textModelo;
                    $unidad = '1';
                    $importe = $pCompra * $cantidad;
                    
                    $aTC='1'; // tipo cambio
                                    
                    $sql="SELECT IFNULL(MAX(IdDetalle+1),1) AS IdDeatil FROM mante_compra_simple_detalle WHERE IdCompraS=".$IdVenta."";
                    $stm = $pdo->prepare($sql);
                    if(!$stm->execute()){
                        throw new Exception('Error en la consulta idDetalle');
                    }
                    $fila2=$stm->fetch();
    
                    
                    $IdDetalles=$fila2["IdDeatil"];
                    $sql="INSERT INTO mante_compra_simple_detalle VALUES('".$idAlmacen."',".$IdVenta.",".$IdDetalles.",'".$aIdProducto."',
                            '".$cantidad."','".addslashes($codigo)."','".addslashes($aDescripcion)."','".$unidad."','".$importe."',
                            '".trim($pPublico)."','".trim($pMenor)."','".trim($pMayor)."','".($pCompra)."','".$aTC."');";
                    //echo $querDe;
                    $stm = $pdo->prepare($sql);
                    if(!$stm->execute()){
                        throw new Exception('No se pudo insertar el detalle de la compra simple');
                    }
    
    
                    $sql="UPDATE `mante_producto_almacen` SET PrecioCompra='".trim($pCompra)."',PrecioPublico='".trim($pPublico)."',PrecioBase='".trim($pMenor)."',
                                        PrecioDistribuido='".trim($pMayor)."',Stock='".$cantidad."',TipoCambio='".$aTC."'
                                        WHERE IdAlmacen='".$idAlmacen."' AND IdProducto='".$aIdProducto."';";
                    $stm = $pdo->prepare($sql);
                    if(!$stm->execute()){
                        throw new Exception('No se pudo actualizar el stock en el almacen');
                    }
    
    
                    $sql="SELECT fn_save_kardex_Compra('".$IdUser."','".$pOrigen."','".$pDestino."','".$idAlmacen."',
                                '".$aIdProducto."','".addslashes($aDescripcion)."','".$cantidad."','".trim($Compra)."',
                                '".$importe."','".$IdTipoEnt."','Compra Simple I','".$FechaHr."') as con;";
                    //echo $queryGast;
                    $stm = $pdo->prepare($sql);
                    if(!$stm->execute()){
                        throw new Exception('Error al actualizar el kardex');
                    }
    
                    $data=$stm->fetch();
                    if(!($data["con"]==1)){
                        throw new Exception('No se pudeo actualizar el kardex');
                    }
                }
            }

            $valido = true;
			$mensage ='Proceso correcto';
			$pdo->commit();
		} catch (Exception $e) {
			$valido = false;
			$mensage = 'Excepción capturada: ' . $e->getMessage();
			$pdo->rollBack();
		}

        $return = ['valido' => $valido, 'mensage' => $mensage];
        var_dump($return);

    }

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <form action="" method="post" enctype="multipart/form-data">
        <input type="file" name="archivo" id="archivo">
        <input type="submit" value="enviar">
    </form>
</body>
</html>