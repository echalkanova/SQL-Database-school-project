CREATE TABLE Students
(
  StudentID int PRIMARY KEY,
  Name VARCHAR(50),
  fID int,
  BirthDate date,
  City VARCHAR (50)

)

INSERT INTO Students
VALUES
(2, 'Alex', 22, '2000-02-07', 'Milano'),
(3, 'Matt', 33, '2000-06-22', 'Paris'),
(4, 'Fiona', 44, '2000-12-18', 'Sofia'),
(5, 'Helen', 55, '2000-11-20', 'Belgrad'),
(6, 'Dennis', 66, '2000-09-22', 'Barcelona'),
(7, 'Lara', 77, '2000-04-25', 'New York'),
(8, 'Steffie', 88, '2000-03-12', 'Paris'),
(9, 'Mario', 99, '2000-02-14', 'Milano'),
(10, 'Andy', 100, '2000-01-14', 'New York'),
(11, 'Yoan', 110, '2000-12-12', 'Belgrad'),
(12, 'Pamela', 120, '2000-11-18', 'Belgrad')

CREATE TABLE Department
(
  DepartmentID int PRIMARY KEY,
  Name VARCHAR (50),
  Teacher VARCHAR (50)

)

INSERT INTO Department
VALUES(1, 'Chemistry', 'Mariana Ivanova'),
(2, 'Geography', 'Krasimir Stoimenov'),
(3, 'Economics', 'Dobrin Dobrev'),
(4, 'Engineering', 'Miroslav Georgiev'),
(5, 'Design', 'Nikoleta Nikolova'),
(6, 'Programming', 'Georgi Ivanov'),
(7, 'Finances', 'Stefan Peev'),
(8, 'Tourism', 'Stanislava Miroslavova'),
(9, 'Math', 'Kostadina Ivanova'),
(10, 'Biology', 'Maria Konstantinova')

CREATE TABLE Teachers
(
  TeacherID int PRIMARY KEY,
  DepartmentID int,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  UniversityPosition VARCHAR(50),
  Salary money,
  WorkExperience int,

CONSTRAINT FK_DepartmentsTeachers
FOREIGN KEY(DepartmentID)
REFERENCES Department(DepartmentID)
)

INSERT INTO Teachers
VALUES (1, 1, 'Mariana', 'Ivanova', 'Professor', 3000, 35),
(2, 2, 'Krasimir', 'Stoimenov', 'Assistant', 2000, 5),
(3, 3, 'Dobrin', 'Dobrev', 'Docent', 2000, 20),
(4, 4, 'Miroslav', 'Georgiev', 'Professor', 3000, 30),
(5, 5, 'Nikoleta', 'Nikolova', 'Docent', 2000, 25),
(6, 6, 'Georgi', 'Ivanov', 'Chief Assistant', 2500, 10),
(7, 7, 'Stefan', 'Peev', 'Assistant', 1000, 7),
(8, 2, 'Stanislava', 'Miroslavova', 'Chief Assistant', 2000, 15),
(9, 9, 'Kostadina', 'Ivanova', 'Docent', 2000, 20),
(10, 10, 'Maria', 'Kostadinova', 'Professor', 3000, 35)


CREATE TABLE Courses
(
  CourseID int PRIMARY KEY,
  TeacherID int,
  Name VARCHAR(50),
  CourseDuration int,
  StartDate date,
  EndDate date,
  Price money

CONSTRAINT FK_CoursesTeachers_Teachers
FOREIGN KEY(TeacherID)
REFERENCES Teachers(TeacherID)

)

