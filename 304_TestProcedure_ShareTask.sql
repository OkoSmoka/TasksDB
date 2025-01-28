USE [polcar_db]
GO

-- Testowanie procedury ShareTask
DECLARE @TaskId INT = 3;
DECLARE @SharedWithUserId INT = 2;   -- U�ytkownik, kt�remu zadanie b�dzie udost�pnione

-- Test 1: Udost�pnienie zadania
EXEC ShareTask @TaskId = @TaskId, @SharedWithUserId = @SharedWithUserId;

-- Sprawdzenie, czy zadanie zosta�o udost�pnione
IF EXISTS (SELECT 1 FROM TaskShares WHERE TaskId = @TaskId AND SharedWithUserId = @SharedWithUserId)
BEGIN
    PRINT 'Zadanie zosta�o poprawnie udost�pnione.';
END
ELSE
BEGIN
    PRINT 'Zadanie nie zosta�o poprawnie udost�pnione.';
END;