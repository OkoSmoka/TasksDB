USE[polcar_db]
GO

--Tabela przechowywująca logi z operacji zakończonych błędami
CREATE TABLE ErrorLogs (
    ErrorLogId INT IDENTITY(1,1) PRIMARY KEY, 
    ErrorMessage NVARCHAR(MAX) NOT NULL,      
    ErrorProcedure NVARCHAR(128) NULL,       
    ErrorLine INT NULL,                      
    ErrorDate DATETIME DEFAULT GETDATE()     
);