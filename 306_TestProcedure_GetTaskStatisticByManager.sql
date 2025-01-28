USE [polcar_db]
GO

-- Testowanie procedury GetTaskStatisticsByManager
PRINT 'Rozpocz�cie test�w procedury GetTaskStatisticsByManager';

DECLARE @ManagerId INT = 1;        -- Mened�er z podw�adnymi
DECLARE @NoSubordinateManagerId INT = 9999; -- Mened�er bez podw�adnych

-- Test 1: Pobranie statystyk zada� dla mened�era z podw�adnymi
PRINT 'Test 1: Pobranie statystyk zada� dla mened�era z podw�adnymi';
EXEC GetTaskStatisticsByManager @ManagerId = @ManagerId;

-- Test 2: Pobranie statystyk zada� dla mened�era bez podw�adnych
PRINT 'Test 2: Pobranie statystyk zada� dla mened�era bez podw�adnych';
EXEC GetTaskStatisticsByManager @ManagerId = @NoSubordinateManagerId;

PRINT 'Testy zako�czone.';