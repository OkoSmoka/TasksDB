USE [polcar_db]
GO

-- Testowanie procedury ShareTask
DECLARE @TaskId INT = 3;
DECLARE @SharedWithUserId INT = 2;   -- Użytkownik, któremu zadanie będzie udostępnione

-- Test 1: Udostępnienie zadania
EXEC ShareTask @TaskId = @TaskId, @SharedWithUserId = @SharedWithUserId;

-- Sprawdzenie, czy zadanie zostało udostępnione
IF EXISTS (SELECT 1 FROM TaskShares WHERE TaskId = @TaskId AND SharedWithUserId = @SharedWithUserId)
BEGIN
    PRINT 'Zadanie zostało poprawnie udostępnione.';
END
ELSE
BEGIN
    PRINT 'Zadanie nie zostało poprawnie udostępnione.';
END;