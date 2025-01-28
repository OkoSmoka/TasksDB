USE [polcar_db]
GO

-- Testowanie procedury GetUserTasks
DECLARE @TestUserId INT = 1;

-- Test 1: Pobranie wszystkich zada� u�ytkownika
EXEC GetUserTasks @UserId = @TestUserId;

-- Test 2: Pobranie zada� u�ytkownika o statusie "Pending"
EXEC GetUserTasks @UserId = @TestUserId, @Status = 'Pending';

-- Test 2: Pobranie zada� u�ytkownika o statusie "InProgress"
EXEC GetUserTasks @UserId = @TestUserId, @Status = 'InProgress';

-- Test 3: Pobranie zada� u�ytkownika o statusie "Completed"
EXEC GetUserTasks @UserId = @TestUserId, @Status = 'Completed';

-- Test 4: Pr�ba pobrania zada� dla u�ytkownika bez przypisanych zada�
EXEC GetUserTasks @UserId = 9999; 