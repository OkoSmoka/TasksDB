USE [polcar_db]
GO

-- Testowanie procedury ShareTask
DECLARE @TaskId INT = 3;
DECLARE @SharedWithUserId INT = 2;   -- U¿ytkownik, któremu zadanie bêdzie udostêpnione

-- Test 1: Udostêpnienie zadania
EXEC ShareTask @TaskId = @TaskId, @SharedWithUserId = @SharedWithUserId;

-- Sprawdzenie, czy zadanie zosta³o udostêpnione
IF EXISTS (SELECT 1 FROM TaskShares WHERE TaskId = @TaskId AND SharedWithUserId = @SharedWithUserId)
BEGIN
    PRINT 'Zadanie zosta³o poprawnie udostêpnione.';
END
ELSE
BEGIN
    PRINT 'Zadanie nie zosta³o poprawnie udostêpnione.';
END;