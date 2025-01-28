USE [polcar_db]
GO

-- Tabela przechowuj�ca dane o podmiotach - tenants
CREATE TABLE Tenants (
    TenantId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETDATE()
);