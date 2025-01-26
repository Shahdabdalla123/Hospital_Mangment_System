Use Hospital

--------------------------------------------------------------------------------------------------
--Department table
create table Department
(
    Id int identity(100,1) primary key,
    Name varchar(100) not null unique
)

--------------------------------------------------------------------------------------------------
--Employee table
go
create table Employee 
(
    Id int identity(1,1) primary key,
    EmpType char(1) check (EmpType in ('D', 'N', 'R')), -- restrict to D, N, or R
    Fname varchar(50) not null,
    Lname varchar(50) not null,
	DOB date not null check (DOB <= getdate() and year(getdate()) - year(DOB) >= 18),
    Phone varchar(15) not null unique,
    Salary money not null check(Salary > 0),
	Gender char(1) not null check (Gender in ('M', 'F')),    -- restrict to M, F
    Street varchar(100),
    City varchar(50) default 'Cairo',
    State varchar(50) default 'Egypt',
    DeptID int not null foreign key references Department(id),
)

--------------------------------------------------------------------------------------------------
--Doctor table
go
create table Doctor
(
    Id int primary key foreign key references Employee(id),
    Speciality nvarchar(100) not null
)

--------------------------------------------------------------------------------------------------
--Nurse table
go
create table Nurse 
(
    Id int primary key foreign key references Employee(id)
)

--------------------------------------------------------------------------------------------------
--Receptionist table
go
create table Receptionist 
(
    Id int primary key foreign key references Employee(id)
)

--------------------------------------------------------------------------------------------------
--Room Table
go
Create Table Room 
(
	Num int primary key identity (100,1),
	MaxCapacity int not null check(MaxCapacity >= 0),
	CurrentCapacity int check(CurrentCapacity >= 0),
	NId int foreign key references Nurse(Id)
)

--------------------------------------------------------------------------------------------------
--Patient Table
go
create table Patient
(
	Id int primary key identity(1,1),
	PType varchar(1) check (PType in ('I', 'O')),
	FName varchar(50) not null,
	LName varchar(50),
	DOB date check (DOB <= getdate()),
	Phone varchar(15) not null,
	Gender varchar(1) check (Gender in ('M', 'F')),
	Street varchar(50),
	City varchar(50) default 'Cairo',
	State varchar(50) default 'Egypt',
	DId int foreign key references Doctor(Id)
)

--------------------------------------------------------------------------------------------------
--InPatient Table
go
create table InPatient
(
	Id int primary key foreign key references Patient(Id),
	RoNum int foreign key references Room(Num) not null
)

--------------------------------------------------------------------------------------------------
--OutPatient Table
go
create table OutPatient
(
	Id int primary key foreign key references Patient(Id)
)

--------------------------------------------------------------------------------------------------
--Appointment Table
go
create table Appointment
(
	Id int primary key identity(1000,1),
	Date datetime2 not null default getdate(),
	Note varchar(100),
	Status varchar(20) not null check (Status in ('Assigned', 'Done' ,'Cancelled')) default 'Assigned',
	DId int not null foreign key references Doctor(Id),
	PId int not null foreign key references Patient(Id) unique,
	RId int not null foreign key references Receptionist(Id)
)

--------------------------------------------------------------------------------------------------
--Drug Table
go
create table Drug
(
	Code int primary key,
	Name varchar(50) not null,
	RecDosage varchar(50)
)

--------------------------------------------------------------------------------------------------
--Report Table
go
Create Table Report
(
	Id int primary key identity (10,1),
	Disease varchar(100) not null,
	Symptom  varchar(100) not null,
	Diagnosis varchar(100) not null,
	PId int not null foreign key references Patient(Id) unique,
	LatestDIdUpdated int not null foreign key references Doctor(Id),
	LatestDateUpdated datetime2 default getdate()
)

--------------------------------------------------------------------------------------------------
--ReportDoctor Table
go
create Table ReportDoctor 
(
    RepID int foreign key references Report(Id),
	DId int foreign key references Doctor(Id),
	Date datetime2 default getdate(),
	ActionMade VARCHAR(10),
	constraint Report_Doctor_PK primary Key(RepID, DId, Date)
)

--------------------------------------------------------------------------------------------------
--Prescription Table
go
create table Prescription
(
	Id int primary key identity (10,1),
	Description varchar(max) not null,
	PID int not null foreign key references Patient(Id) unique,
	LatestDIdUpdated int not null foreign key references Doctor(Id),
	LatestDateUpdated datetime2 default getdate()
)

--------------------------------------------------------------------------------------------------
--PrescriptionDoctor Table
go
create Table PrescriptionDoctor 
(
    PreID int foreign key references Prescription(Id),
	DId int foreign key references Doctor(Id),
	Date datetime2 default getdate(),
	ActionMade VARCHAR(10),
	constraint Prescription_Doctor_PK primary Key(PreID, DId, Date)
)

--------------------------------------------------------------------------------------------------
--Bill Table
go
Create Table Bill
(
	Id int primary key identity (10,1),
	Date datetime2 not null default getDate(),
	Amount money not null,
	PId int not null foreign key references Patient(Id) unique,
	RID int not null foreign key references Receptionist(Id)
)

--------------------------------------------------------------------------------------------------
--ExaminePatient Table
go
create Table ExamineInPatient 
(
    DID int foreign key references Doctor(Id),
    InPID int foreign key references InPatient(Id),
	date datetime2 default getdate(),
	constraint E_Patient_PK primary Key(DID, InPID, date)
)

--------------------------------------------------------------------------------------------------
--GivenDrug Table
go
create Table GivenDrug 
(
    Dosage varchar(50) not null,
	GivenDate datetime2 default getdate(),
    DrugCode int foreign key references Drug(code),
	Inpid int foreign key references InPatient(Id),
    NID int foreign key references Nurse(Id),
	constraint Give_Drug_PK primary Key(GivenDate, DrugCode, Inpid, NID)
)