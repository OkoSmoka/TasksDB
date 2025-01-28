USE [polcar_db]
GO

-- Procedura dodaj¹ca nowe zadanie
CREATE PROCEDURE AddTask
	@TenantId INT,
	@UserId INT,
	@Header NVARCHAR(255),
	@Priority NVARCHAR(50),
	@Description NVARCHAR(MAX),
	@Status NVARCHAR(50)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Tasks (TenantId, UserId, Header, Priority, Description, Status)
		VALUES (@TenantId, @UserId, @Header, @Priority, @Description, @Status);
	END TRY
	BEGIN CATCH    
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
		VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE());     
	END CATCH;
END;
