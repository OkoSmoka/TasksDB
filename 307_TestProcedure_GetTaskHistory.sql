USE [polcar_db]
GO

-- Testowanie procedury GetTaskHistory
PRINT 'Rozpoczêcie testów procedury GetTaskHistory';

-- Test 1: Pobranie historii zmian zrobionych przez u¿ytkownika w wybranym zadaniu
DECLARE @RequestingUserId INT = 10; 
DECLARE @TaskId INT = 9999; 
PRINT 'Test 1: Pobranie historii zmian zrobionych przez u¿ytkownika w wybranym zadaniu';
EXEC GetTaskHistory 
    @RequestingUserId = @RequestingUserId, 
    @TaskId = @TaskId;

-- Test 2: Pobranie historii zmian w przedziale dat
DECLARE @StartDate DATE = '2025-01-01'; 
DECLARE @EndDate DATE = '2025-01-30';   
PRINT 'Test 2: Pobranie historii zmian w przedziale dat';
EXEC GetTaskHistory 
    @RequestingUserId = @RequestingUserId, 
    @StartDate = @StartDate, 
    @EndDate = @EndDate;

-- Test 3: Pobranie historii zmian w nieprawid³owym przedziale dat
DECLARE @StartErrorDate DATE = '2025-01-30'; 
DECLARE @EndErrorDate DATE = '2025-01-01';   
PRINT 'Test 3: Pobranie historii zmian w nieprawid³owym przedziale dat';
EXEC GetTaskHistory 
    @RequestingUserId = @RequestingUserId, 
    @StartDate = @StartErrorDate, 
    @EndDate = @EndErrorDate;

-- Test 4: Pobranie historii zmian dla zadania, które nie istnieje
DECLARE @NonExistingTaskId INT = 1; 
PRINT 'Test 4: Pobranie historii zmian dla zadania, które nie istnieje';
EXEC GetTaskHistory 
    @RequestingUserId = @RequestingUserId, 
    @TaskId = @NonExistingTaskId;

-- Test 5: Pobranie pe³nej historii zmian (bez dodatkowych filtrów)
PRINT 'Test 5: Pobranie pe³nej historii zmian (bez dodatkowych filtrów)';
EXEC GetTaskHistory 
    @RequestingUserId = @RequestingUserId;

PRINT 'Testy procedury GetTaskHistory zakoñczone.';