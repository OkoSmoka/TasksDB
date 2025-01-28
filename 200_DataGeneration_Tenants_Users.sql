USE [polcar_db]
GO

-- Skrypt generuj¹cy dane testowe dla tabel Tenants i Users
DECLARE @TenantIndex INT = 1;
WHILE @TenantIndex <= 10
BEGIN
    -- Dodawanie podmiotu
    INSERT INTO Tenants (Name) VALUES (CONCAT('Tenant_', @TenantIndex));
    DECLARE @TenantId INT = SCOPE_IDENTITY();

    -- Dodawanie mened¿erów
    DECLARE @UserIndex INT = 1;
    WHILE @UserIndex <= 50
    BEGIN
        INSERT INTO Users (TenantId, Username, Role, ManagerId) 
        VALUES (@TenantId, CONCAT('Manager_', @UserIndex, '_Tenant_', @TenantIndex), 'Manager', NULL);
        SET @UserIndex = @UserIndex + 1;
    END;

    -- Dodawanie pracowników i przypisywanie im mened¿erów
    DECLARE @ManagerStartIndex INT = 1;
    WHILE @UserIndex <= 100
    BEGIN
        DECLARE @ManagerId INT = @ManagerStartIndex + ((@UserIndex - 51) % 50);
        INSERT INTO Users (TenantId, Username, Role, ManagerId) 
        VALUES (@TenantId, CONCAT('Employee_', @UserIndex, '_Tenant_', @TenantIndex), 'Employee', @ManagerId);
        SET @UserIndex = @UserIndex + 1;
    END;  

    SET @TenantIndex = @TenantIndex + 1;
END;

