CREATE TABLE User_login (
    User_id INT PRIMARY KEY,
    Pass VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL
);
CREATE TABLE Candidate_Info (
    Student_ID Varchar(50) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Mob_no VARCHAR(15),
    Email_id VARCHAR(100),
    User_id INT,
    FOREIGN KEY (User_id) REFERENCES User_login(User_id)
);
CREATE TABLE Course (
    Course_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Duration INT
);
CREATE TABLE SubCourse (
    SubCourse_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Course_id INT,
    FOREIGN KEY (Course_id) REFERENCES Course(Course_id)
);
CREATE TABLE Profile (
    Student_id VARCHAR(50) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Father_Mother_Name VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    Nationality VARCHAR(50),
    State1 VARCHAR(50),
    Category VARCHAR(50),
    Phy_Handicapped VARCHAR(50),
    Ex_In_Servicemen VARCHAR(50),
    TFWS VARCHAR(50),
    Family_Annual_Income NUMBER(10, 2),
    Address VARCHAR(255),
    foreign key (Student_id) references Candidate_Info(Student_id)
);

CREATE TABLE Cutoff (
    Round_id INT,
    SubCourse_id INT,
    College_id INT,
    Gen INT,
    EWS INT,
    SC INT,
    ST INT,
    OBC INT,
    Phy_Handicapped INT,
    PRIMARY KEY (College_id, SubCourse_id, Round_id),
    FOREIGN KEY (SubCourse_id) REFERENCES SubCourse(SubCourse_id),
    FOREIGN KEY (College_id) REFERENCES College(College_id)
);

CREATE TABLE Application (
    App_id VARCHAR(50) PRIMARY KEY,
    Student_id VARCHAR(50),
    SubCourse_id INT,
    App_Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (Student_id) REFERENCES Candidate_Info(Student_ID),
    FOREIGN KEY (SubCourse_id) REFERENCES SubCourse(SubCourse_id)
);

CREATE TABLE College (
    College_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Loc VARCHAR(100),
    Mobile_no VARCHAR(15),
    Website VARCHAR(255)
);

CREATE TABLE Vacancy (
    College_id INT,
    SubCourse_id INT,
    Round_id INT,
    Vacant_seats INT,
    PRIMARY KEY (College_id, SubCourse_id, Round_id),
    FOREIGN KEY (College_id,SubCourse_id,Round_id) REFERENCES Cutoff(College_id,SubCourse_id,Round_id)
);

CREATE TABLE Exam_Details (
    Seat_no VARCHAR(10) PRIMARY KEY,
    Exam_type VARCHAR(100),
    Passing_month VARCHAR(20),
    Passing_year INT,
    Passing_Status VARCHAR(50),
    Passing_board VARCHAR(100),
    SID_no VARCHAR(50),
    Student_id VARCHAR(50),
    foreign key(Student_id) references Candidate_Info(Student_id)
);

CREATE TABLE Exams_Details_2 (
    Student_id VARCHAR(50) PRIMARY KEY,
    Qualification_Exam_State VARCHAR(100),
    Qualification_Exam_District VARCHAR(100),
    School_Name VARCHAR(100),
    School_index_no VARCHAR(50),
    Foreign key(Student_id) references Candidate_Info(Student_id)
);

CREATE TABLE Marks_Obtained (
    Seat_no VARCHAR(10) PRIMARY KEY,
    Science_pr DECIMAL(5, 2),
    Marks_in_physics DECIMAL(5, 2),
    Marks_in_chemistry DECIMAL(5, 2),
    Marks_in_Maths DECIMAL(5, 2),
    Marks_in_Biology DECIMAL(5, 2),
    Tot_Marks_Obtained DECIMAL(10, 2),
    foreign Key (Seat_no) references Exam_Details(Seat_no)
);

CREATE TABLE Payment (
    Payment_id INT PRIMARY KEY,
    Payment_date DATE,
    Payment_status VARCHAR(50),
    Amount_paid DECIMAL(10, 2),
    Student_id VARCHAR(50),
    FOREIGN KEY (Student_id) REFERENCES Candidate_Info(Student_ID)
);
CREATE TABLE Document (
    Doc_id INT PRIMARY KEY,
    File_path VARCHAR(255),
    File_name VARCHAR(100),
    Doc_type VARCHAR(50),
    Student_id VARCHAR(50),
    FOREIGN KEY (Student_id) REFERENCES Candidate_Info(Student_ID)
);
CREATE TABLE Seat (
    Seat_allotment_id INT PRIMARY KEY,
    Seat_type VARCHAR(50),
    Sub_Course_id INT,
    Student_id VARCHAR(50),
    College_id INT,
    FOREIGN KEY (Sub_Course_id) REFERENCES SubCourse(SubCourse_id),
    FOREIGN KEY (Student_id) REFERENCES Candidate_Info(Student_ID),
    FOREIGN KEY (College_id) REFERENCES College(College_id)
);
CREATE TABLE Merit (
    Merit_id INT PRIMARY KEY,
    Rank INT,
    Generation_date DATE,
    Student_id VARCHAR(50),
    FOREIGN KEY (Student_id) REFERENCES Candidate_Info(Student_ID)
);

