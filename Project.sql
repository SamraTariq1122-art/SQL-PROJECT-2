create database projectb
use projectb

-- TABLE DOCTOR --
create table tbl_Doctor(
doctor_id int identity(1,1) PRIMARY KEY ,
name varchar(30) NOT NULL,
age int ,
gender varchar(50) ,
addres varchar(100)
);

-- TABLE PATIENT --
create table tbl_Patient(
patient_id int identity(1,1) PRIMARY KEY ,
name varchar(50) NOT NULL DEFAULT 'UNKNOWN',
age int ,
gender varchar(50) ,
addres varchar(50) ,
disease varchar(50) NOT NULL ,
doctor_id int FOREIGN KEY references tbl_Doctor(doctor_id)
);

-- TABLE LAB --
create table tbl_Lab(
lab_no int identity(1,1) PRIMARY KEY ,
patient_id int FOREIGN KEY references tbl_Patient(patient_id),
doctor_id int FOREIGN KEY references tbl_Doctor(doctor_id) ,
lab_date date NOT NULL DEFAULT GETDATE(),
amount int NOT NULL DEFAULT 0
);
select * from tbl_Lab;



-- ROOM TABLE --
create table tbl_Room (
room_no int identity(1,1) PRIMARY KEY,
room_type varchar(10) NOT NULL DEFAULT 'Common',
status varchar(20)
);


-- INDOOR PATIENT TABLE --
create table tbl_Inpatient(
inpatient_id int identity(1,1) PRIMARY KEY ,
room_no int FOREIGN KEY references tbl_Room(room_no),
date_of_adm date NOT NULL DEFAULT GETDATE(),
date_of_dis date NOT NULL DEFAULT GETDATE(),
lab_no int FOREIGN KEY references tbl_Lab( lab_no)
);

-- BILL TABLE --
create table tbl_Bill (
bill_no int identity(1,1) PRIMARY KEY,
patient_id int FOREIGN KEY (patient_id) REFERENCES tbl_Patient(patient_id),
doctor_charge int NOT NULL DEFAULT 2000,
room_charge int NOT NULL DEFAULT 1000,
no_of_days int NOT NULL DEFAULT 1,
lab_charge int,
bill int NOT NULL DEFAULT 0
);

-- OUTDOOR PATIENT TABLE --
create table tbl_Outpatient (
outpatient_id int identity(1,1) PRIMARY KEY ,
outpatient_date date NOT NULL DEFAULT GETDATE(),
lab_no int FOREIGN KEY (lab_no) REFERENCES tbl_Lab(lab_no)
);

-- BILL TABLE --
create table tbl_Bill (
bill_no int identity(1,1) PRIMARY KEY,
patient_id int FOREIGN KEY (patient_id) REFERENCES tbl_Patient(patient_id),
doctor_charge int NOT NULL DEFAULT 2000,
room_charge int NOT NULL DEFAULT 1000,
no_of_days int NOT NULL DEFAULT 1,
lab_charge int,
bill int NOT NULL DEFAULT 0
);

-- ******************************************* INSERTION IN TABLES ********************************************* --
-- INSERT DOCTOR DATA --
insert into tbl_Doctor VALUES
('Dr. Hussnain', 19, 'Male', 'Etihad Gardens, Rahim Yar Khan'),
('Dr. Nawal', 27, 'Female', 'Township, Lahore'),
('Dr. Waleed', 22, 'Male', 'Davis Road , Lahore')
Select * from tbl_Doctor


-- INSERT PATIENT DATA --
insert into tbl_Patient VALUES
('M. Umair', 22, 'Male', 'Data Darbar, Lahore', 'Mental Disorder', 1),
('Jawad', 39, 'Male', 'Green Town, Lahore', 'Accident', 3),
('Irsa', 10, 'Female', 'Pak-Arab, Lahore', 'Fever',2),
('Fatima', 18, 'Female', 'PIA Road, Lahore', 'Tooth Tess', 1),
('Umar', 70, 'Male', 'College Road, Lahore', 'Ankel Crack', 3),
('Sara', 26, 'Female', 'PIA Road, Lahore', 'Back Pain', 1);
Select * from tbl_Patient

-- INSERT LAB DATA --
insert into tbl_Lab(patient_id,doctor_id,amount) 
VALUES(1,1,500),
(5,3,600),
(6,1,800);
Select * from tbl_Lab

-- INSERT ROOM DATA --
insert into tbl_Room 
Values('A-Common', 'Avalaible'),
('A-Private', 'Avalaible'),
('B-Common', 'Not Avalaible'),
('B-Private', 'Not Avalaible'),
('S-Special', 'Avalaible')
select * from tbl_Room

-- INSERT INDOOR PATIENT DATA --
insert into tbl_Inpatient(room_no, lab_no) 
VALUES(2,1),
(5,3),
(1,1);


-- INSERT OUTDOOR PATINENT DATA --
insert into tbl_Outpatient(lab_no) 
Values(2), 
(3);
select * from tbl_Outpatient


-- INSERT BILL DATA --
-- FORMULA TO CALCULATE BILL IS --
-- bill = doctor_charge + (room_charge * no_of_days) + lab_charge --
insert into tbl_Bill (patient_id,no_of_days,lab_charge,bill) 
Values(1, 2, 500, 5500),
(2, 1, 300, 2300 ),
(3, 1, 150, 2150 ),
(4, 1, 0, 2000 ),
(5, 3, 600, 7600),
(6, 4, 800, 9800);
Select * from tbl_Bill;


