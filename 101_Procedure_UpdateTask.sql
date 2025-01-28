USE [polcar_db]
GO

-- Procedura aktualizuj�ca zadanie i zapisuj�ca histori� zmian
CREATE PROCEDURE UpdateTask
	@TaskId INT,
	@UserId INT,
	@Header NVARCHAR(255),
	@Priority NVARCHAR(50),
	@Description NVARCHAR(MAX),
	@Status NVARCHAR(50)
AS
BEGIN
	BEGIN TRY
		-- Deklaracje zmiennych do przechowywania starych danych
		DECLARE @TenantId INT, 
		        @OldHeader NVARCHAR(255), 
		        @OldPriority NVARCHAR(50), 
		        @OldDescription NVARCHAR(MAX), 
		        @OldStatus NVARCHAR(50);

		-- Sprawdzanie, czy zadanie istnieje i nale�y do u�ytkownika
		IF NOT EXISTS (
			SELECT 1 
			FROM Tasks 
			WHERE TaskId = @TaskId AND UserId = @UserId
		)
		BEGIN
			THROW 50001, 'Nie masz uprawnie� do aktualizacji tego zadania lub zadanie nie istnieje.', 1;
		END;

		--Sprawdzanie, czy @Header = NULL
		IF @Header IS NULL			
		BEGIN
			THROW 50002, 'Warto�� Header nie mo�e by� r�wna NULL.', 1;
		END;

		--Sprawdzanie, czy @Status nie jest r�wny 'Pending', 'InProgress', 'Completed'
		IF @Status NOT IN ('Pending', 'InProgress', 'Completed')
		BEGIN
			THROW 50003, 'Nieprawid�owa warto�� dla zmiennej @Status. Oczekiwano Pending, InProgress lub Completed.', 1;
		END;

		-- Pobieranie starych danych zadania
		SELECT @TenantId = TenantId, 
		       @OldHeader = Header, 
		       @OldPriority = Priority, 
		       @OldDescription = Description, 
		       @OldStatus = Status
		FROM Tasks 
		WHERE TaskId = @TaskId;

		-- Sprawdzanie, czy s� zmiany w danych
		IF @Header = @OldHeader AND @Priority = @OldPriority AND @Description = @OldDescription AND @Status = @OldStatus
		BEGIN
			THROW 50004, 'Nie wykryto �adnych zmian do zapisania.', 1;
		END;

		-- Zapisywanie zmian do historii
		INSERT INTO TaskHistory (TaskId, TenantId, ChangedBy, OldHeader, OldPriority, OldDescription, OldStatus)
		VALUES (@TaskId, @TenantId, @UserId, @OldHeader, @OldPriority, @OldDescription, @OldStatus);

		-- Aktualizacja zadania
		UPDATE Tasks
		SET Header = @Header, 
		    Priority = @Priority, 
		    Description = @Description, 
		    Status = @Status, 
		    UpdatedAt = GETDATE()
		WHERE TaskId = @TaskId;
	END TRY
	BEGIN CATCH		
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
		VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE());		
		THROW;
	END CATCH;
END;

