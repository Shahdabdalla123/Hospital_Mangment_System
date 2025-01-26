use Hospital

-- Index for Employee First Name
go
create index IX_Employee_Fname
on Employee (Fname);

-- Index for Employee Last Name
go
create index IX_Employee_Lname
on Employee (Lname);

-- Index for Patient First Name
go
create index idx_Patient_Fname 
on Patient(Fname);

-- Index for Patient Last Name
go
create index idx_Patient_Lname 
on Patient(Lname);

-- Index for Patient Phone
go
create unique index IX_Patient_Phone
on Patient (Phone);

-- Index for Drug Name
go
create nonclustered index IX_Drug_Name
on Drug (Name);

-- Index for Appointment Doctor Id
go
create nonclustered index IX_Appointment_DId
on Appointment (DId);


