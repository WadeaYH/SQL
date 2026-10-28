CREATE DATABASE TechWorldHRDB;
GO

USE TechWorldHRDB;
GO


CREATE TABLE TemporaryStaff(
StaffID INT IDENTITY(1,1) PRIMARY KEY,
StaffName VARCHAR(50),
HireDAte DATE
);
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

ALTER TABLE Employee
ADD PhoneNumber VARCHAR(20);
GO

DROP TABLE TemporaryStaff;

INSERT INTO Department
VALUES ('IT'),('HR'),('Finance')
GO

INSERT INTO Employee
VALUES ('Ahmad Ali', 'ahmad@techworld.com', 1200, 1, '0791111111'),
('Sara Hassan', 'sara@techworld.com', 950, 2, '0792222222'),
('Zaid Omar', 'zaid@techworld.com', 1500, 1, '0793333333'),
('Mona Khaled', 'mona@techworld.com', 800, 3, '0794444444');

UPDATE Employee SET Salary = 1350 WHERE EmpID = 1;

DELETE Employee WHERE EmpID = 4;

SELECT * FROM Employee;

SELECT FullName, Salary from Employee;

SELECT SUM(Salary) as TotalSalaries FROM Employee;

SELECT AVG(Salary) as AverageSalary FROM Employee;

SELECT MAX(Salary) as HighestSalary, MIN(Salary) LowestSalary FROM Employee;

SELECT COUNT(EmpID) as TotalEmployees FROM Employee;