INSERT INTO User_login (User_id, Pass, Role) VALUES (1, 'pass123', 'user');
INSERT INTO User_login (User_id, Pass, Role) VALUES (2, 'password456', 'user');
INSERT INTO User_login (User_id, Pass, Role) VALUES (3, 'securepass', 'user');
INSERT INTO User_login (User_id, Pass, Role) VALUES (4, 'login123', 'user');
INSERT INTO User_login (User_id, Pass, Role) VALUES (5, 'password789', 'user');

CREATE OR REPLACE TRIGGER generate_student_id
      BEFORE INSERT ON Candidate_Info
      FOR EACH ROW
      DECLARE
        pfx VARCHAR2(2);
        sfx VARCHAR2(4);
        last_student_id INT;
      BEGIN
        pfx := UPPER(SUBSTR(:new.Name, 1, 2));
        SELECT MAX(TO_NUMBER(SUBSTR(Student_ID,5,4))) INTO last_student_id
        FROM Candidate_Info
        WHERE SUBSTR(Student_ID, 3, 2) = '24';
           IF last_student_id IS NULL THEN
               sfx := '0001';
           ELSE
               sfx := TO_CHAR((last_student_id) + 1, 'FM0000'); 
           END IF;
           :new.student_id := pfx || '24' || sfx;
      END;

CREATE OR REPLACE TRIGGER check_mobile_length
    BEFORE INSERT OR UPDATE ON Candidate_Info
    FOR EACH ROW
    BEGIN
        IF LENGTH(:NEW.Mob_no) != 10 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Mobile number must be 10 digits long.');
        END IF;
    END;

INSERT INTO Candidate_Info (Name, Mob_no, Email_id, User_id) VALUES ('John Doe', '1234567890', 'john@example.com', 1);
INSERT INTO Candidate_Info (Name, Mob_no, Email_id, User_id) VALUES ('Jane Smith', '9876543210', 'jane@example.com', 2);
INSERT INTO Candidate_Info (Name, Mob_no, Email_id, User_id) VALUES ('Alice Johnson', '5678901234', 'alice@example.com', 3);
INSERT INTO Candidate_Info (Name, Mob_no, Email_id, User_id) VALUES ('Bob Williams', '3210987654', 'bob@example.com', 4);
INSERT INTO Candidate_Info (Name, Mob_no, Email_id, User_id) VALUES ('Emma Brown', '7890123456', 'emma@example.com', 5);

INSERT INTO Course (Course_id, Name, Duration) VALUES (1, 'BE', 4);
INSERT INTO Course (Course_id, Name, Duration) VALUES (2, 'B-PHARM', 4);

INSERT INTO SubCourse (SubCourse_id, Name, Course_id) VALUES (1, 'Software Engineering', 1);
INSERT INTO SubCourse (SubCourse_id, Name, Course_id) VALUES (2, 'Database Management', 1);
INSERT INTO SubCourse (SubCourse_id, Name, Course_id) VALUES (3, 'Web Development', 1);
INSERT INTO SubCourse (SubCourse_id, Name, Course_id) VALUES (4, 'Artificial Intelligence', 1);
INSERT INTO SubCourse (SubCourse_id, Name, Course_id) VALUES (5, 'Computer Networks', 1);

