DECLARE @Periodo VARCHAR(8) = '202401';
DECLARE @IdCompania INT  = 27;

DROP TABLE IF EXISTS #SeDataSistema;

SELECT
  IdSunatElectronico = 48

  , IdCompania          = IIF(d.IdCompania IS NULL, c.IdCompania        , d.IdCompania)
  , CodigoAnioPeriodo   = IIF(d.IdCompania IS NULL, c.CodigoAnioPeriodo , d.CodigoAnioPeriodo)
  , Declarado           = IIF(d.IdCompania IS NULL, 'N',  'S')

  , Col1  = IIF(d.IdCompania IS NULL, c.Col1, '')
  , Col2  = IIF(d.IdCompania IS NULL, c.Col2, '')
  , Col3  = IIF(d.IdCompania IS NULL, c.Col3, LEFT(d.Col1,6))
  , Col4  = IIF(d.IdCompania IS NULL, c.Col4, '')
  , Col5  = IIF(d.IdCompania IS NULL, c.Col5, d.Col4)
  , Col6  = IIF(d.IdCompania IS NULL, c.Col6, d.Col5)
  , Col7  = IIF(d.IdCompania IS NULL, c.Col7, d.Col6)
  , Col8  = IIF(d.IdCompania IS NULL, c.Col8, d.Col7)
  , Col9  = IIF(d.IdCompania IS NULL, c.Col9, d.Col8)
  , Col10 = IIF(d.IdCompania IS NULL, c.Col10, d.Col9)
  , Col11 = IIF(d.IdCompania IS NULL, c.Col11, d.Col10)
  , Col12 = IIF(d.IdCompania IS NULL, c.Col12, d.Col11)
  , Col13 = IIF(d.IdCompania IS NULL, c.Col13, d.Col12)
  , Col14 = IIF(d.IdCompania IS NULL, c.Col14, d.Col13)
  , Col15 = IIF(d.IdCompania IS NULL, c.Col15, IIF(d.Col14 = '', '0.00',d.Col14))
  , Col16 = IIF(d.IdCompania IS NULL, c.Col16, IIF(d.Col15 = '', '0.00',d.Col15))
  , Col17 = IIF(d.IdCompania IS NULL, c.Col17, IIF(d.Col16 = '', '0.00',d.Col16))
  , Col18 = IIF(d.IdCompania IS NULL, c.Col18, IIF(d.Col17 = '', '0.00',d.Col17))
  , Col19 = IIF(d.IdCompania IS NULL, c.Col19, IIF(d.Col18 = '', '0.00',d.Col18))
  , Col20 = IIF(d.IdCompania IS NULL, c.Col20, IIF(d.Col19 = '', '0.00',d.Col19))
  , Col21 = IIF(d.IdCompania IS NULL, c.Col21, IIF(d.Col20 = '', '0.00',d.Col20))
  , Col22 = IIF(d.IdCompania IS NULL, c.Col22, IIF(d.Col21 = '', '0.00',d.Col21))
  , Col23 = IIF(d.IdCompania IS NULL, c.Col23, IIF(d.Col22 = '', '0.00',d.Col22))
  , Col24 = IIF(d.IdCompania IS NULL, c.Col24, IIF(d.Col23 = '', '0.00',d.Col23))
  , Col25 = IIF(d.IdCompania IS NULL, c.Col25, IIF(d.Col24 = '', '0.00',d.Col24))
  , Col26 = IIF(d.IdCompania IS NULL, c.Col26, d.Col25)
  , Col27 = IIF(d.IdCompania IS NULL, c.Col27, d.Col26)
  , Col28 = IIF(d.IdCompania IS NULL, c.Col28, d.Col27)
  , Col29 = IIF(d.IdCompania IS NULL, c.Col29, d.Col28)
  , Col30 = IIF(d.IdCompania IS NULL, c.Col30, d.Col29)
  , Col31 = IIF(d.IdCompania IS NULL, c.Col31, d.Col30)
  , Col32 = IIF(d.IdCompania IS NULL, c.Col32, d.Col31)
  , Col33 = IIF(d.IdCompania IS NULL, c.Col33, d.Col32)
  , Col34 = IIF(d.IdCompania IS NULL, c.Col34, d.Col33)

  , Col35 = ''
  , Col36 = ''
  , Col37 = ''
  , Col38 = ''
  , Col39 = ''
  , Col40 = ''
  , Col41 = ''

  INTO #SeDataSistema
FROM (SELECT * FROM Financiero.SunatElectronicoTxtGenerado WITH (NOLOCK) WHERE IdSunatElectronico = 48 AND IdCompania = @IdCompania ) AS c
FULL JOIN (SELECT * FROM Financiero.SunatElectronicoTxtDeclarado WITH (NOLOCK) WHERE IdSunatElectronico = 35 AND IdCompania = @IdCompania) AS d ON c.IdCompania = d.IdCompania
  AND c.CodigoAnioPeriodo = d.CodigoAnioPeriodo

  AND c.Col13 = d.Col12
  AND c.Col7  = d.Col6
  AND c.Col8  = d.Col7
  AND c.Col10 = d.Col9