use Hospital

--------------------------------------------------------------------------------------------------
--Insert records into Department table
insert into Department (Name) 
values ('Cardiology'), ('Neurology'), ('Pediatrics'), ('General Surgery'), ('Orthopedics'), ('Secretarial')

--------------------------------------------------------------------------------------------------
--Insert records into Doctor table
declare @insertedDocIDt1 TABLE (id INT, Speciality NVARCHAR(100))
insert into Employee (EmpType, Fname, Lname, DOB, Phone,Gender, Street, City, State, Salary, DeptID)
output inserted.id, case 
                       when inserted.Fname = 'Ahmed' then 'Cardiologist'
                       when inserted.Fname = 'Khaled' then 'Neurologist'
                       when inserted.Fname = 'hala' then 'Pediatrician'
					   when inserted.Fname = 'Rana' then 'General Surgeon'
					   when inserted.Fname = 'Mostafa' then 'Orthopedic Surgeon	'
                   end into @insertedDocIDt1
values
    ('D', 'Ahmed', 'Ali', '1985-05-12', '0123456789', 'M', 'Street 1', 'Giza', 'Egypt',15000, 100),
    ('D', 'Khaled', 'Mahmoud', '1980-11-05', '0103456789', 'M', 'Street 2', default, default, 12000, 101),
    ('D', 'hala', 'Adel', '1990-07-20', '0113756780', 'F', 'Street 33', 'Alexandria', 'Egypt', 11000, 102),
	('D', 'Rana', 'Samir', '1996-01-01', '0103950789', 'F', 'Street 51', default, default, 11500, 103),
    ('D', 'Mostafa', 'Abdallah', '1989-06-05', '0123556787', 'M', 'Street 9', default, default, 14300, 104)

insert into Doctor (Id, Speciality)
select id, Speciality
from @insertedDocIDt1


--------------------------------------------------------------------------------------------------
--Insert records into Nurse table    
DECLARE @insertedNurIDt2 TABLE (id INT)
insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, Salary, DeptID)
output inserted.Id into @insertedNurIDt2
values
	('N', 'Sara', 'Hassan', '1990-10-22', '01144456820', 'F', NULL, 'Giza', 'Egypt', 6000, 102),
    ('N', 'Mona', 'Youssef', '1992-03-15', '0129876543', 'F', 'Street 3', default, default, 8000, 103),
	('N', 'Hala', 'Youssef', '1991-12-19', '0109876543', 'F', 'Street 5', 'Alexandria', 'Egypt', 7000, 104),
    ('N', 'Nour', 'Salem', '1989-05-11', '0111234567', 'F', 'Street 6', 'Giza', 'Egypt', 6030, 100),
    ('N', 'Maha', 'Ezzat', '1994-03-22', '0123454321', 'F', 'Street 7', default, default, 5500, 101)

INSERT INTO Nurse (Id)
SELECT id
FROM @insertedNurIDt2

-----------------------------------------------------------------------------------------------
--Insert records into Receptionist table
DECLARE @insertedRecIDt2 TABLE (id INT)
insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Street, City, State, Salary, DeptID)
output inserted.Id into @insertedRecIDt2
values
	('R', 'Ahmed', 'Adel', '1990-10-22', '01150211405', 'M', NULL, default, default, 5700, 105),
    ('R', 'Osama', 'Ali', '1992-03-15', '0119876543', 'M', 'Street 13', 'Alexandria', 'Egypt', 4500, 105),
	('R', 'Hany', 'Hassan', '1991-12-19', '0159876543', 'M', 'Street 55', 'Giza', 'Egypt', 5000, 105)

INSERT INTO Receptionist(Id)
SELECT id
FROM @insertedRecIDt2

--------------------------------------------------------------------------------------------------
--Insert records into Room table
insert into Room (MaxCapacity, CurrentCapacity ,NId)
values
  (2, 0, 6), (1, 0, 7), (3, 0, 8), (4, 0, 9), (1, 0, 10)

--------------------------------------------------------------------------------------------------
--Insert records into OutPatient table
declare @InsertedOutPatientIdTable1 table (Id int)

