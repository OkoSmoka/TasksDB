USE[polcar_db]
GO

--Tabela przechowywuj¹ca logi z operacji zakoñczonych b³êdami
CREATE TABLE ErrorLogs (
    ErrorLogId INT IDENTITY(1,1) PRIMARY KEY, 
    ErrorMessage NVARCHAR(MAX) NOT NULL,      
    ErrorProcedure NVARCHAR(128) NULL,       
    ErrorLine INT NULL,                      
    ErrorDate DATETIME DEFAULT GETDATE()     
);