USE [polcar_db]
GO

-- Testowanie procedury GetTaskStatisticsByManager
PRINT 'Rozpoczêcie testów procedury GetTaskStatisticsByManager';

DECLARE @ManagerId INT = 1;        -- Mened¿er z podw³adnymi
DECLARE @NoSubordinateManagerId INT = 9999; -- Mened¿er bez podw³adnych

-- Test 1: Pobranie statystyk zadañ dla mened¿era z podw³adnymi
PRINT 'Test 1: Pobranie statystyk zadañ dla mened¿era z podw³adnymi';
EXEC GetTaskStatisticsByManager @ManagerId = @ManagerId;

-- Test 2: Pobranie statystyk zadañ dla mened¿era bez podw³adnych
PRINT 'Test 2: Pobranie statystyk zadañ dla mened¿era bez podw³adnych';
EXEC GetTaskStatisticsByManager @ManagerId = @NoSubordinateManagerId;

PRINT 'Testy zakoñczone.';