insert into Patient (FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id into @InsertedOutPatientIdTable1
values 
	('Ali', 'Omar', '1995-11-05', '0121234567' ,'M', 'Park Lane', 'Giza', 'Egypt'),
	('Ahmed', 'Mohamed', '2000-05-20', '0151234567', 'M', 'Broadway', default, default),
	('Mahmoud', null, '2005-07-07', '0101234567', 'M', null, default, default),
	('Sara', null, '1990-07-08', '0122234567', 'F', null, default, default),
	('Mariam', null, '2004-05-09', '0125234567', 'F', 'Maadi', default, default)

insert into OutPatient (Id)
select id from @InsertedOutPatientIdTable1

--------------------------------------------------------------------------------------------------
--Insert records into InPatient table
--First patient
declare @InsertedInPatientIdTable1 table (Id int)

insert into Patient (FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable1
values ('Fatma', 'Ahmed', '1997-12-03', '0100876543','F', null, 'Giza', 'Egypt')

declare @InsertedInPatientId1 int
select @InsertedInPatientId1 = Id from @InsertedInPatientIdTable1

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId1, 100)

--------------------------------------------------------------------------------------------------
--Second patient
declare @InsertedInPatientIdTable2 table (Id int)

insert into Patient (FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable2
values ( 'Hana', 'Khaled', '1998-06-15', '0101876543', 'F', 'Talaat Harb St', 'Cairo', 'Egypt')

declare @InsertedInPatientId2 int
select @InsertedInPatientId2 = Id from @InsertedInPatientIdTable2

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId2, 101)

--------------------------------------------------------------------------------------------------
--Third patient
declare @InsertedInPatientIdTable3 table (Id int)

insert into Patient (FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable3
values ('Omar', 'Ibrahim', '1990-03-12', '0106876543', 'M', 'Corniche Rd', 'Alexandria', 'Egypt')

declare @InsertedInPatientId3 int
select @InsertedInPatientId3 = Id from @InsertedInPatientIdTable3

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId3, 102)

--------------------------------------------------------------------------------------------------
--Forth patient
declare @InsertedInPatientIdTable4 table (Id int)

insert into Patient (FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable4
values ('Youssef', 'Ali', '1992-04-22', '0109976543', 'M', 'Shubra Rd', 'Cairo', 'Egypt')

declare @InsertedInPatientId4 int
select @InsertedInPatientId4 = Id from @InsertedInPatientIdTable4

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId4, 103)

--------------------------------------------------------------------------------------------------
--Fifth patient
declare @InsertedInPatientIdTable5 table (Id int)

insert into Patient (FName, LName, DOB, Phone, Gender, Street, City, State)
output inserted.Id into @InsertedInPatientIdTable5
values ('Salma', 'Hussein', '2001-10-08', '0106800543', 'F', 'Nasr St', 'Mansoura', 'Egypt')

declare @InsertedInPatientId5 int
select @InsertedInPatientId5 = Id from @InsertedInPatientIdTable5

insert into InPatient (Id, RoNum)
values (@InsertedInPatientId5, 104)

--------------------------------------------------------------------------------------------------
--Insert records into Appointment table
insert into Appointment (Date, Note, DId, PId, RId, Status)
values 
	('2024-12-29 15:30:00', 'Follow-up check', 3, 1, 12, 'Done'),
	('2024-12-27 10:30:00', 'Routine visit', 1, 2, 12, 'Done'),
	('2024-12-30 14:00:00', null, 2, 3, 11, 'Done'),
	('2025-1-1 15:00:00', null, 3, 4, 13, 'Done'),
	('2024-12-28 17:00:00', null, 5, 5, 11, 'Done'),
	('2024-12-31 15:00:00', null, 4, 6, 13, 'Done'),
	('2025-1-1 14:00:00', null, 2, 7, 11, 'Done'),
	('2025-1-2 10:00:00', 'Emergency Appointment', 1, 8, 13, 'Done'),
	('2025-1-2 14:00:00', 'Emergency Appointment', 4, 9, 11, 'Done'),
	('2024-12-30 8:00:00', null, 1, 10, 12, 'Done')

--------------------------------------------------------------------------------------------------
--Insert records into Report table
insert into Report (Disease, Symptom, Diagnosis, PId, LatestDIdUpdated, LatestDateUpdated)
values
  ('Hypertension', 'Dizziness', 'High Blood Pressure', 1, 3, '2024-12-29 15:30:00'),
  ('Diabetes', 'Thirst', 'Type 2 Diabetes', 2, 1, '2024-12-27 10:30:00'),
  ('Cold', 'Sneezing', 'Common Cold', 3, 2, '2024-12-30 14:00:00'),
  ('Flu', 'Fever', 'Influenza', 4, 3, '2025-1-1 15:00:00'),
  ('Migraine', 'Headache', 'Severe Migraine', 5, 5,'2024-12-28 17:00:00'),
  ('Stroke', 'Sudden numbness and difficulty speaking', 'Hemorrhagic Stroke', 6, 4, '2024-12-31 15:00:00'),
  ('Heart Attack', 'Chest pain or pressure', 'NSTEMI', 7, 2, '2025-1-1 14:00:00'),
  ('Stroke', 'Loss of balance', 'Brain Stem Stroke', 8, 1, '2025-1-2 10:00:00'),
  ('Heart Attack', 'Shortness of breath', 'STEMI', 9, 4, '2025-1-2 14:00:00'),
  ('Rheumatoid Arthritis (RA)', 'Persistent joint pain and swelling', 'Seropositive RA (with specific antibodies)',10, 1, '2024-12-30 8:00:00')

--------------------------------------------------------------------------------------------------
--Insert records into ExaminePatient table
insert into ExamineInPatient (DID, InPID, date)
values 
	(1, 6, '2024-12-31 17:00:00'),
	(2, 10, '2024-12-31 14:00:00')

--------------------------------------------------------------------------------------------------
--Insert records into Drug table
insert into Drug (Code, Name, RecDosage) 
values 
	(120, 'Panadol', '500mg every 4-6 hours'),
	(121, 'Cataflam', '50mg 2-3 times a day'),
	(122, 'Insulin', '0.1 units/kg/hour IV infusion'),
	(123, 'Aliskiren', 'If Needed'),
	(124, 'Aspirin', '400mg every 4-6 hours'),
	(125, 'Digoxin', '500mg-1000mg every day'),
	(126, 'Voltaren', 'Not exceeding 100 mg per day')

----------------------------------------------------------------------------------------------------
--Insert records into Prescription table
insert into Prescription (PID, Description, LatestDIdUpdated, LatestDateUpdated)
values
	(1, 'Take Aliskiren 150mg If Needed', 3, '2024-12-29 15:30:00'),
	(2, 'Take Insulin 0.1 units/kg/hour IV infusion', 1, '2024-12-27 10:30:00'),
	(3, 'Take Panadol 350mg every 4-6 hours', 2, '2024-12-30 14:00:00'),
	(4, 'Take Panadol 400mg every 4-6 hours', 3, '2025-1-1 15:00:00'),
	(5, 'Take Cataflam 50mg 2-3 times a day', 5,'2024-12-28 17:00:00'),
	(6, 'Take Aspirin 400mg every 4-6 hours', 4, '2024-12-31 15:00:00'),
	(7, 'Take Digoxin 500mg every day for 5 days', 2, '2025-1-1 14:00:00'),
	(8, 'Take Aspirin 300mg every 4-6 hours', 1, '2025-1-2 10:00:00'),
	(9, 'Take Digoxin 700mg every day for 7 days', 4, '2025-1-2 14:00:00'),
	(10, 'Take Voltaren 100 mg once daily', 1, '2024-12-30 8:00:00')

--------------------------------------------------------------------------------------------------
--Insert records into Bill table
insert into Bill (Amount, PId, RID, Date)
values
  (150, 1, 11, '2024-12-29 15:30:00'),
  (200, 2, 12, '2024-12-27 10:30:00'),
  (300, 3, 12, '2024-12-30 14:00:00'),
  (400, 4, 11, '2025-1-1 15:00:00'),
  (500, 5, 13, '2024-12-28 17:00:00'),
  (10000, 6, 13, dateadd(day, 7, '2024-12-31 15:00:00')),
  (20000, 7, 12, dateadd(day, 5, '2025-1-1 14:00:00'))

------------------------------------------------------------------------------------------------
--Insert records into GivenDrug table
insert into GivenDrug (Dosage, GivenDate, DrugCode, Inpid, NID) 
values 
('400mg', dateadd(day, 1, '2024-12-31 15:00:00'), 124, 6, 6),
('300mg', dateadd(day, 2, '2024-12-31 15:00:00'), 120, 6, 6),
('350mg', dateadd(day, 3, '2024-12-31 15:00:00'), 124, 6, 7),
('500mg', dateadd(day, 1, '2025-1-1 14:00:00'), 125, 7, 7),
('400mg', dateadd(day, 2, '2025-1-1 14:00:00'), 120, 7, 7),
('300mg', dateadd(day, 1, '2025-1-2 10:00:00'), 124, 8, 8),
('700mg', dateadd(day, 1, '2025-1-2 14:00:00'), 125, 9, 9),
('100mg', dateadd(day, 1, '2024-12-30 8:00:00'), 126, 10, 10)