INSERT INTO Profile VALUES ('JO240001', 'Jane Smith', 'John Smith ', to_date('2000-02-02','yyyy-mm-dd'),'Female', 'Nationality2', 'State2', 'Category2', 'No', 'No', 'No', 60000.00, 'Address2');
INSERT INTO Profile VALUES ('JA240002', 'John Doe', 'David Doe and Sarah Doe', to_date('2000-02-01','yyyy-mm-dd'), 'Male', 'Nationality1', 'State1', 'Category1', 'No', 'No', 'No', 50000.00, 'Address1');
INSERT INTO Profile VALUES ('AL240003', 'Alice Johnson', 'Robert Johnson and Emily Johnson', to_date('2000-02-02','yyyy-mm-dd'), 'Female', 'Nationality3', 'State3', 'Category3', 'No', 'No', 'No', 70000.00, 'Address3');
INSERT INTO Profile VALUES ('BO240004', 'Bob Williams', 'Michael Williams and Laura Williams', to_date('2000-02-02','yyyy-mm-dd'), 'Male', 'Nationality4', 'State4', 'Category4', 'No', 'No', 'No', 80000.00, 'Address4');
INSERT INTO Profile VALUES ('EM240005', 'Emma Brown', 'Daniel Brown and Rebecca Brown', to_date('2000-02-02','yyyy-mm-dd'), 'Female', 'Nationality5', 'State5', 'Category5', 'No', 'No', 'No', 90000.00, 'Address5');

insert into College values (111,'MSU','BARODA','8569654524','WWW.MSU_TECHO.IN');
insert into College values (122,'LDCE','AHMEDABAD','9269654524','WWW.LDCE.IN');
INSERT INTO College VALUES (113, 'Gujarat Technological University', 'Ahmedabad', '079-23267521', 'https://www.gtu.ac.in');
INSERT INTO College VALUES (114, 'Dharmsinh Desai University', 'Nadiad', '0268-2520502', 'https://www.ddu.ac.in');
INSERT INTO College VALUES (115, 'Nirma University', 'Ahmedabad', '02717-241900', 'https://www.nirmauni.ac.in');

INSERT INTO Cutoff VALUES (1, 1, 111, 85, 90, 75, 70, 80, 65);
INSERT INTO Cutoff VALUES (2, 2, 111, 80, 85, 70, 65, 75, 60);
INSERT INTO Cutoff VALUES (1, 1, 122, 85, 90, 75, 70, 80, 65);
INSERT INTO Cutoff VALUES (2, 2, 122, 80, 85, 70, 65, 75, 60);
INSERT INTO Cutoff VALUES (1, 1, 113, 85, 90, 75, 70, 80, 65);
INSERT INTO Cutoff VALUES (2, 2, 113, 80, 85, 70, 65, 75, 60);

CREATE OR REPLACE TRIGGER generate_application_id
BEFORE INSERT ON Application
FOR EACH ROW
DECLARE
    application_id_prefix VARCHAR2(5) := 'APP_';
    random_number VARCHAR2(10);
BEGIN
    random_number := TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(10000, 99999)));
    :NEW.App_id := application_id_prefix || random_number;
END;

INSERT INTO Application (Student_id, SubCourse_id, App_Date, Status) VALUES ('JO240001', 1, to_date('2024-04-25','yyyy-mm-dd'), 'Pending');
INSERT INTO Application (Student_id, SubCourse_id, App_Date, Status) VALUES ('JA240002', 2, to_date('2024-04-26','yyyy-mm-dd'), 'Accepted');
INSERT INTO Application (Student_id, SubCourse_id, App_Date, Status) VALUES ('AL240003', 3, to_date('2024-04-27','yyyy-mm-dd'), 'Accepted');
INSERT INTO Application (Student_id, SubCourse_id, App_Date, Status) VALUES ('BO240004', 4, to_date('2024-04-28','yyyy-mm-dd'), 'Pending');
INSERT INTO Application (Student_id, SubCourse_id, App_Date, Status) VALUES ('EM240005', 5, to_date('2024-04-29','yyyy-mm-dd'), 'Pending');

INSERT INTO Vacancy values(111,2,2,12);
INSERT INTO Vacancy values(122,1,1,19);
INSERT INTO Vacancy values(122,2,2,18);
INSERT INTO Vacancy values(113,1,1,17);
INSERT INTO Vacancy values(113,2,2,20);

CREATE OR REPLACE FUNCTION reduce_vacancy(p_college_id IN VARCHAR2, p_subcourse_id IN VARCHAR2)
RETURN NUMBER
IS
 v_vacancy NUMBER;
BEGIN
 SELECT Vacant_seats
    INTO v_vacancy
    FROM Vacancy
    WHERE College_id = p_college_id
    AND SubCourse_id = p_subcourse_id;
iF v_vacancy > 0 THEN
        UPDATE Vacancy
        SET Vacant_seats = Vacant_seats - 1
        WHERE College_id = p_college_id
        AND SubCourse_id = p_subcourse_id;
        COMMIT;
         RETURN 1; 
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        RETURN -2; 
END;

