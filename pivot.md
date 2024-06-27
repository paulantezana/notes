<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tabla Pivot Interactiva Mejorada</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f0f0f0;
        }
        .container {
            display: flex;
            gap: 20px;
        }
        .panel {
            background-color: #fff;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .config-panel {
            width: 300px;
        }
        .table-container {
            flex-grow: 1;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        select, button {
            margin: 5px 0;
            padding: 5px;
            width: 100%;
        }
        select[multiple] {
            height: 100px;
        }
        .toggle-btn {
            cursor: pointer;
            user-select: none;
            margin-right: 5px;
        }
        .hidden-row {
            display: none;
        }
        .group-row {
            font-weight: bold;
            background-color: #e9e9e9;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="panel config-panel">
            <h3>Configuración</h3>
            <select id="filas" multiple>
                <option value="">Seleccionar Filas</option>
            </select>
            <select id="columnas" multiple>
                <option value="">Seleccionar Columnas</option>
            </select>
            <select id="datos">
                <option value="">Seleccionar Datos</option>
            </select>
            <select id="operacion">
                <option value="sum">Suma</option>
                <option value="max">Máximo</option>
                <option value="min">Mínimo</option>
                <option value="avg">Promedio</option>
                <option value="count">Contar</option>
            </select>
            <button onclick="actualizarTabla()">Actualizar Tabla</button>
        </div>
        <div class="panel table-container">
            <table id="tablaPivot"></table>
        </div>
    </div>

    <script>
    // Datos de ejemplo
    const datos = [
        {categoria: 'Frutas', producto: 'Manzana', region: 'Norte', ventas: 100, cantidad: 50},
        {categoria: 'Frutas', producto: 'Banana', region: 'Sur', ventas: 80, cantidad: 40},
        {categoria: 'Verduras', producto: 'Zanahoria', region: 'Este', ventas: 60, cantidad: 30},
        {categoria: 'Verduras', producto: 'Lechuga', region: 'Oeste', ventas: 40, cantidad: 20},
        {categoria: 'Frutas', producto: 'Manzana', region: 'Sur', ventas: 120, cantidad: 60},
        {categoria: 'Verduras', producto: 'Zanahoria', region: 'Norte', ventas: 70, cantidad: 35},
    ];

    // Lógica de procesamiento
    const PivotLogic = {
        obtenerSeleccionados(selectId) {
            return Array.from(document.getElementById(selectId).selectedOptions).map(option => option.value);
        },

        generarCombinaciones(arrays) {
            return arrays.reduce((a, b) => a.flatMap(x => b.map(y => [...x, y])), [[]]);
        },

        calcularResultado(datosFiltrados, datosCampo, operacion) {
            switch (operacion) {
                case 'sum':
                    return datosFiltrados.reduce((sum, d) => sum + d[datosCampo], 0);
                case 'max':
                    return Math.max(...datosFiltrados.map(d => d[datosCampo]));
                case 'min':
                    return Math.min(...datosFiltrados.map(d => d[datosCampo]));
                case 'avg':
                    return datosFiltrados.reduce((sum, d) => sum + d[datosCampo], 0) / datosFiltrados.length;
                case 'count':
                    return datosFiltrados.length;
            }
        },

        procesarDatos(filas, columnas, datosCampo, operacion) {
            const combinacionesColumnas = this.generarCombinaciones(columnas.map(col => [...new Set(datos.map(d => d[col]))]));
            const combinacionesFilas = this.generarCombinaciones(filas.map(fila => [...new Set(datos.map(d => d[fila]))]));

            return combinacionesFilas.map(comboFila => {
                const resultadosColumnas = combinacionesColumnas.map(comboColumna => {
                    const datosFiltrados = datos.filter(d => 
                        filas.every((fila, i) => d[fila] === comboFila[i]) &&
                        columnas.every((col, i) => d[col] === comboColumna[i])
                    );
                    return datosFiltrados.length > 0 ? 
                        this.calcularResultado(datosFiltrados, datosCampo, operacion).toFixed(2) : 
                        '-';
                });
                return { fila: comboFila, resultados: resultadosColumnas };
            });
        }
    };

    // Lógica de presentación
    const PivotUI = {
        inicializarSelectores() {
            const campos = ['categoria', 'producto', 'region', 'ventas', 'cantidad'];
            campos.forEach(campo => {
                ['filas', 'columnas', 'datos'].forEach(selector => {
                    const select = document.getElementById(selector);
                    const option = document.createElement('option');
                    option.value = campo;
                    option.textContent = campo.charAt(0).toUpperCase() + campo.slice(1);
                    select.appendChild(option);
                });
            });
        },

        crearEncabezado(tabla, filas, columnas) {
            const thead = tabla.createTHead();
            const headerRow = thead.insertRow();
            filas.forEach(fila => {
                headerRow.insertCell().textContent = fila.charAt(0).toUpperCase() + fila.slice(1);
            });
            const combinacionesColumnas = PivotLogic.generarCombinaciones(columnas.map(col => [...new Set(datos.map(d => d[col]))]));
            combinacionesColumnas.forEach(combo => {
                headerRow.insertCell().textContent = combo.join(' - ');
            });
        },

        crearCuerpoTabla(tabla, datosProcessados, filas) {
            const tbody = tabla.createTBody();
            let grupoAnterior = {};
            datosProcessados.forEach((fila, index) => {
                const tr = tbody.insertRow();
                let esFilaGrupo = false;

                fila.fila.forEach((valor, i) => {
                    if (grupoAnterior[i] !== valor) {
                        // Esta es una nueva fila de grupo
                        esFilaGrupo = true;
                        for (let j = i; j < filas.length; j++) {
                            grupoAnterior[j] = j === i ? valor : null;
                        }
                    }

                    const cell = tr.insertCell();
                    if (i === 0 && esFilaGrupo) {
                        cell.innerHTML = `<span class="toggle-btn" data-group="${valor}">▼</span> ${valor}`;
                        cell.onclick = this.toggleGrupo;
                        tr.classList.add('group-row');
                    } else {
                        cell.textContent = valor;
                    }
                });

                if (!esFilaGrupo) {
                    tr.classList.add(`subgroup-${fila.fila[0]}`);
                }

                fila.resultados.forEach(resultado => {
                    tr.insertCell().textContent = resultado;
                });
            });
        },

        toggleGrupo(event) {
            const grupo = event.target.closest('td').textContent.trim().split(' ')[1];
            const filas = document.querySelectorAll(`.subgroup-${grupo}`);
            const toggleBtn = event.target.closest('td').querySelector('.toggle-btn');
            filas.forEach(fila => {
                fila.classList.toggle('hidden-row');
            });
            toggleBtn.textContent = toggleBtn.textContent === '▼' ? '▶' : '▼';
        },

        actualizarTabla() {
            const filas = PivotLogic.obtenerSeleccionados('filas');
            const columnas = PivotLogic.obtenerSeleccionados('columnas');
            const datosCampo = document.getElementById('datos').value;
            const operacion = document.getElementById('operacion').value;

            if (filas.length === 0 || columnas.length === 0 || !datosCampo) {
                alert('Por favor, selecciona al menos una fila, una columna y un campo de datos');
                return;
            }

            const tabla = document.getElementById('tablaPivot');
            tabla.innerHTML = '';

            this.crearEncabezado(tabla, filas, columnas);
            const datosProcessados = PivotLogic.procesarDatos(filas, columnas, datosCampo, operacion);
            this.crearCuerpoTabla(tabla, datosProcessados, filas);
        }
    };

    // Inicialización
    PivotUI.inicializarSelectores();

    // Función principal para actualizar la tabla
    function actualizarTabla() {
        PivotUI.actualizarTabla();
    }
    </script>
</body>
</html>