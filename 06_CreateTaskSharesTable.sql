USE [polcar_db]
GO

-- Tabela przechowuj�ca komu jakie zadania zosta�y udost�pnione
CREATE TABLE TaskShares (
    ShareId INT PRIMARY KEY IDENTITY(1,1),
    TaskId INT NOT NULL,
    SharedWithUserId INT NOT NULL,
    SharedAt DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),
    FOREIGN KEY (SharedWithUserId) REFERENCES Users(UserId)
);