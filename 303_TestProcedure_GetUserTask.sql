USE [polcar_db]
GO

-- Testowanie procedury GetUserTasks
DECLARE @TestUserId INT = 1;

-- Test 1: Pobranie wszystkich zadañ u¿ytkownika
EXEC GetUserTasks @UserId = @TestUserId;

-- Test 2: Pobranie zadañ u¿ytkownika o statusie "Pending"
EXEC GetUserTasks @UserId = @TestUserId, @Status = 'Pending';

-- Test 2: Pobranie zadañ u¿ytkownika o statusie "InProgress"
EXEC GetUserTasks @UserId = @TestUserId, @Status = 'InProgress';

-- Test 3: Pobranie zadañ u¿ytkownika o statusie "Completed"
EXEC GetUserTasks @UserId = @TestUserId, @Status = 'Completed';

-- Test 4: Próba pobrania zadañ dla u¿ytkownika bez przypisanych zadañ
EXEC GetUserTasks @UserId = 9999; 