declare
a int;
begin
a:=reduce_vacancy(113,2);
if a=0 then 
    dbms_output.put_line('No vacant seats Available');
end if;
end;

INSERT INTO PAYMENT VALUES (123,SYSDATE,'SUCCESSFULL',1500,'JO240001');
INSERT INTO Payment VALUES (124, SYSDATE, 'SUCCESSFUL', 2000, 'JA240002');
INSERT INTO Payment VALUES (125, SYSDATE, 'PENDING', 1800, 'AL240003');
INSERT INTO Payment VALUES (126, SYSDATE, 'SUCCESSFUL', 2200, 'BO240004');
INSERT INTO Payment VALUES (127, SYSDATE, 'FAILED', 2500, 'EM240005');

INSERT INTO Document VALUES (1, '/path/to/aadhaar_card.pdf', 'Aadhaar_Card.pdf', 'PDF', 'JO240001');
INSERT INTO Document VALUES (2, '/path/to/marksheet.pdf', 'Marksheet.pdf', 'PDF', 'JA240002');
INSERT INTO Document VALUES (3, '/path/to/passport_photo.jpg', 'Passport_Photo.jpg', 'JPEG', 'AL240003');
INSERT INTO Document VALUES (4, '/path/to/aadhar_card.docx', 'Aadhar.docx', 'DOCX', 'BO240004');
INSERT INTO Document VALUES (5, '/path/to/aadhar_card.docx', 'Aadhar.docx', 'DOCX', 'EM240005');

create or replace trigger CHECK_SEATNO
    before insert ON Exam_Details
    for each row 
    begin
      if 
    	Upper(:new.Exam_type)='GUJCET' and :NEW.Seat_no NOT like 'h%' then                                             
    		RAISE_APPLICATION_ERROR(-20001,'for gujcet exam seat number must be start from h');
      elsif 
      Upper(:new.Exam_type)='HSC' and :NEW.Seat_no NOT like 'b%' then
        Raise_application_error(-20001,'seat number must be start from b');
      end if;
    end;

truncate table Exam_Details;

INSERT INTO Exam_Details VALUES ('b125678','HSC', 'March', 2020, 'Passed', 'State Board', '987654321','JO240001');
INSERT INTO Exam_Details VALUES ('h121234', 'GUJCET','May', 2020, 'Passed', 'State Board', '123456789','JA240002');
INSERT INTO Exam_Details VALUES ('b129012', 'HSC', 'March', 2021, 'Passed', 'State Board', '543210987','AL240003');
INSERT INTO Exam_Details VALUES ('h123456', 'GUJCET','May', 2021, 'Passed', 'State Board', '678905432','BO240004');
INSERT INTO Exam_Details VALUES ('b127890', 'HSC', 'March', 2022, 'Passed', 'State Board', '219876543','EM240005');
INSERT INTO Exam_Details VALUES ('h125678','GUJCET', 'March', 2020, 'Passed', 'State Board', '987654321','JO240001');
INSERT INTO Exam_Details VALUES ('b121234', 'HSC','May', 2020, 'Passed', 'State Board', '123456789','JA240002');
INSERT INTO Exam_Details VALUES ('h129012', 'GUJCET', 'March', 2021, 'Passed', 'State Board', '543210987','AL240003');
INSERT INTO Exam_Details VALUES ('b123456', 'HSC','May', 2021, 'Passed', 'State Board', '678905432','BO240004');
INSERT INTO Exam_Details VALUES ('h127890', 'GUJCET', 'March', 2022, 'Passed', 'State Board', '219876543','EM240005');

INSERT INTO Exams_Details_2 VALUES ('JO240001', 'State1', 'District1', 'ABC School', '12345');
INSERT INTO Exams_Details_2 VALUES ('JA240002', 'State2', 'District2', 'XYZ School', '67890');
INSERT INTO Exams_Details_2 VALUES ('AL240003', 'State3', 'District3', 'PQR School', '54321');
INSERT INTO Exams_Details_2 VALUES ('BO240004', 'State4', 'District4', 'LMN School', '09876');
INSERT INTO Exams_Details_2 VALUES ('EM240005', 'State5', 'District5', 'OPQ School', '13579');