---------------> VIEWS <------------------------

---------> checkup
CREATE VIEW CHECKUP AS
SELECT tbl_Doctor.name as [Doctor_Name], tbl_Patient.patient_id as [Patient_ID], tbl_Patient.name as [Paitent_Name] ,
tbl_Patient.disease as [Disease]
FROM tbl_Doctor, tbl_Patient , tbl_Bill 
where tbl_Doctor.doctor_id = tbl_Patient.doctor_id and tbl_Patient.patient_id = tbl_Bill.patient_id;

select * from CHECKUP;




-----> LAB INFO
CREATE VIEW LAB AS
SELECT tbl_Patient.patient_id as [Patient ID], tbl_Patient.name as [Patient Name], tbl_Patient.age as [Patient Age] ,
tbl_Patient.gender as [Gender],
tbl_Patient.disease as [Disese], tbl_Lab.lab_no as [Lab Number]
FROM tbl_Patient, tbl_Lab
where tbl_Patient.patient_id = tbl_Lab.patient_id;
select * from LAB;


------------> INPATIENT INFO
CREATE VIEW Inpatient_info AS
SELECT tbl_Inpatient.inpatient_id as [Indoor Patient ID], tbl_Inpatient.date_of_adm as [Admit Date], tbl_Inpatient.room_no as
[Allocated Room], tbl_Inpatient.date_of_dis as [Discharge Date], tbl_Room.room_type as [Room Type]
FROM tbl_Inpatient,tbl_Room 
where tbl_Inpatient.room_no = tbl_Room.room_no;
select * from Inpatient_info

----------> BILL 
CREATE VIEW Patient_bill AS
SELECT tbl_Patient.name as [Patient Name], tbl_Bill.doctor_charge as [Doctor CheckUp Charges],
tbl_Bill.room_charge as [Room Charges] ,
tbl_Bill.no_of_days as [Total No. of Admit Days], tbl_Bill.lab_charge as [Total Lab Charges] , tbl_Bill.bill 
as [Total Bill]
FROM tbl_Patient , tbl_Bill 
where tbl_Patient.patient_id = tbl_Bill.patient_id;
select * from Patient_bill;

----------> TOTAL BILL 
CREATE VIEW Total_bill AS
SELECT
patient_id , bill_no,
 doctor_charge + (room_charge * no_of_days) + lab_charge AS "TOTAL_BILL"
FROM tbl_Bill
select * from Total_bill;

---------------> QUERY FOR INDOOR Patient RESULT <---------------------------
select distinct tbl_Patient.patient_id as [Patient ID], tbl_Patient.name as [Patient Name] , tbl_Patient.age as
[Patient Age],tbl_Patient.gender as [Patient Gender] , tbl_Patient.disease as [Disease], tbl_Doctor.name as [Doctor Name],
tbl_Bill.doctor_charge as [Doctor Fee],tbl_Inpatient.date_of_adm as [Admit Date] , tbl_Inpatient.date_of_dis as [Discharge Date],
tbl_Inpatient.room_no as [Patient Room No.], tbl_Bill.room_charge as [Room Charges] ,
tbl_Bill.no_of_days as [No. of Admit Days], tbl_Lab.lab_no as [Test Lab No.], tbl_Bill.lab_charge as [Lab 
Charges], tbl_Bill.bill as [Total Bill] 
from tbl_Doctor , tbl_Patient , tbl_Lab , tbl_Room , tbl_Bill , tbl_Inpatient  
where tbl_Doctor.doctor_id = tbl_Patient.doctor_id and tbl_Patient.patient_id = tbl_Inpatient.inpatient_id and tbl_Room.room_no =
tbl_Inpatient.room_no
and tbl_Lab.lab_no = tbl_Inpatient.lab_no and tbl_Bill.patient_id = tbl_Patient.patient_id;


------------> Transaction <----------------------
Begin Transaction
update tbl_Bill set room_charge=1100 where no_of_days>1;
update tbl_Bill set lab_charge=1 where lab_charge=0;
Commit 


begin transaction
update tbl_Bill set room_charge = 1200 where no_of_days > 2;
select * from tbl_Bill;
commit

-----------------> Procedures <----------------
CREATE PROCEDURE insertinPatient
@name1 varchar(50),
@age int,
@gender varchar(50) ,
@addres varchar(50),
@disease varchar(50),
@doctor_id int
AS
begin
insert into tbl_Patient
values(@name1,@age,@gender,@addres,@disease,@doctor_id);
end 

EXEC insertinPatient @name1='Khan',@age=20,@gender='male',@addres='Lda',@disease='Neck injury',@doctor_id=3;
create procedure showsome
@p int
as 
begin 
select * from tbl_Bill where patient_id  = @p;
end
exec showsome @p = 2;
---------------------> Trigger <----------------------
--insertion on patient
create trigger patientinserted on tbl_Patient
for insert
as
begin
select 'Record Inserted Succesfully';
select * from tbl_Patient;
end;

create trigger dispu on tbl_bill
for update
as
begin
select * from tbl_Bill;
end;
