DECLARE @StartPeriod INT = 202305
DECLARE @EndPeriod INT = 202409
DECLARE @CurrentPeriod INT = @StartPeriod

WHILE @CurrentPeriod <= @EndPeriod
BEGIN
    DECLARE @PeriodString CHAR(6) = CAST(@CurrentPeriod AS CHAR(6))
    
    EXEC [Financiero].[usp_cargarDataPleSire] 30, '08040002', @PeriodString
    
    -- Increment the period
    SET @CurrentPeriod = 
        CASE
            WHEN RIGHT(@CurrentPeriod, 2) = 12 THEN @CurrentPeriod + 89 -- Move to next year
            ELSE @CurrentPeriod + 1 -- Move to next month
        END
END






-- ==================================================================================================
-- ==================================================================================================
-- SIRE
-- ==================================================================================================
-- ==================================================================================================
DECLARE @StartPeriod INT = 202401
DECLARE @EndPeriod INT = 202412
DECLARE @CurrentPeriod INT = @StartPeriod

WHILE @CurrentPeriod <= @EndPeriod
BEGIN
    DECLARE @PeriodString CHAR(6) = CAST(@CurrentPeriod AS CHAR(6))

    EXEC Financiero.usp_ConsultaPropuestaSIRE 27, '080000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 29, '080000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 30, '080000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 31, '080000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 32, '080000', @PeriodString

    EXEC Financiero.usp_ConsultaPropuestaSIRE 27, '140000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 29, '140000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 30, '140000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 31, '140000', @PeriodString
    EXEC Financiero.usp_ConsultaPropuestaSIRE 32, '140000', @PeriodString
    
    -- Increment the period
    SET @CurrentPeriod = 
        CASE
            WHEN RIGHT(@CurrentPeriod, 2) = 12 THEN @CurrentPeriod + 89 -- Move to next year
            ELSE @CurrentPeriod + 1 -- Move to next month
        END
END
