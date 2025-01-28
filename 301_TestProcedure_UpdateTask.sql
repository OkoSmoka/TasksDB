-- Test procedury UpdateTask

-- Utworzenie tabeli tymczasowej na wyniki test�w
CREATE TABLE #TestResults (
    TestCase NVARCHAR(255),
    Result NVARCHAR(50),
    ErrorMessage NVARCHAR(MAX)
);

 --Test 1: Aktualizacja zadania przez w�a�ciciela z prawid�owymi danymi
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

 --Test 2: Aktualizacja zadania przez u�ytkownika, kt�ry nie jest w�a�cicielem
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

 --Test 3: Pr�ba aktualizacji zadania, kt�re nie istnieje
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

 --Test 4: Pr�ba aktualizacji zadania z pustym nag��wkiem przez w�a�ciciela
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

 --Test 5: Aktualizacja zadania z nieprawid�owym statusem przez w�a�ciciela
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