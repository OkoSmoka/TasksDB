USE [polcar_db]
GO

-- Tabela przechowuj¹ca historiê zmian zadañ
CREATE TABLE TaskHistory (
    HistoryId INT PRIMARY KEY IDENTITY(1,1),
    TaskId INT NOT NULL,
	TenantId INT NOT NULL,
    ChangedAt DATETIME2 DEFAULT GETDATE(),
    ChangedBy INT NOT NULL,
    OldHeader NVARCHAR(255),
    OldPriority NVARCHAR(50),
    OldDescription NVARCHAR(MAX),
    OldStatus NVARCHAR(50),
    FOREIGN KEY (TaskId) REFERENCES Tasks(TaskId),
    FOREIGN KEY (ChangedBy) REFERENCES Users(UserId)
);