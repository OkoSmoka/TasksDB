USE[polcar_db]
GO

--Tworzenie indeksów w celu pszyspieszenia wyszukiwania
CREATE INDEX IDX_Users_TenantId ON Users (TenantId);
CREATE INDEX IDX_Users_UserId ON Users (UserId);
CREATE INDEX IDX_Users_ManagerId ON Users (ManagerId);

CREATE INDEX IDX_Tasks_TenantId ON Tasks (TenantId);
CREATE INDEX IDX_Tasks_UserId ON Tasks (UserId);
CREATE INDEX IDX_Tasks_TaskId ON Tasks (TaskId);
CREATE INDEX IDX_Tasks_UserId_CreatedAt_Status ON Tasks (UserId, CreatedAt, Status);
CREATE INDEX IDX_Tasks_Status_CreatedAt ON Tasks (Status, CreatedAt DESC);

CREATE INDEX IDX_TaskShares_TaskId ON TaskShares (TaskId);
CREATE INDEX IDX_TaskShares_SharedWithUserId ON TaskShares (SharedWithUserId);

CREATE INDEX IDX_TaskHistory_TenantId ON TaskHistory (TenantId);
CREATE INDEX IDX_TaskHistory_TaskId ON TaskHistory (TaskId);
CREATE INDEX IDX_TaskHistory_ChangedAt ON TaskHistory (ChangedAt);
CREATE INDEX IDX_TaskHistory_ChangedBy ON TaskHistory (ChangedBy);