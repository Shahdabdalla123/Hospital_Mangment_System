use Hospital

--------------------------------------------------------------------------------------------------
--CalculateAge function
--A function that calculates a patient's age based on their date of birth
go
create or alter function Fun_CalculateAge (@DOB date)
returns int
with encryption 
as
begin
    declare @Age int
    set @Age = datediff(year, @DOB, getdate()) 
               - case 
                   when month(@DOB) > month(getdate()) 
                        or (month(@DOB) = month(getdate()) and day(@DOB) > day(getdate())) 
                   then 1 
                   else 0 
                 end
    return @Age
end

--------------------------------------------------------------------------------------------------
--GetPatientData function
--A function that retrieves a patient's data based on their PatientID
go
create or alter function Fun_GetPatientData (@PatientID int)
returns table
with encryption 
as
return
(
    select *
    from V_AllPatients
    where PatientID = @PatientID
)

--Call Example
go
select * from Fun_GetPatientData(12)

--------------------------------------------------------------------------------------------------
--GetPatientDataByPhone function
--A function that retrieves a patient's data based on their phone number
go
create or alter function Fun_GetPatientDataByPhone (@Phone varchar(15))
returns table
with encryption 
as
return
(
    select *
    from V_AllPatients
    where PhoneNumber = @Phone
)

--Call Example
go
select * from Fun_GetPatientDataByPhone('0101876543')

--------------------------------------------------------------------------------------------------
--GetPatientDataByFullName function
--A function that retrieves a patient's data based on their full name (partial match)
go
create or alter function Fun_GetPatientDataByFullName (@FullName varchar(100))
returns table
with encryption 
as
return
(
    select *
    from V_AllPatients
    where FullName like '%' + @FullName + '%'
)

--Call Example
go
select * from Fun_GetPatientDataByFullName('ahmed')

--------------------------------------------------------------------------------------------------
--GetExamineDoctorsForPatient function
--A function that retrieves the list of doctors who have examined a specific inpatient
go
create or alter function Fun_GetExamineDoctorsForPatient(@inpid int)
returns table  
with encryption 
as
return 
(
	select Distinct E.Fname +' '+ E.Lname As MY_DocterName
	from ExamineInPatient EI 
	inner join Employee E on E.Id=EI.DID 
	where EI.InPID=@inpid
)

--Call Example
go
select * from Fun_GetExamineDoctorsForPatient(6)
go
select * from Fun_GetExamineDoctorsForPatient(12)

--------------------------------------------------------------------------------------------------
--GetMaxDrugUsedForPatient function
--A function that retrieves the top used drugs for a specific patient based on dosage count
go
create or alter function Fun_GetMaxDrugUsedForPatient (@Pid int, @topNum int)
returns table
with encryption 
as
return 
(
  select top (@topNum) with ties Dosagecount As MaxUsageDrug ,
  DrugCode, Name
  from V_CountGivenDrugByPatient 
  where PatientId=@Pid
  order by DosageCount desc
)

--Call Example
go
select * from Fun_GetMaxDrugUsedForPatient(6,2)
go
select * from Fun_GetMaxDrugUsedForPatient(10,1)

--------------------------------------------------------------------------------------------------
--GetAppointmentSummaryForPatient function
--A function that retrieves the appointment summary for a specific patient
go
create or alter function Fun_GetAppointmentSummaryForPatient(@PatientID int)
returns table
with encryption 
as
return
(
    select *
    from V_AppointmentSummary
    where PatientID = @PatientID
)

--Call Example
go
select * from Fun_GetAppointmentSummaryForPatient(12)

--------------------------------------------------------------------------------------------------
--GetPrescriptionSummaryForPatient function
--A function that retrieves the prescription summary for a specific patient
go
create or alter function Fun_GetPrescriptionSummaryForPatient (@PatientID int)
returns table
with encryption 
as
return
(
    select *
    from V_PrescriptionSummary
    where PatientID = @PatientID
)

--Call Example
go
select * from Fun_GetPrescriptionSummaryForPatient(12)

--------------------------------------------------------------------------------------------------
--GetReportSummaryForPatient function
--A function that retrieves the report summary for a specific patient
go
create or alter function Fun_GetReportSummaryForPatient (@PatientID int)
returns table
with encryption 
as
return
(
    select *
	from V_ReportSummary
    where PatientID = @PatientID
)

--Call Example
go
select * from Fun_GetReportSummaryForPatient(12)

--------------------------------------------------------------------------------------------------
--GetBillSummaryForPatient function
--A function that retrieves the billing summary for a specific patient
go
create or alter function Fun_GetBillSummaryForPatient(@PatientID int)
returns table
with encryption 
as
return
(
    select *
	from V_BillSummary
    where PatientID = @PatientID
)

--Call Example
go
select * from Fun_GetBillSummaryForPatient(12)

--------------------------------------------------------------------------------------------------
--GetRoomsSummary function
--A function that retrieves the summary for a specific room based on its number
go
create or alter function Fun_GetRoomsSummary (@RoomNum int)
returns table
with encryption 
as
return
(
    select *
	from V_RoomsSummary
    where RoomNumber = @RoomNum
)

--Call Example
go
select * from Fun_GetRoomsSummary(102)

--------------------------------------------------------------------------------------------------
--GetDrugData function
--A function that retrieves the data for a specific drug based on its code
go
create or alter function Fun_GetDrugData (@c int)
returns table  
with encryption 
as
return 
(
	select D.Code, D.Name, D.RecDosage as RecommendedDosage
	from Drug D
	where Code=@c
)

--Call Example
go
select * from Fun_GetDrugData(127)

--------------------------------------------------------------------------------------------------
--GetEmployeeData function
--A function that retrieves employee data based on their EmployeeID
go
create or alter function Fun_GetEmployeeData (@EmployeeID int)
returns table
with encryption 
as
return
(
    select *
    from V_AllEmployees
    where EmployeeID = @EmployeeID
)

--Call Example
go
select * from dbo.Fun_GetEmployeeData(11)
select * from dbo.Fun_GetEmployeeData(1)
select * from dbo.Fun_GetEmployeeData(6)
select * from dbo.Fun_GetEmployeeData(17)

--------------------------------------------------------------------------------------------------
--GetEmployeeDataByPhone function
--A function that retrieves employee data based on their phone number
go
create or alter function Fun_GetEmployeeDataByPhone (@Phone varchar(15))
returns table
with encryption 
as
return
(
    select *
    from V_AllEmployees
    where PhoneNumber = @Phone
)

--Call Example
go
select * from Fun_GetEmployeeDataByPhone('0123454321')

--------------------------------------------------------------------------------------------------
--GetEmployeeDataFullName function
--A function that retrieves employee data based on their full name (partial match)
go
create or alter function Fun_GetEmployeeDataByFullName (@FullName varchar(100))
returns table
with encryption 
as
return
(
    select *
    from V_AllEmployees
    where FullName like '%' + @FullName + '%'
)

--Call Example
go
select * from Fun_GetEmployeeDataByFullName('ahmed')


