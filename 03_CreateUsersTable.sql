USE [polcar_db]
GO

-- Tabela przechowująca dane o użytkownikach
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    TenantId INT NOT NULL,
	ManagerId INT NULL,	
    Username NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) CHECK (Role IN ('Employee', 'Manager')) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId),
	FOREIGN KEY (ManagerId) REFERENCES Users(UserId)
);