USE[polcar_db]
GO

--Tabela przechowywuj�ca logi z operacji zako�czonych b��dami
CREATE TABLE ErrorLogs (
    ErrorLogId INT IDENTITY(1,1) PRIMARY KEY, 
    ErrorMessage NVARCHAR(MAX) NOT NULL,      
    ErrorProcedure NVARCHAR(128) NULL,       
    ErrorLine INT NULL,                      
    ErrorDate DATETIME DEFAULT GETDATE()     
);