INSERT INTO Courses
VALUES(1,1,'Organic Chemistry', 3, '2021-12-21', '2024-12-21', 450),
(2,2,'Climate Expert', 4, '2020-07-06', '2024-07-06', 550),
(3,3,'Macroeconomics', 5, '2021-10-11', '2026-11-02', 750),
(4,4,'Mechanical Engineering', 2, '2022-09-17', '2024-10-18', 450),
(5,5,'Graphic Design', 5, '2023-02-22', '2028-02-22', 1000),
(6,6,'SoftProgramming', 6, '2021-12-21', '2027-12-21', 1500),
(7,7,'Finances', 2, '2022-02-01', '2024-02-01', 550),
(8,8,'Travel Guide', 6, '2022-10-21', '2028-11-21', 750),
(9,9,'Algebra', 3, '2020-09-23', '2023-09-24', 350),
(10,10,'Nurse', 4, '2021-04-05', '2025-07-01', 800)



CREATE TABLE StudentsCourses
(

IDStudent int,
IDCourse int,

CONSTRAINT FK_StudentsCourses
PRIMARY KEY(IDStudent, IDCourse),

CONSTRAINT FK_StudentsCourse_Students
FOREIGN KEY(IDStudent)
REFERENCES Students(StudentID),

CONSTRAINT FK_StudentsCourse_Course
FOREIGN KEY(IDCourse)
REFERENCES Courses(CourseID)
)

INSERT INTO StudentsCourses
VALUES(2,2),
(2,3),
(3,6),
(4,5),
(5,7),
(6,10),
(7,2),
(8,2),
(9,8),
(10,9)

SELECT CourseID, CourseDuration, Teachers.FirstName + ' ' + Teachers.LastName AS [Teacher's FullName]
FROM Courses
JOIN Teachers ON Courses.TeacherID = Teachers.TeacherID
WHERE CourseDuration >= 3 /*A*/

SELECT Teachers.FirstName, Teachers.LastName, Teachers.Salary
INTO MathTeachers
FROM Teachers
JOIN Courses ON Courses.TeacherID = Teachers.TeacherID
JOIN Department ON Department.DepartmentID = Teachers.DepartmentID
WHERE Department.Name = 'Math' /*вместо 'Математика и информатика'*/ /*B*/

SELECT Teachers.FirstName + ' '+ Teachers.LastName as [Teacher's FullName], Teachers.WorkExperience, Courses.Name AS [CourseName]
FROM Teachers
JOIN Courses ON Courses.TeacherID = Teachers.TeacherID
WHERE WorkExperience BETWEEN 10 AND 15 /*C*/

SELECT Students.Name, Courses.Name AS [CourseName],YEAR(GETDATE())- YEAR(BirthDate) AS [Age]
FROM Students
JOIN StudentsCourses ON StudentsCourses.IDStudent = Students.StudentID
JOIN Courses ON StudentsCourses.IDCourse= Courses.CourseID
WHERE City = 'New York' /*вместо Сливен*/ /*D*/


SELECT Students.Name, Teachers.FirstName + ' ' + Teachers.LastName AS [Teacher's FullName], Teachers.TeacherID, Courses.CourseDuration, Courses.Price, Courses.Name AS [CourseName]
FROM Students
JOIN StudentsCourses ON StudentsCourses.IDStudent = Students.StudentID
LEFT JOIN Courses ON StudentsCourses.IDCourse=Courses.CourseID
LEFT JOIN Teachers ON Courses.CourseID=Teachers.TeacherID
ORDER BY Courses.Name, Teachers.TeacherID /*E*/


SELECT IDCourse,COUNT(IDStudent) AS [StudentCount]
FROM StudentsCourses
GROUP BY IDCourse /*F*/

SELECT SUM(Price) AS SumPrice
FROM Courses /*G*/

SELECT SUM(Salary) AS SumSalary
FROM Teachers/*H*/

SELECT MAX(Salary) AS MaxSalary
FROM Teachers /*H*/

INSERT INTO Courses
VALUES (11, 5, 'Web Design', 4, '2022-10-02', '2026-05-03', 2500) /*I*/

UPDATE Teachers
SET Salary = Salary * 1.10 /*J*/

USE University
(SELECT FirstName, TeacherID, Salary
FROM Teachers
WHERE TeacherID IN ('2', '3', '5'))
UNION
(SELECT Name, TeacherID, Price
FROM Courses
WHERE TeacherID IN ('2', '3', '5')) /*K*/