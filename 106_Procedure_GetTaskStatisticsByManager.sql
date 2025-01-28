USE [polcar_db]
GO

-- Procedura do pobierania statystyk dla wskazanego managera
CREATE PROCEDURE GetTaskStatisticsByManager
	@ManagerId INT,
	@StartDate DATE = NULL,
	@EndDate DATE = NULL
AS
BEGIN
	BEGIN TRY
		-- Sprawdzanie poprawnoœci zakresu dat
		IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @StartDate > @EndDate
		BEGIN
			THROW 50000, 'StartDate nie mo¿e byæ póŸniejszy ni¿ EndDate.', 1;
			RETURN;
		END

		-- Tymczasowa tabela na wyniki
		CREATE TABLE #TaskStats (
			SubordinateId INT,
			SubordinateName NVARCHAR(255),
			TaskMonth NVARCHAR(7), -- Format YYYY-MM
			Status NVARCHAR(50),
			TaskCount INT
		);

		-- Pobieranie podw³adnych mened¿era
		INSERT INTO #TaskStats (SubordinateId, SubordinateName, TaskMonth, Status, TaskCount)
		SELECT 
			U.UserId AS SubordinateId,
			U.Username AS SubordinateName,
			FORMAT(T.CreatedAt, 'yyyy-MM') AS TaskMonth,
			T.Status,
			COUNT(*) AS TaskCount
		FROM Users U
		INNER JOIN Tasks T ON U.UserId = T.UserId
		WHERE U.ManagerId = @ManagerId
		AND T.CreatedAt BETWEEN ISNULL(@StartDate, '1900-01-01') AND ISNULL(@EndDate, '9999-12-31')
		GROUP BY U.UserId, U.Username, FORMAT(T.CreatedAt, 'yyyy-MM'), T.Status;

		-- Zwracanie wyników
		SELECT * FROM #TaskStats
		ORDER BY SubordinateName, TaskMonth, Status;

		-- Usuwanie tymczasowej tabeli
		DROP TABLE #TaskStats;
	END TRY
	BEGIN CATCH    
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
		VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE()); 
		THROW;
	END CATCH;
END;