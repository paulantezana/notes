https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/FrameCriterioBusquedaWeb.jsp


# Ruma
# Leyes
la valoración de los minerales se basa en varios factores, y uno de ellos es la ley del mineral. La ley se refiere a la concentración o contenido de un elemento o compuesto específico en una muestra de mineral. Es una medida de la calidad del depósito de mineral y determina su valor económico.
# Romaneo
Se refiere al proceso de clasificación y separación de los minerales o rocas extraídos en una mina.
# Ensaye
Se refiere a las pruebas y análisis realizados en muestras de minerales para determinar su composición química, características físicas y propiedades metalúrgicas
# Blend
Se refiere a la mezcla o combinación de diferentes tipos de minerales o materiales para obtener una composición específica que cumpla con los requisitos de procesamiento o comercialización

-- Liquidacion
EXEC [dbo].[up_Liquidacion_Documento]  '0000038404'
EXEC [dbo].[up_Liquidacion_Sel] '0000038404', '0000000002'


exec [dbo].[up_ValorizadorPenalizable_Sellst] '0000038404', '0000000002'



[dbo].[up_LiquidacionDscto_Sel]
[dbo].[up_LiquidacionDscto_Sellst]     
[dbo].[up_LiquidacionServicio_Sel]
[dbo].[up_LiquidacionServicio_Sellst]    
[dbo].[up_LiquidacionTm_Sel]
[dbo].[up_LiquidacionTm_Sellst]
[dbo].[up_LiquidacionTm_Sellst_lista]
[dbo].[upLiquidacionAdjunto_Sel] -- ANALIZAR
[dbo].[upLiquidacionEstadoDetalle_Val_Generacion]  
[dbo].[ups_tbLiquidacionTm_LEYES]


[dbo].[up_ValorizadorPenalizable_Sellst]

[dbo].[up_ValorizadorPagable_Sellst]  


-- ANALIZAR
[dbo].[up_LiquidacionGenerar]








```sql
declare @contrato_lote_id varchar(32) = '0000038404'
declare @liquidacion_id varchar(32) = '0000000001'

exec [dbo].[up_Liquidacion_Documento] @contrato_lote_id
exec [dbo].[up_ValorizadorPagable_Sellst] @contrato_lote_id, @liquidacion_id
exec [dbo].[up_ValorizadorPenalizable_Sellst] @contrato_lote_id, @liquidacion_id
```


# TAREAS
Revisar los reportes, segun los siguientes pasos:

1. Emitir reporte
2. Si no sale: Corregir, Si sale dato Verificar que se correcto
3. Indicar status del reporte

Reportes:

- Reporte balance de saldos                             ✅
- Plan de cuentas                                       ⚠️ Muy lento
- Reporte balance de comprobacion                       ✅
- Reporte balance de comprobacion 12 meses              ⚠️ SOLO PIVOT
- Analisis de cuenta                                    ✅
- Comprobantes contables                                ✅
- Reporte estados financieros                           ✅
- Reporte situacion financiera (CTB105)                 ✅
- Reporte situacion financiera analitico (CTB106)       ✅
- Reporte situacion financiera x meses (CTB110)         ✅
- Libros electronicos
- Reporte de estado de resultados                       ✅
- Reporte de estado de resultados x dimension           ✅
- Reporte de estado de resultados mensual               ✅
- Reporte de estado de resultados mensual analitico     ✅
- Reporte de diario resumen                             ✅
- Flujo de efectivo                                     ⚠️ falta migrar el modelo
