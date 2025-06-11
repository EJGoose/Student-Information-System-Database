
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

