DROP TABLE -- EXEC [Financiero].[usp_cargarDataPleSire] 31, '08040002', '202408';
DROP TABLE EXEC [Financiero].[usp_cargarDataPleSire] 27, '08040002', '202408';
SELECT * FROM Financiero.SunatElectronicoTxtCargado
SELECT * FROM Financiero.SunatElectronicoTxtGenerado WHERE Codigo = '08050000'

EXEC produccion.enproyecdb.dbo.SP_GENERA_VENTAS '0001', '2024', '08'; 

-- Borrar Tablas
DROP TABLE --[Financiero].[SIRE_14040002];
DROP TABLE --[Financiero].[SIRE_14040002_rectifica_reporte];
DROP TABLE --[Financiero].[SIRE_14040002_txt_declarado];
DROP TABLE --[Financiero].[SIRE_14040002_txt_propuesta];

DROP TABLE --[Financiero].[SIRE_08050000];

DROP TABLE --[Financiero].[SIRE_08040002];
DROP TABLE --[Financiero].[SIRE_08040002_rectifica_reporte];
DROP TABLE --[Financiero].[SIRE_08040002_txt_declarado];
DROP TABLE --[Financiero].[SIRE_08040002_txt_propuesta];


DROP TABLE [Financiero].[PLE_010100];
DROP TABLE [Financiero].[PLE_010100_rectifica];
DROP TABLE [Financiero].[PLE_010100_txt_declarado];

DROP TABLE [Financiero].[PLE_010200];
DROP TABLE [Financiero].[PLE_010200_rectifica];
DROP TABLE [Financiero].[PLE_010200_txt_declarado];


DROP TABLE [Financiero].[PLE_030100];


DROP TABLE [Financiero].[PLE_030200];
DROP TABLE [Financiero].[PLE_030200_rectifica];
DROP TABLE [Financiero].[PLE_030200_txt_declarado];



DROP TABLE [Financiero].[PLE_030300];
DROP TABLE [Financiero].[PLE_030300_rectifica];
DROP TABLE [Financiero].[PLE_030300_txt_declarado];


DROP TABLE [Financiero].[PLE_030400];
DROP TABLE [Financiero].[PLE_030400_rectifica];
DROP TABLE [Financiero].[PLE_030400_txt_declarado];

DROP TABLE [Financiero].[PLE_030500];
DROP TABLE [Financiero].[PLE_030500_rectifica];
DROP TABLE [Financiero].[PLE_030500_txt_declarado];

DROP TABLE [Financiero].[PLE_030600];
DROP TABLE [Financiero].[PLE_030600_rectifica];
DROP TABLE [Financiero].[PLE_030600_txt_declarado];


DROP TABLE [Financiero].[PLE_030900];
DROP TABLE [Financiero].[PLE_031100];
DROP TABLE [Financiero].[PLE_031200];
DROP TABLE [Financiero].[PLE_031300];
DROP TABLE [Financiero].[PLE_031400];
DROP TABLE [Financiero].[PLE_031500];
DROP TABLE [Financiero].[PLE_031601];
DROP TABLE [Financiero].[PLE_031602];
DROP TABLE [Financiero].[PLE_031700];
DROP TABLE [Financiero].[PLE_032000];