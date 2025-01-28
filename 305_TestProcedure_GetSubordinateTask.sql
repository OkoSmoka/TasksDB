USE [polcar_db]
GO

-- Testowanie procedury GetSubordinateTasks

-- Test 1: Pobranie zada� podw�adnych mened�era
DECLARE @ManagerId INT = 1;
EXEC GetSubordinateTasks @ManagerId = @ManagerId;

-- Test 2: Pobranie zada�, gdy mened�er nie ma podw�adnych
DECLARE @NoSubordinateManagerId INT = 99999;
EXEC GetSubordinateTasks @ManagerId = @NoSubordinateManagerId;