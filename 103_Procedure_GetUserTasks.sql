USE [polcar_db]
GO

-- Procedura pobieraj¹ca zadania u¿ytkownika
CREATE PROCEDURE GetUserTasks
    @UserId INT,
    @Status NVARCHAR(50) = NULL
AS
BEGIN
    BEGIN TRY
        SELECT TaskId, TenantId, Header, Priority, Description, Status, CreatedAt, UpdatedAt
        FROM Tasks
        WHERE UserId = @UserId
        AND (@Status IS NULL OR Status = @Status);
    END TRY
    BEGIN CATCH
        INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
        VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE());
		THROW;
    END CATCH;
END;