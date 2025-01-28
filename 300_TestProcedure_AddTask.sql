USE[polcar_db]
GO

-- Test procedury AddTask

-- Utworzenie tymczasowej tabeli na potrzeby wyników testów
CREATE TABLE #TestResults (
    TestCase NVARCHAR(255),
    Result NVARCHAR(50),
    ErrorMessage NVARCHAR(MAX)
);

-- Test 1: Dodanie zadania z prawid³owymi danymi
BEGIN TRY
    EXEC AddTask
        @TenantId = 1,
        @UserId = 1,
        @Header = 'Test Task 1',
        @Priority = 'High',
        @Description = 'Description for Test Task 1',
        @Status = 'Pending';
    INSERT INTO #TestResults VALUES ('Test 1: Valid Data', 'Passed', NULL);
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 1: Valid Data', 'Failed', ERROR_MESSAGE());
END CATCH;

-- Test 2: Próba dodania zadania z nieistniej¹cym TenantId
BEGIN TRY
    EXEC AddTask
        @TenantId = 9999,
        @UserId = 1,
        @Header = 'Test Task 2',
        @Priority = 'Medium',
        @Description = 'Description for Test Task 2',
        @Status = 'InProgress';
    INSERT INTO #TestResults VALUES ('Test 2: Invalid TenantId', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 2: Invalid TenantId', 'Passed', ERROR_MESSAGE());
END CATCH;

-- Test 3: Próba dodania zadania z nieistniej¹cym UserId
BEGIN TRY
    EXEC AddTask
        @TenantId = 1,
        @UserId = 9999, 
        @Header = 'Test Task 3',
        @Priority = 'Low',
        @Description = 'Description for Test Task 3',
        @Status = 'Completed';
    INSERT INTO #TestResults VALUES ('Test 3: Invalid UserId', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 3: Invalid UserId', 'Passed', ERROR_MESSAGE());
END CATCH;

-- Test 4: Próba dodania zadania z pustym nag³ówkiem
BEGIN TRY
    EXEC AddTask
        @TenantId = 1,
        @UserId = 1,
        @Header = NULL, 
        @Priority = 'Low',
        @Description = 'Description for Test Task 4',
        @Status = 'Completed';
    INSERT INTO #TestResults VALUES ('Test 4: Null Header', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 4: Null Header', 'Passed', ERROR_MESSAGE());
END CATCH;

-- Test 5: Próba dodania zadania z nieprawid³owym statusem
BEGIN TRY
    EXEC AddTask
        @TenantId = 1,
        @UserId = 1,
        @Header = 'Test Task 5',
        @Priority = 'Low',
        @Description = 'Description for Test Task 5',
        @Status = 'InvalidStatus'; 
    INSERT INTO #TestResults VALUES ('Test 5: Invalid Status', 'Failed', 'Should have failed but passed.');
END TRY
BEGIN CATCH
    INSERT INTO #TestResults VALUES ('Test 5: Invalid Status', 'Passed', ERROR_MESSAGE());
END CATCH;

SELECT * FROM #TestResults;
DROP TABLE #TestResults;