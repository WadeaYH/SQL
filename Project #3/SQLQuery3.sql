CREATE DATABASE CourseHubDB;
GO

USE CourseHubDB;
GO

--DROP TABLE IF EXISTS StudentCourses;
--DROP TABLE IF EXISTS StudentProfile;
--DROP TABLE IF EXISTS Course;
--DROP TABLE IF EXISTS Student;
--DROP TABLE IF EXISTS Department;
--GO

CREATE TABLE TempInstructors(
TempID INT IDENTITY(1,1) PRIMARY KEY,
TempName VARCHAR(50),
JoinedDate DATE
);
GO

CREATE TABLE Department(
DepID INT IDENTITY(1,1) PRIMARY KEY,
DepName VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Student(
StudentID INT IDENTITY(1,1) PRIMARY KEY,
FullName VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE,
GPA DECIMAL(3, 2),
DepartmentID INT,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepID)
);
GO

CREATE TABLE StudentProfile(
ProfileID INT IDENTITY(1,1) PRIMARY KEY,
StudentID INT UNIQUE,
StudentAddress VARCHAR(200),
EmergencyPhone VARCHAR(20),
FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);
GO

CREATE TABLE Course(
CourseID INT IDENTITY(1,1) PRIMARY KEY,
CourseName VARCHAR(100) NOT NULL,
Credits INT,
DepartmentID INT,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepID)
);
GO

CREATE TABLE StudentCourses(
StudentID INT,
CourseID INT,
EnrollmentDate DATE DEFAULT GETDATE(),
PRIMARY KEY (StudentID, CourseID),
FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
GO

ALTER TABLE Student
ADD Age INT;
GO

DROP TABLE TempInstructors;
GO

INSERT INTO Department
VALUES ('Computer Science'), ('Software Engineering'), ('Buisness Adminstration');
GO

INSERT INTO Student
VALUES ('Ali Smadi', 'ali@coursehub.com', 3.80, 1, 22),
('Omar Ahmad', 'omar@coursehub.com', 2.90, 1, 21),
('Laila Hassan', 'laila@coursehub.com', 3.50, 2, 23),
('Tariq Zaid', 'tariq@coursehub.com', 2.10, 3, 20);
GO

INSERT INTO StudentProfile
VALUES (1, 'Amman, Jordan', '0791111111'),
(2, 'Irbid, Jordan', '0792222222'),
(3, 'Zarqa, Jordan', '0793333333');
GO

INSERT INTO Course
VALUES ('Database Systems', 3 ,1),
('Web Development', 3, 1),
('Software Architecture', 3, 2);
GO

INSERT INTO StudentCourses (StudentID, CourseID)
VALUES (1, 1), (1, 2), (2, 1), (3, 3);
GO

UPDATE Student
SET
GPA = 2.50
WHERE StudentID = 4;
GO

DELETE Student WHERE StudentID = 4;
GO

SELECT s.FullName, s.GPA, d.DepName
FROM Student s
INNER JOIN Department d ON s.DepartmentID = d.DepID;
GO

SELECT d.DepName, s.FullName
FROM Department d
LEFT JOIN Student s ON d.DepID = s.DepartmentID;
GO

SELECT s.FUllName, sp.StudentAddress, sp.EmergencyPhone
FROM Student s
INNER JOIN StudentProfile sp ON s.StudentID = sp.StudentID;
GO

SELECT s.FullName, c.CourseName, sc.EnrollmentDate
FROM Student s
INNER JOIN Course c ON s.DepartmentID = c.DepartmentID
INNER JOIN StudentCourses sc ON s.StudentID = sc.StudentID;
GO

SELECT COUNT(s.StudentID) AS TotalStudents, AVG(s.GPA) AS AverageGPA, MAX(s.GPA) AS HighestGPA, MIN(s.GPA) AS LowestGPA
FROM Student s;
GO

SELECT AVG(s.GPA) AS AverageGPA, COUNT(s.StudentID) AS TotalStudent
FROM Student s
GROUP BY DepartmentID;
GO

SELECT s.DepartmentID, AVG(s.GPA) AS AverageGPA
FROM Student s
GROUP BY DepartmentID
HAVING AVG(s.GPA) >= 3.00;
GO

SELECT s.DepartmentID, COUNT(s.StudentID) AS TotalStudentsInDepartment
FROM Student s
WHERE s.GPA >= 2.50
GROUP BY DepartmentID
HAVING COUNT(s.StudentID) > 1;
GO

--Stage 6.1 StudentID
EXEC sp_helpindex 'Student';
GO

--Stage 6.2
CREATE NONCLUSTERED INDEX IX_Students_Email
ON Student(Email);
GO

SELECT * FROM Student WHERE GPA > (SELECT AVG(GPA) FROM Student);
GO

CREATE VIEW vw_StudentAcademicDetails AS
SELECT s.StudentID, s.FullName, s.GPA, d.DepName
FROM Student s
INNER JOIN Department d ON s.DepartmentID = d.DepID;
GO

SELECT * FROM vw_StudentAcademicDetails;

CREATE PROCEDURE sp_GetStudentsByDepartment(@DeptID INT)
AS
BEGIN
SELECT * FROM Student s WHERE s.DepartmentID = @DeptID
END;
GO

EXEC sp_GetStudentsByDepartment 1;