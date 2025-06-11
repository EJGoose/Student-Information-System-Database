--These queries were written for Microsoft SQL Server

-- Create two tables in the database:

--Students table: Stores information about students (id, name, age, grade).USE student_management;
CREATE TABLE Student_Info (
	StudentID VARCHAR(6) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
	Grade FLOAT,
	PRIMARY KEY (StudentID)
);

--Teachers table: Stores information about teachers (id, name, subject).
CREATE TABLE Teacher_Info (
	TeacherID VARCHAR(6) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
    Class VARCHAR(50) NOT NULL,
	PRIMARY KEY (TeacherID)
);



--Create a user named teacher_user without any initial privileges.
CREATE USER teacher_user WITHOUT LOGIN;

-- grant SELECT and INSERT privileges to teacher_user on the students table.
GRANT SELECT, INSERT
ON Student_Info
TO teacher_user;


-- Create another user called admin_user.
CREATE USER admin_user WITHOUT LOGIN;

-- Grant all privileges (SELECT, INSERT, UPDATE, DELETE) on both tables (students and teachers) to admin_user.
GRANT ALL Privileges
ON Teacher_Info
TO admin_user;

GRANT ALL Privileges
ON Student_Info
TO admin_user;


-- revoke the DELETE privilege from admin_user on the students table.
REVOKE DELETE
ON Student_Info
FROM admin_user;



-- Create a new role called student_role and assign it SELECT privileges on the students table.

CREATE ROLE student_role;

GRANT SELECT
ON Student_Info
TO student_role;

-- Create a new user student_user and assign them the student_role.

CREATE USER student_user WITHOUT LOGIN;

ALTER ROLE student_role ADD MEMBER student_user;


--Grant student_user INSERT privileges on the students table.
GRANT SELECT, INSERT
ON Student_Info
TO student_role



-- Create a view named student_overview that shows the ID, name, and grade columns from the student's table.
CREATE VIEW Student_Overview AS
SELECT StudentID, FirstName, LastName, Grade
FROM Student_Info;

-- Query the student_overview view to verify it displays the correct data.
SELECT * FROM Student_Overview; 

-- Modify the view to include a calculated field that shows age categorised as 'Minor' if the age is less than 18, and 'Adult' otherwise.
DROP VIEW IF EXISTS Student_Overview;

CREATE VIEW Student_Overview AS
SELECT 
    StudentID, 
    FirstName, 
    LastName, 
    Grade,
    CASE  
        WHEN Age >= 18 THEN 'Adult';
        ELSE 'Minor';
    END AS age_category
FROM Student_Info;
SELECT * FROM Student_Overview;

  

-- Create a stored procedure named add_student that takes the name, age, and grade as parameters and inserts a new record into the students table.
CREATE PROCEDURES add_student
(IN stud_FirstName VARCHAR(50), IN stud_LastName VARCHAR(50), IN stud_Age INT, IN stud_Grade FLOAT)

BEGIN
	INSERT INTO Student_Info(FirstName, LastName, Age, Grade)
    VALUES (stud_FirstName, stud_LastName, stud_Age, stud_Grade);
END;

-- Run the stored procedure to add a new student.
CALL add_student('Linda', 'Haynes', 12, 3.87);

-- Modify the stored procedure to return the id of the newly added student after insertion.
DROP PROCEDURE IF IT EXISTS add_student;

CREATE PROCEDURE add_student(IN stud_FirstName VARCHAR(50), IN stud_LastName VARCHAR(50), IN stud_Age INT, IN stud_Grade FLOAT, OUT student_id INT)

BEGIN
    INSERT INTO Student_Info(FirstName, LastName, Age, Grade)
    VALUES (stud_FirstName, stud_LastName, stud_Age, stud_Grade);

    SET student_id = LAST_INSERT_ID();
END;

-- Verify that the stored procedure works as expected.
SET @student_id=0;
CALL add_student('John', 'Smyth', 14, 2.80, @student_id);
SELECT @student_id; 



-- Create a user-defined function named calculate_discount that takes a price and a discount percentage as input and returns the discounted price.

CREATE FUNCTION calculate_discount (price DECIMAL(10,2), disccount DECIMAL(5,2))
RETURN DECIMAL(10,2)
BEGIN
	RETURN price - (price * discount/100);
END;


--Write a query to test the function by calculating the discounted price for an item with a price of 100 and a discount of 15%.

SELECT calculate_discount(100, 15) AS discounted_price;

