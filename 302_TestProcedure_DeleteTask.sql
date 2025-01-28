USE [polcar_db]
GO

-- Testowanie procedury DeleteTask
DECLARE @Task_Id INT = 2; 
DECLARE @User_Id INT = 1; 

-- Test 1: Próba usuniêcia zadania przez w³aœciciela
EXEC DeleteTask @TaskId = @Task_Id, @UserId = @User_Id;

-- Sprawdzenie, czy zadanie zosta³o usuniête
IF EXISTS (SELECT 1 FROM Tasks WHERE TaskId = @Task_Id)
BEGIN
    PRINT 'Zadanie nie zosta³o poprawnie usuniête.';
END
ELSE
BEGIN
    PRINT 'Zadanie zosta³o poprawnie usuniête.';
END;

-- Test 2: Próba usuniêcia zadania przez nieuprawnionego u¿ytkownika
DECLARE @UnauthorizedUserId INT = 2; -- U¿ytkownik, który nie jest w³aœcicielem
EXEC DeleteTask @TaskId = @Task_Id, @UserId = @UnauthorizedUserId;