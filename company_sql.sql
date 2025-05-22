USE company

CREATE TABLE employee(
    SSN INT PRIMARY KEY,
	Fname VARCHAR(50) NOT NULL,
	Lname VARCHAR(50) NOT NULL,
	Gender VARCHAR(6) CHECK (Gender IN ('male', 'female')),
	BirthDay date,
	super_id INT,
	FOREIGN KEY (super_id) REFERENCES employee(SSN),
	DepartmentNo INT
	)

CREATE TABLE Departments(
	Dnum INT PRIMARY KEY,
	DName VARCHAR(50) NOT NULL,
	hiring_Date date,
	ManagerSSN INT
	)

CREATE TABLE DEPARTMENT_LOCATION(
	department_NO INT PRIMARY KEY,
	loc VARCHAR(100) NOT NULL
	)

CREATE TABLE PROJECT(
	PNumber INT PRIMARY KEY,
	Pname VARCHAR(50) NOT NULL,
	PLoc VARCHAR(100) NOT NULL,
	City VARCHAR(50) NOT NULL,
	departmentNo INT
	)

CREATE TABLE DEPENDENTs(
	Dependent_Name VARCHAR(50) NOT NULL,
	GENDER VARCHAR(6) CHECK (Gender IN ('male', 'female')),
	DoB date,
	empSSN INT,
	PRIMARY KEY (Dependent_Name,empSSN)
	)

CREATE TABLE PROJECT_EMPLOYEE(
	working_hours INT,
	projectNo INT,
	employeeSSN INT
	PRIMARY KEY (projectNo,employeeSSN)
	)


ALTER TABLE Departments
ADD CONSTRAINT FK_Manager
FOREIGN KEY (ManagerSSN) REFERENCES employee(SSN);

ALTER TABLE employee
ADD CONSTRAINT FK_Department
FOREIGN KEY (DepartmentNo) REFERENCES Departments(Dnum);

ALTER TABLE PROJECT
ADD CONSTRAINT FK_department_PROJECT
FOREIGN KEY (departmentNo) REFERENCES Departments(Dnum);

ALTER TABLE PROJECT_EMPLOYEE
ADD CONSTRAINT FK_PROJECT_NO
FOREIGN KEY (projectNo) REFERENCES PROJECT(PNumber); 

ALTER TABLE PROJECT_EMPLOYEE
ADD CONSTRAINT FK_employee
FOREIGN KEY (employeeSSN) REFERENCES employee(SSN);

ALTER TABLE DEPENDENTs
ADD CONSTRAINT FK_emp
FOREIGN KEY (empSSN) REFERENCES employee(SSN);

ALTER TABLE DEPARTMENT_LOCATION
ADD CONSTRAINT FK_department_LOCATION
FOREIGN KEY (department_NO) REFERENCES  Departments(Dnum);


INSERT INTO Departments (Dnum, DName, hiring_Date, ManagerSSN) 
VALUES 
(1, 'HR', '2020-05-10', NULL),
(2, 'IT', '2019-08-22', NULL),
(3, 'Finance', '2021-01-15', NULL);

INSERT INTO employee (SSN, Fname, Lname, Gender, BirthDay, super_id, DepartmentNo)
VALUES 
(101, 'John', 'Smith', 'male', '1988-01-01', NULL, 1),
(102, 'Sara', 'Brown', 'female', '1992-05-12', 101, 2),
(103, 'Ali', 'Hassan', 'male', '1990-07-20', 101, 2),
(104, 'Leila', 'Khan', 'female', '1995-03-11', 102, 3);

UPDATE Departments SET ManagerSSN = 101 WHERE Dnum = 1;
UPDATE Departments SET ManagerSSN = 102 WHERE Dnum = 2;
UPDATE Departments SET ManagerSSN = 104 WHERE Dnum = 3;

INSERT INTO PROJECT (PNumber, Pname, PLoc, City, departmentNo)
VALUES 
(201, 'Payroll System', 'Building A', 'New York', 1),
(202, 'Website Revamp', 'Building B', 'Boston', 2),
(203, 'Budget Tracker', 'Building C', 'Chicago', 3);

INSERT INTO PROJECT_EMPLOYEE (working_hours, projectNo, employeeSSN)
VALUES 
(40, 201, 101),
(30, 202, 102),
(25, 202, 103),
(35, 203, 104);

INSERT INTO DEPENDENTs (Dependent_Name, GENDER, DoB, empSSN)
VALUES 
('David', 'male', '2010-05-05', 101),
('Nora', 'female', '2012-07-11', 102);

INSERT INTO DEPARTMENT_LOCATION (department_NO, loc)
VALUES 
(1, 'NY Office'),
(2, 'Boston Hub'),
(3, 'Chicago HQ');

