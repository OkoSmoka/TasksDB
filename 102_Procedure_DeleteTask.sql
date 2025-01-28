USE [polcar_db]
GO

-- Procedura usuwaj�ca zadanie
CREATE PROCEDURE DeleteTask
	@TaskId INT,
	@UserId INT
AS
BEGIN
	BEGIN TRY
		-- Sprawdzanie, czy istnieje u�ytkownik z takim zadaniem
		IF EXISTS (SELECT 1 FROM Tasks WHERE TaskId = @TaskId AND UserId = @UserId)
		BEGIN
			-- Usuwanie wpis�w z tabeli TaskHistory
			DELETE FROM TaskHistory	WHERE TaskId = @TaskId;

			-- Usuwanie wpis�w z tabeli TaskShares
			DELETE FROM TaskShares	WHERE TaskId = @TaskId;

			-- Usuwanie zadania
			DELETE FROM Tasks	WHERE TaskId = @TaskId;
		END
		ELSE
		BEGIN
			THROW 50001, 'Nie masz prawa usun�� tego zadania.', 1;
		END;
	END TRY
	BEGIN CATCH		
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
		VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE());
		THROW;
	END CATCH;
END;