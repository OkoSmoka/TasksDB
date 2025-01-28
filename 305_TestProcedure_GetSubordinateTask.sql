USE [polcar_db]
GO

-- Testowanie procedury GetSubordinateTasks

-- Test 1: Pobranie zadañ podw³adnych mened¿era
DECLARE @ManagerId INT = 1;
EXEC GetSubordinateTasks @ManagerId = @ManagerId;

-- Test 2: Pobranie zadañ, gdy mened¿er nie ma podw³adnych
DECLARE @NoSubordinateManagerId INT = 99999;
EXEC GetSubordinateTasks @ManagerId = @NoSubordinateManagerId;