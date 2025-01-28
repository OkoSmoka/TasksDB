USE [polcar_db]
GO

-- Skrypt generuj�cy dane testowe dla tabel Tasks i TaskShares
DECLARE @UserId INT;
DECLARE @TenantId INT;

-- Kursor do iteracji po tabeli Users
DECLARE UserCursor CURSOR FOR
SELECT UserId, TenantId
FROM Users;

OPEN UserCursor;

FETCH NEXT FROM UserCursor INTO @UserId, @TenantId;

-- P�tla iteruj�ca po rekordach
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @TaskIndex INT = 1;

	BEGIN TRY
		-- Generowanie po 1000 zada� dla ka�dego u�ytkownika
		WHILE @TaskIndex <= 1000
		BEGIN
			-- Dodawanie zadania do tabeli Tasks
			INSERT INTO Tasks (TenantId, UserId, Header, Priority, Description, Status)
			VALUES (
				@TenantId,
				@UserId,
				CONCAT('Task_', @TaskIndex, '_User_', @UserId),                
				CASE (ABS(CHECKSUM(NEWID())) % 3 + 1)
					WHEN 1 THEN 'Low'
					WHEN 2 THEN 'Medium'
					ELSE 'High'
				END,
				CONCAT('Description for task ', @TaskIndex),
				CASE (ABS(CHECKSUM(NEWID())) % 3 + 1)
					WHEN 1 THEN 'Pending'
					WHEN 2 THEN 'InProgress'
					ELSE 'Completed'
				END
			);

			-- Pobranie ID nowo dodanego zadania
			DECLARE @TaskId INT = SCOPE_IDENTITY();

			-- Udost�pnianie zadania losowym u�ytkownikom z tego samego TenantId
			DECLARE @ShareCount INT = FLOOR(RAND() * 10) + 1; --losowa liczba udost�pnie� tego samego zadania(od 1 do 10)
			DECLARE @ShareIndex INT = 1;

			WHILE @ShareIndex <= @ShareCount
			BEGIN
				-- Wybieranie losowego u�ytkownika z tego samego TenantId, kt�ry nie jest w�a�cicielem zadania
				DECLARE @SharedWithUserId INT;
				SELECT TOP 1 @SharedWithUserId = UserId
				FROM Users
				WHERE TenantId = @TenantId AND UserId != @UserId
				ORDER BY NEWID();
                
				IF @SharedWithUserId IS NOT NULL
				BEGIN
					INSERT INTO TaskShares (TaskId, SharedWithUserId)
					VALUES (@TaskId, @SharedWithUserId);
				END;

				SET @ShareIndex = @ShareIndex + 1;
			END;

			SET @TaskIndex = @TaskIndex + 1;
		END;    
	END TRY
	BEGIN CATCH
		INSERT INTO ErrorLogs (ErrorMessage, ErrorProcedure, ErrorLine)
					VALUES (
						ERROR_MESSAGE(),
						'DataGeneration_Tasks_TaskShares',
						ERROR_LINE()
					);
	END CATCH;

	FETCH NEXT FROM UserCursor INTO @UserId, @TenantId;
END;

CLOSE UserCursor;
DEALLOCATE UserCursor;