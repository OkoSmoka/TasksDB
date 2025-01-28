USE [polcar_db]
GO

-- Procedura do pobierania zadañ wskazanego managera
CREATE PROCEDURE GetSubordinateTasks
	@ManagerId INT
AS
BEGIN
	BEGIN TRY
		SELECT 
			T.TaskId,
			T.Header,
			T.Priority,
			T.Description,
			T.Status,
			T.CreatedAt,
			T.UpdatedAt,
			U.Username AS AssignedTo
		FROM Tasks T
		INNER JOIN Users U ON T.UserId = U.UserId
		WHERE U.ManagerId = @ManagerId
		ORDER BY T.CreatedAt DESC;
	END TRY
	BEGIN CATCH    
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
		VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE());
		THROW;
	END CATCH;
END;