INSERT INTO Marks_Obtained VALUES ('b125678', 42.75, 48.50, 46.25, NULL, 51.25, 188.75);
INSERT INTO Marks_Obtained VALUES ('h121234', 45.00, 40.25, 47.50, NULL, 45.75, 178.50);
INSERT INTO Marks_Obtained VALUES ('b129012', 45.25, 50.00, 48.50, 53.75, NULL, 197.50);
INSERT INTO Marks_Obtained VALUES ('h123456', 48.50, 42.75, 49.25, 47.00, NULL, 187.50);
INSERT INTO Marks_Obtained VALUES ('b127890', 50.50, 42.75, 49.25, 47.00, NULL, 187.50);
INSERT INTO Marks_Obtained VALUES ('h125678', 49.75, 88.50, 56.25, NULL, 61.25, 245.75);
INSERT INTO Marks_Obtained VALUES ('b121234', 45.00, 40.25, 47.50, NULL, 45.75, 178.50);
INSERT INTO Marks_Obtained VALUES ('h129012', 45.25, 50.00, 48.50, 60.75, NULL, 204.50);
INSERT INTO Marks_Obtained VALUES ('b123456', 48.50, 42.75, 49.25, 49.00, NULL, 190.50);
INSERT INTO Marks_Obtained VALUES ('h127890', 53.50, 42.75, 49.25, 57.00, NULL, 197.50);

CREATE OR REPLACE FUNCTION GET_PR(id IN VARCHAR2) RETURN float IS
   a float;
   b float;
   c float;
BEGIN
   SELECT Science_pr INTO b
   FROM Marks_Obtained m
   WHERE m.Seat_no = (
      SELECT e.Seat_no
      FROM Exam_Details e
      WHERE e.Seat_no LIKE 'b%' AND e.Student_id = id
   );
   SELECT Science_pr INTO c
   FROM Marks_Obtained m
   WHERE m.Seat_no = (
      SELECT e.Seat_no
      FROM Exam_Details e
      WHERE e.Seat_no LIKE 'h%' AND e.Student_id = id
   );
   a := (b + c) / 2;
   RETURN a;
END;

create table Extra(
    Student_id varchar(10) primary key,
    pr float
);

declare
cursor c1 is select * from Candidate_Info;
r1 c1%rowtype;
d float;
begin
for r1 in c1
loop
d:=get_pr(r1.Student_id);
insert into Extra values(r1.Student_id,d);
end loop;
end;

CREATE OR REPLACE TRIGGER generate_merit_id
    BEFORE INSERT ON Merit
    FOR EACH ROW
    DECLARE
       random_number INT;
    BEGIN
    random_number := FLOOR(DBMS_RANDOM.VALUE(10000, 99999));
    :NEW.merit_id := random_number;
END;

CREATE OR REPLACE PROCEDURE rank_generator(a in out number,id in varchar)
IS
BEGIN
    insert into merit(Rank,Generation_date,Student_id) values (a,sysdate,id);
    a := a + 1;
END;

declare
cursor c1 is select * from Extra order by pr desc;
r1 c1%rowtype;
a int:=1;
begin
for r1 in c1
loop
rank_generator(a,r1.Student_id);
end loop;
end;

select * from merit;

INSERT INTO Seat VALUES (1, 'Gen', 1, 'JO240001', 111);
INSERT INTO Seat VALUES (2, 'OBC', 2, 'JA240002', 122);
INSERT INTO Seat VALUES (3, 'SC', 3, 'AL240003', 113);
INSERT INTO Seat VALUES (4, 'ST', 4, 'BO240004', 114);
INSERT INTO Seat VALUES (5, 'Open', 5, 'EM240005', 115);

CREATE OR REPLACE FUNCTION reduce_vacancy(p_college_id IN VARCHAR2, p_subcourse_id IN VARCHAR2)
RETURN NUMBER
IS
 v_vacancy NUMBER;
BEGIN
    SELECT Vacant_seats INTO v_vacancy FROM Vacancy
    WHERE College_id = p_college_id AND SubCourse_id = p_subcourse_id;
iF v_vacancy > 0 THEN
        UPDATE Vacancy SET Vacant_seats = Vacant_seats - 1
        WHERE College_id = p_college_id AND SubCourse_id = p_subcourse_id;
        COMMIT;
        RETURN 1; 
    ELSE
        RETURN 0;
END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        RETURN -2; 
END;

declare
cursor c1 is select * from Seat;
r1 c1%rowtype;
a int;
begin
for r1 in c1
loop
    a:=reduce_vacancy(r1.College_id,r1.Sub_course_id);
    if a=0 then 
    	dbms_output.put_line('No vacant Seats Available');
	end if;
end loop;
end;

select * from Vacancy
