USE [polcar_db]
GO

-- Procedura do udost�pniania zada� u�ytkownikom
CREATE PROCEDURE ShareTask
	@TaskId INT,
	@SharedWithUserId INT	
AS
BEGIN 
	BEGIN TRY
		-- Walidacja danych wej�ciowych
		IF @TaskId IS NULL OR @SharedWithUserId IS NULL
		BEGIN
			THROW 50002, 'Wszystkie parametry (TaskId, SharedWithUserId) musz� by� wype�nione.', 1;
		END;

		-- Sprawdzenie, czy takie zadanie istnieje
		IF EXISTS (SELECT 1 FROM Tasks WHERE TaskId = @TaskId)
		BEGIN
			-- Sprawdzenie, czy zadanie ju� zosta�o udost�pnione temu u�ytkownikowi
			IF EXISTS (SELECT 1 FROM TaskShares WHERE TaskId = @TaskId AND SharedWithUserId = @SharedWithUserId)
			BEGIN
				THROW 50003, 'To zadanie zosta�o ju� udost�pnione temu u�ytkownikowi.', 1;
			END;

			-- Udost�pnienie zadania
			INSERT INTO TaskShares (TaskId, SharedWithUserId)
			VALUES (@TaskId, @SharedWithUserId);
		END
		ELSE
		BEGIN
			THROW 50001, 'Nie masz prawa udost�pni� tego zadania.', 1;
		END;
	END TRY
	BEGIN CATCH    		
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
		VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE());				
		THROW;
	END CATCH;
END;