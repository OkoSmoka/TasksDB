USE [polcar_db]
GO

-- Tabela przechowuj¹ca dane o zadaniach
CREATE TABLE Tasks (
    TaskId INT PRIMARY KEY IDENTITY(1,1),
    TenantId INT NOT NULL,
    UserId INT NOT NULL,
    Header NVARCHAR(255) NOT NULL,
    Priority NVARCHAR(50) CHECK (Priority IN ('Low', 'Medium', 'High')) NOT NULL,
    Description NVARCHAR(MAX),
    Status NVARCHAR(50) CHECK (Status IN ('Pending', 'InProgress', 'Completed')) NOT NULL DEFAULT 'Pending',
    CreatedAt DATETIME2 DEFAULT GETDATE(),
    UpdatedAt DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);