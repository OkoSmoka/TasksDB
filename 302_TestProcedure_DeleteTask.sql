USE [polcar_db]
GO

-- Testowanie procedury DeleteTask
DECLARE @Task_Id INT = 2; 
DECLARE @User_Id INT = 1; 

-- Test 1: Pr�ba usuni�cia zadania przez w�a�ciciela
EXEC DeleteTask @TaskId = @Task_Id, @UserId = @User_Id;

-- Sprawdzenie, czy zadanie zosta�o usuni�te
IF EXISTS (SELECT 1 FROM Tasks WHERE TaskId = @Task_Id)
BEGIN
    PRINT 'Zadanie nie zosta�o poprawnie usuni�te.';
END
ELSE
BEGIN
    PRINT 'Zadanie zosta�o poprawnie usuni�te.';
END;

-- Test 2: Pr�ba usuni�cia zadania przez nieuprawnionego u�ytkownika
DECLARE @UnauthorizedUserId INT = 2; -- U�ytkownik, kt�ry nie jest w�a�cicielem
EXEC DeleteTask @TaskId = @Task_Id, @UserId = @UnauthorizedUserId;