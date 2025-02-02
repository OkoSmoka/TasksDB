USE [polcar_db]
GO

-- Tabela przechowująca dane o podmiotach - tenants
CREATE TABLE Tenants (
    TenantId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETDATE()
);