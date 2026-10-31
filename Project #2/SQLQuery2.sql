CREATE DATABASE TechWorldHRDB;
GO

USE TechWorldHRDB;
GO

CREATE TABLE Department(
DepID INT IDENTITY(1,1) PRIMARY KEY,
DepName VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Employee(
EmpID INT IDENTITY(1,1) PRIMARY KEY,
FullName VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE,
Salary DECIMAL(10, 2),
DepID INT
);
GO

CREATE TABLE AccessCard(
CardID INT IDENTITY(1,1) PRIMARY KEY,
CardNumber VARCHAR(50) NOT NULL UNIQUE,
EmployeeID INT UNIQUE NOT NULL,
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmpID)
);
GO

CREATE TABLE Project(
ProjectID INT IDENTITY(1,1) PRIMARY KEY,
ProjectName VARCHAR(100) NOT NULL
);
GO

CREATE TABLE EmployeeProjects(
EmployeeID INT NOT NULL,
ProjectID INT NOT NULL,
AssignedDate DATE NOT NULL DEFAULT GETDATE(),
PRIMARY KEY (EmployeeID, ProjectID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmpID),
FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);
GO

INSERT INTO Department
VALUES ('IT'),('HR'),('Finance')
GO

ALTER TABLE Employee
ADD PhoneNumber VARCHAR(50);
GO

INSERT INTO Employee
VALUES ('Ahmad Ali', 'ahmad@techworld.com', 1200, 1, '0791111111'),
('Sara Hassan', 'sara@techworld.com', 950, 2, '0792222222'),
('Zaid Omar', 'zaid@techworld.com', 1500, 1, '0793333333'),
('Mona Khaled', 'mona@techworld.com', 800, 3, '0794444444');
GO

INSERT INTO AccessCard
VALUES ('Card 101', 1), ('Card 102', 2), ('Card 103', 3);
GO

INSERT INTO Project
VALUES ('AI & Security Training'), ('Cloud Migration');
GO

INSERT INTO EmployeeProjects (EmployeeID, ProjectID)
VALUES (1, 1), (1, 2), (2, 1), (3, 2);
GO

SELECT * FROM Department;
SELECT * FROM Employee;
SELECT * FROM EmployeeProjects;
SELECT * FROM AccessCard;
SELECT * FROM Project;
GO

INSERT INTO Employee
VALUES ('Wadea Belal', 'wadeayawanseh@gmail.com', 2500, NULL, '0785314566');
GO

SELECT e.FullName, e.Salary, d.DepName
From Employee e
INNER JOIN Department d ON e.DepID = d.DepID;
GO

SELECT d.*, e.FullName
FROM Employee e
LEFT JOIN Department d ON e.DepID = d.DepID;
GO

SELECT e.FullName, c.CardNumber
FROM Employee e
INNER JOIN AccessCard c ON c.EmployeeID = e.EmpID;
GO

SELECT e.FullName, p.ProjectName, ep.AssignedDate
FROM Employee e
INNER JOIN EmployeeProjects ep ON e.EmpID = ep.EmployeeID
INNER JOIN Project p ON p.ProjectID = ep.ProjectID;
GO

SELECT d.DepID, SUM(e.Salary) AS TotalSalary, COUNT(e.EmpID) AS EmployeeCount
FROM Department d
INNER JOIN Employee e ON e.DepID = d.DepID
GROUP BY d.DepID
GO

SELECT d.DepID, AVG(e.Salary) AS AvgSalary
FROM Department d
INNER JOIN Employee e ON e.DepID = d.DepID
GROUP BY d.DepID
HAVING AVG(e.Salary) > 1000;
GO

SELECT e.*
FROM Employee e
WHERE Salary > (SELECT AVG(Salary) FROM Employee);
GO

CREATE VIEW vw_EmployeeDetails AS
SELECT e.EmpID, e.FullName, d.DepName
FROM Employee e
INNER JOIN Department d ON d.DepID = e.DepID;
GO

SELECT * FROM vw_EmployeeDetails;
GO

CREATE PROCEDURE sp_GetEmployeesByDepartment (@DeptID INT)
AS
BEGIN
SELECT * FROM Employee WHERE DepID = @DeptID
END;

EXEC sp_GetEmployeesByDepartment 1;

DROP TABLE EmployeeAudit;
GO

CREATE TABLE EmployeeAudit(
AuditID INT IDENTITY(1,1) PRIMARY KEY,
EmployeeID INT,
ActionAudit VARCHAR(50),
ActionDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER Log_EmployeesDeletion
ON Employee
AFTER DELETE 
AS
BEGIN
INSERT INTO EmployeeAudit (EmployeeID, ActionAudit)
SELECT EmpID, 'Deleted Employee'
FROM deleted;
END;
GO

DELETE FROM Employee WHERE EmpID = 4;
SELECT * FROM EmployeeAudit;
GO