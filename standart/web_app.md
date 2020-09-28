# Estandares
**TENER ESPECIAL CUIDADO EN LOS DETALLES**

## Vista
* En los botones siempre indicar un title o tooltip (No se recomienda los tooltip en caso de tablas)
* Por usavilidad evitar modales sobre otro (Maximo 2).
* Siempre responsive
* Validar tipo de dato (Firefox no valida automaticamente)

## Base de datos
* En la base de datos siempre debe haver los siguientes campos.
```sql
    delete_at DATETIME,         -- Registrar la fecha de eliminacion (Se recomienda no usar en tablas que no permiten duplicados en ese caso use el estado == false deshavilitar).
    updated_at DATETIME,        -- registrar fecha cuando se actualise el registro.
    created_at DATETIME,        -- registrar la ultima fecha de modificacion.
    created_user_id INT,        -- registrar el id del usuario que creo el registro.
    updated_user_id INT,        -- registrar el id del ultimo usuario que modifico.
    state TINYINT DEFAULT 1,    -- NORMALMENTE estado == false como deshavillitado.
```
## Logica de negocios
En php siempre loguear los errores en un error log




	$("input.only_numbers").keyup(function () {
		(string = $(this).val()),
		$(this).val(
		string
			.replace(/[^\d\.]/g, "")
			.replace(/^\.*/, "")
			.replace(/(\.\d*)(.*)/, "$1")
			.replace(/,/, "")
		);
	});


-- BORRAR
*  Mejorar los loadding