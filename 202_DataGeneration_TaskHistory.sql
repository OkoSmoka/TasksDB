USE [polcar_db]
GO

-- Skrypt generuj¹cy dane testowe dla tabeli TaskHistory
DECLARE @TaskId INT, @TenantId INT, @ChangedBy INT, @TaskIndex INT, @ChangeIndex INT, @MaxTasks INT, @MaxChanges INT;

SET @MaxTasks = 100000; -- Maksymalna liczba zadañ
SET @MaxChanges = 5;    -- Maksymalna liczba zmian na zadanie

SET @TaskIndex = 1; -- Pocz¹tkowy indeks zadania

WHILE @TaskIndex <= @MaxTasks
BEGIN
    SET @ChangeIndex = 1; -- Licznik zmian dla bie¿¹cego zadania

    -- Pobierz losowego autora zmiany (np. Mened¿era lub podw³adnego)
    SELECT TOP 1 @ChangedBy = UserId
    FROM Users
    ORDER BY NEWID();

    -- Generowanie zmian dla bie¿¹cego zadania
    WHILE @ChangeIndex <= @MaxChanges
    BEGIN
		BEGIN TRY
			-- Pobieranie zadania do modyfikacji
			SELECT TOP 1 
				@TaskId = TaskId,
				@TenantId = TenantId
			FROM Tasks
			ORDER BY NEWID();

			-- Dodawanie wpisu do historii z losowymi danymi
			INSERT INTO TaskHistory (TaskId, TenantId, ChangedAt, ChangedBy, OldHeader, OldPriority, OldDescription, OldStatus)
			VALUES (
				@TaskId,
				@TenantId,
				DATEADD(DAY, -(@ChangeIndex * 5), GETDATE()), 
				@ChangedBy,
				CONCAT('Old Header Task ', @TaskId, '_Change_', @ChangeIndex),
				CASE (ABS(CHECKSUM(NEWID())) % 3 + 1)
					WHEN 1 THEN 'Low'
					WHEN 2 THEN 'Medium'
					ELSE 'High'
				END,
				CONCAT('Old description for task ', @TaskId, ' - change ', @ChangeIndex), 
				CASE (ABS(CHECKSUM(NEWID())) % 3 + 1)
					WHEN 1 THEN 'Pending'
					WHEN 2 THEN 'InProgress'
					ELSE 'Completed'
				END  
			);
		END TRY
		BEGIN CATCH
			INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
						VALUES (
							ERROR_MESSAGE(),
							'DataGeneration_TaskHistory',
							ERROR_LINE()
						);
		END CATCH;

        SET @ChangeIndex = @ChangeIndex + 1;
    END;

    SET @TaskIndex = @TaskIndex + 1;
END;