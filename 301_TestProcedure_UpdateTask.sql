-- Test procedury UpdateTask

-- Utworzenie tabeli tymczasowej na wyniki testów
CREATE TABLE #TestResults (
    TestCase NVARCHAR(255),
    Result NVARCHAR(50),
    ErrorMessage NVARCHAR(MAX)
);

 --Test 1: Aktualizacja zadania przez w³aœciciela z prawid³owymi danymi
BEGIN TRY
    EXEC UpdateTask
        @TaskId = 1,
        @UserId = 1,
        @Header = 'Updated Task 1',
        @Priority = 'High',
        @Description = 'Updated description for Task 1',
        @Status = 'InProgress';
    INSERT INTO #TestResults VALUES ('Test 1: Valid Update by Owner', 'Passed', NULL);
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 1: Valid Update by Owner', 'Failed', ERROR_MESSAGE());
END CATCH;

 --Test 2: Aktualizacja zadania przez u¿ytkownika, który nie jest w³aœcicielem
BEGIN TRY
    EXEC UpdateTask
        @TaskId = 1,
        @UserId = 2, 
        @Header = 'Updated Task 1 by Non-Owner',
        @Priority = 'Medium',
        @Description = 'Non-owner attempting update',
        @Status = 'Completed';
    INSERT INTO #TestResults VALUES ('Test 2: Update by Non-Owner', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 2: Update by Non-Owner', 'Passed', ERROR_MESSAGE());
END CATCH;

 --Test 3: Próba aktualizacji zadania, które nie istnieje
BEGIN TRY
    EXEC UpdateTask
        @TaskId = 9999,
        @UserId = 1,
        @Header = 'Non-existent Task',
        @Priority = 'Medium',
        @Description = 'This task does not exist',
        @Status = 'Pending';
    INSERT INTO #TestResults VALUES ('Test 3: Non-existent TaskId', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 3: Non-existent TaskId', 'Passed', ERROR_MESSAGE());
END CATCH;

 --Test 4: Próba aktualizacji zadania z pustym nag³ówkiem przez w³aœciciela
BEGIN TRY
    EXEC UpdateTask
        @TaskId = 1,
        @UserId = 1, 
        @Header = NULL, 
        @Priority = 'Low',
        @Description = 'Valid description',
        @Status = 'Completed';
    INSERT INTO #TestResults VALUES ('Test 4: Null Header by Owner', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 4: Null Header by Owner', 'Passed', ERROR_MESSAGE());
END CATCH;

 --Test 5: Aktualizacja zadania z nieprawid³owym statusem przez w³aœciciela
BEGIN TRY
    EXEC UpdateTask
        @TaskId = 1,
        @UserId = 1,
        @Header = 'Task 5',
        @Priority = 'Medium',
        @Description = 'Valid description',
        @Status = 'InvalidStatus';
    INSERT INTO #TestResults VALUES ('Test 5: Invalid Status by Owner', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 5: Invalid Status by Owner', 'Passed', ERROR_MESSAGE());
END CATCH;

SELECT * FROM #TestResults;
DROP TABLE #TestResults;