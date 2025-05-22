Use college

-- DEPARTMENT
CREATE TABLE Department (
    Department_id INT PRIMARY KEY,
    D_name VARCHAR(100) NOT NULL
);

-- FACULTY
CREATE TABLE Faculty (
    F_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Mobile_no VARCHAR(15),
    Salary DECIMAL(10, 2),
    Department_id INT,
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
);

-- HOSTEL
CREATE TABLE Hostel (
    Hostel_id INT PRIMARY KEY,
    Hostel_name VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Address VARCHAR(200),
    Pin_code VARCHAR(10),
    No_of_seats INT
);

-- STUDENT
CREATE TABLE Student (
    S_id INT PRIMARY KEY,
    F_name VARCHAR(50),
    L_name VARCHAR(50),
    Phone_no VARCHAR(15),
    DOB DATE,
    Hostel_id INT,
    Department_id INT,
    F_id INT,
    FOREIGN KEY (Hostel_id) REFERENCES Hostel(Hostel_id),
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id),
    FOREIGN KEY (F_id) REFERENCES Faculty(F_id)
);

-- COURSE
CREATE TABLE Course (
    Course_id INT PRIMARY KEY,
    Course_name VARCHAR(100),
    Duration VARCHAR(50)
);

-- COURSE_DEPARTMENT (Many-to-One: Course ? Department)
CREATE TABLE Course_Department (
    Course_id INT,
    Department_id INT,
    PRIMARY KEY (Course_id, Department_id),
    FOREIGN KEY (Course_id) REFERENCES Course(Course_id),
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
);

-- STUDENT_COURSE (Many-to-Many)
CREATE TABLE Student_Course (
    S_id INT,
    Course_id INT,
    PRIMARY KEY (S_id, Course_id),
    FOREIGN KEY (S_id) REFERENCES Student(S_id),
    FOREIGN KEY (Course_id) REFERENCES Course(Course_id)
);

-- SUBJECT
CREATE TABLE Subject (
    Subject_id INT PRIMARY KEY,
    Subject_name VARCHAR(100),
    F_id INT,
    FOREIGN KEY (F_id) REFERENCES Faculty(F_id)
);

-- STUDENT_SUBJECT (Many-to-Many)
CREATE TABLE Student_Subject (
    S_id INT,
    Subject_id INT,
    PRIMARY KEY (S_id, Subject_id),
    FOREIGN KEY (S_id) REFERENCES Student(S_id),
    FOREIGN KEY (Subject_id) REFERENCES Subject(Subject_id)
);

-- EXAMS
CREATE TABLE Exams (
    Exam_code INT PRIMARY KEY,
    Date DATE,
    Time TIME,
    Room VARCHAR(50),
    Department_id INT,
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
);

-- STUDENT_EXAMS (Many-to-Many)
CREATE TABLE Student_Exams (
    S_id INT,
    Exam_code INT,
    PRIMARY KEY (S_id, Exam_code),
    FOREIGN KEY (S_id) REFERENCES Student(S_id),
    FOREIGN KEY (Exam_code) REFERENCES Exams(Exam_code)
);

INSERT INTO Department VALUES 
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics');

INSERT INTO Faculty VALUES 
(101, 'Dr. Smith', '9876543210', 80000, 1),
(102, 'Dr. Alice', '9876543211', 75000, 2),
(103, 'Dr. John', '9876543212', 70000, 3);

INSERT INTO Hostel VALUES 
(201, 'Alpha Hostel', 'CityA', 'StateA', '123 Main St', '123456', 100),
(202, 'Beta Hostel', 'CityB', 'StateB', '456 Elm St', '654321', 80);

INSERT INTO Student VALUES 
(1, 'Alice', 'Johnson', '9123456780', '2003-05-20', 201, 1, 101),
(2, 'Bob', 'Smith', '9123456781', '2002-07-15', 202, 1, 101),
(3, 'Charlie', 'Brown', '9123456782', '2004-01-10', 201, 2, 102),
(4, 'Diana', 'Lee', '9123456783', '2003-11-30', 202, 3, 103);

INSERT INTO Course VALUES 
(301, 'Data Structures', '6 months'),
(302, 'Calculus', '4 months'),
(303, 'Quantum Physics', '5 months');

INSERT INTO Course_Department VALUES 
(301, 1),
(302, 2),
(303, 3);

INSERT INTO Student_Course VALUES 
(1, 301),
(2, 301),
(3, 302),
(4, 303);

INSERT INTO Subject VALUES 
(401, 'Algorithms', 101),
(402, 'Linear Algebra', 102),
(403, 'Thermodynamics', 103);

INSERT INTO Student_Subject VALUES 
(1, 401),
(2, 401),
(3, 402),
(4, 403);

INSERT INTO Exams VALUES 
(501, '2024-06-15', '10:00', 'R101', 1),
(502, '2024-06-16', '11:00', 'R102', 2),
(503, '2024-06-17', '09:00', 'R103', 3);

INSERT INTO Student_Exams VALUES 
(1, 501),
(2, 501),
(3, 502),
(4, 503);

