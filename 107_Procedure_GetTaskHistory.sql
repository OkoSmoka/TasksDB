USE [polcar_db]
GO

-- Procedura pobieraj¹ca historie zmian poczynionych przez wskazanego u¿ytkownika
CREATE PROCEDURE GetTaskHistory
	@RequestingUserId INT,    
	@TaskId INT = NULL,       
	@ChangedBy INT = NULL,    
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
		END;

		-- Pobieranie TenantId i roli u¿ytkownika wykonuj¹cego zapytanie
		DECLARE @RequestingTenantId INT;
		DECLARE @RequestingRole NVARCHAR(50);

		SELECT @RequestingTenantId = TenantId, @RequestingRole = Role
		FROM Users
		WHERE UserId = @RequestingUserId;

		IF @RequestingTenantId IS NULL OR @RequestingRole IS NULL
		BEGIN
			THROW 50001, 'Nie znaleziono danych u¿ytkownika.', 1;
			RETURN;
		END;

		-- Pobieranie historii zadañ
		SELECT 
			H.HistoryId,
			H.TaskId,
			T.Header AS CurrentHeader,
			H.ChangedAt,
			H.ChangedBy,
			U.Username AS ChangedByName,
			H.OldHeader,
			H.OldPriority,
			H.OldDescription,
			H.OldStatus
		FROM TaskHistory H
		INNER JOIN Tasks T ON H.TaskId = T.TaskId
		INNER JOIN Users U ON H.ChangedBy = U.UserId
		WHERE T.TenantId = @RequestingTenantId -- U¿ytkownik mo¿e widzieæ tylko dane w swoim TenantId
			AND (
				-- U¿ytkownik widzi swoje zadania
				T.UserId = @RequestingUserId 
				-- Menad¿er widzi zadania podw³adnych
				OR (@RequestingRole = 'Manager' AND T.UserId IN (
					SELECT UserId FROM Users WHERE ManagerId = @RequestingUserId
					))
				)
			AND (@TaskId IS NULL OR H.TaskId = @TaskId) 
			AND (@ChangedBy IS NULL OR H.ChangedBy = @ChangedBy) 
			AND (@StartDate IS NULL OR H.ChangedAt >= @StartDate) 
			AND (@EndDate IS NULL OR H.ChangedAt <= @EndDate) 
		ORDER BY H.ChangedAt DESC; 
	END TRY
	BEGIN CATCH    
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
		VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE()); 
		THROW;
	END CATCH;
END;