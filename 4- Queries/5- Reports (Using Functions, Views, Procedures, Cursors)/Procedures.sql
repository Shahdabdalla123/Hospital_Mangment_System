use Hospital

--------------------------------------------------------------------------------------------------
--GeneratePatientReport proc
--Generates a report of patient care details based on the provided patient ID
go
create or alter procedure SP_GeneratePatientReport @PatientID int
with encryption 
as
begin
    select * from V_PatientCareDetails vp
	where vp.PatientID = @PatientID
end

--Execution Example
go
exec SP_GeneratePatientReport @PatientID = 12

--------------------------------------------------------------------------------------------------
--CheckPatientStatus proc
--Checks the status of a patient (whether inpatient, outpatient, or discharged)
go
create or alter procedure SP_CheckPatientStatus @PatientID int
with encryption 
as
begin
    -- Check if the patient exists as an inpatient still in the hospital
    if exists (
        select 1 
        from V_InpatientsStillInHospital
        where PatientID = @PatientID
    )
    begin
        select 'The patient is still in the hospital.' as Status,* 
		from Fun_GetPatientData(@PatientID)
    end
    else if exists (
        select 1 
        from V_AllPatients
        where PatientID = @PatientID and PatientType = 'OutPatient'
    )
    begin
        select 'The patient is an outpatient' as Status, * 
		from Fun_GetPatientData(@PatientID)

    end
    else if exists (
        select 1 
        from V_AllPatients
        where PatientID = @PatientID and PatientType = 'InPatient'
    )
    begin
        select 'The patient is an inpatient but has been discharged.' as Status, * 
		from Fun_GetPatientData(@PatientID)
    end
    else
    begin
        select 'The patient ID does not exist in the system.' as Status
    end
end

--Execution Example
go
exec SP_CheckPatientStatus @PatientID = 7
go
exec SP_CheckPatientStatus @PatientID = 9
go
exec SP_CheckPatientStatus @PatientID = 5

--------------------------------------------------------------------------------------------------
--GetInpatientStayDetails proc
--Retrieves inpatient stay duration details for the specified patient ID
go
create or alter procedure SP_GetInpatientStayDetails @PatientID int
with encryption 
as
begin
    -- Check if the patient is an inpatient
    if exists (
        select 1
        from V_AllPatients
        where PatientID = @PatientID and PatientType = 'InPatient'
    )
    begin
        -- Call the view for the specific inpatient
        select *
        from V_InpatientStayDuration
        where PatientID = @PatientID
    end
    else
    begin
        -- Return a message indicating the patient is not an inpatient
        select 'The specified patient is not an inpatient.' as Message
    end
end

--Execution Example
go
exec SP_GetInpatientStayDetails @PatientID = 7
go
exec SP_GetInpatientStayDetails @PatientID = 9
go
exec SP_GetInpatientStayDetails @PatientID = 5

--------------------------------------------------------------------------------------------------
--GetPatients proc
--Retrieves patient records filtered by patient type (all, in-patient, or out-patient)
go
create or alter procedure SP_GetPatients @PatientType varchar(10)
with encryption 
as
begin
    if @PatientType = 'all'
    begin
        select * from V_AllPatients
    end

    else if @PatientType = 'in'
    begin
        select * from V_InPatients
    end

    else if @PatientType = 'out'
    begin
        select * from V_OutPatients
    end

    else
    begin
        print 'Invalid Patient Type! Use "all", "in", or "out".'
    end
end

--Execution Example
go
-- To get all patients (both in and out)
exec SP_GetPatients @PatientType = 'all'
go
-- To get only in-patients
exec SP_GetPatients @PatientType = 'in'
go
-- To get only out-patients
exec SP_GetPatients @PatientType = 'out'

-------------------------------------------------------------------------------------------------------
--GetBillsWithRanking proc
--Retrieves bills for patients sorted by amount with ranking based on the provided patient type
go
create or alter procedure SP_GetBillsWithRanking @num int, @type char(20)
with encryption 
as
begin
    if @type not in ('InPatient', 'OutPatient')
    begin
        print 'Invalid patient type. Use ''InPatient'' for inpatient or ''OutPatient'' for outpatient.'
        return
    end

    select *
    from 
    (
        select B.*, P.*,
            dense_rank() over (order by B.Amount desc) as RankByAmount
        from Bill B
        inner join V_AllPatients P on B.PId = P.PatientID 
        where P.PatientType = @type
    ) as RankedBills
    where RankByAmount <= @num
    order by RankByAmount
end

--Execution Example
go
exec SP_GetBillsWithRanking @num = 3, @type = 'InPatient'
go
exec SP_GetBillsWithRanking @num = 5, @type = 'OutPatient'

--------------------------------------------------------------------------------------------------
--GetBillStatistics proc
--Computes average and maximum bill amounts for inpatient and outpatient types
go
create or alter procedure SP_GetBillStatistics
with encryption 
as
begin
    select 
        isnull(avg(case when P.PType = 'I' then B.Amount end), 0) as AvgInpatientBill,
        isnull(avg(case when P.PType = 'O' then B.Amount end), 0) as AvgOutpatientBill,
        isnull(max(case when P.PType = 'I' then B.Amount end), 0) as MaxInpatientBill,
        isnull(max(case when P.PType = 'O' then B.Amount end), 0) as MaxOutpatientBill
    from Bill B
    inner join Patient P on B.PId = P.Id
end

--Execution Example
go
exec SP_GetBillStatistics

--------------------------------------------------------------------------------------------------
-- GetGivenDrugForPatient proc
--Retrieves a list of medications given to a specified patient, ordered by the given 

go
create or alter procedure SP_GetGivenDrugForPatient @PatientID int
with encryption 
as
begin
	select * 
	from V_MedicationPrescription 
	where PatientId=@PatientID
	order by GivenDate desc
end

--Execution Example
go
exec SP_GetGivenDrugForPatient 12

--------------------------------------------------------------------------------------------------
-- GetPatientsDoctorInChargeOf proc
--Retrieves a list of patients managed by a specific doctor
go
create or alter procedure SP_GetPatientsDoctorInChargeOf @DocID int
with encryption 
as
begin
	select * 
	from V_AllPatients 
	where DoctorInChargeid=@DocID
end

--Execution Example
go
exec SP_GetPatientsDoctorInChargeOf 3

--------------------------------------------------------------------------------------------------
--GetExaminedPatientsByDoctor proc
--Retrieves a list of patients examined by a specific doctor
go
create or alter procedure  SP_GetExaminedPatientsByDoctor @DocID int
with encryption 
as
begin
	select P.PatientID, P.FullName as ExaminedPatientFullName
	from ExamineInPatient EI 
	inner join V_AllPatients P on EI.InPID = P.PatientID
	where EI.DID=@DocID
end

--Execution Example
go
exec SP_GetExaminedPatientsByDoctor 1

--------------------------------------------------------------------------------------------------
--GetPatientsInRoom proc
--Retrieves a list of patients currently in a specified room
go
create or alter procedure SP_GetPatientsInRoom @RoomID varchar(max) 
with encryption 
as
begin
	select * 
	from V_AllPatients V  
	where RoomNumber = @RoomID
end

--Execution Example
go
exec SP_GetPatientsInRoom @RoomID = '103'

--------------------------------------------------------------------------------------------------
--GetAppointmentForDocto proc
--Retrieves appointment summaries for a specified doctor, ordered by date
go
create or alter procedure SP_GetAppointmentForDoctor @DocID int
with encryption 
as
begin
	select * 
	from V_AppointmentSummary V 
	Where DoctorId=@DocID
	order by AppointmentDate desc
end

--Execution Example
go
exec SP_GetAppointmentForDoctor 3

--------------------------------------------------------------------------------------------------
--NumOfDoctorPatients proc
--Retrieves the number of patients with appointments for a doctor within a given timeframe
go
create or alter procedure SP_NumOfDoctorPatients @StartDate datetime2, @EndDate datetime2
with encryption 
as
begin
    select E.FName + ' ' + E.LName as FullName, 
	count(A.PId) as PatientCount
    from Appointment A inner join Employee E ON A.DId = E.Id
    inner join Patient P ON A.PId = P.Id
    where A.Date between @StartDate and @EndDate
    group by E.FName + ' ' + E.LName
end

--Execution Example
go
exec SP_NumOfDoctorPatients @StartDate='2024-12-27 9:30:00.00' , @EndDate='2024-12-31 05:00:00.00'

-------------------------------------------------------------------------------------------------------
--GetEmployees proc
--Retrieves a list of employees filtered by type (doctor, nurse, receptionist, etc.)
go
create or alter procedure SP_GetEmployees @EmpType varchar(10)
with encryption 
as
begin
    if @EmpType = 'all'
    begin
        select * from V_AllEmployees
    end

    else if @EmpType = 'd'
    begin
        select * from V_Doctors
    end

    else if @EmpType = 'n'
    begin
        select * from V_Nurses
    end
	else if @EmpType = 'r'
    begin
        select * from V_Receptionists
    end
	else if @EmpType = 'other'
    begin
        select * from V_EmployeesWithOtherTypes
    end

    else
    begin
        print 'Invalid Patient Type! Use "all", "d", or "n" , or "r" , or "other".'
    end
end

--Execution Example
go
-- To get all Employees 
exec SP_GetEmployees @EmpType = 'all'
go
-- To get only doctors
exec SP_GetEmployees @EmpType = 'd'
go
-- To get only nurses
exec SP_GetEmployees @EmpType = 'n'
go
-- To get only receptionists
exec SP_GetEmployees @EmpType = 'r'
go
-- To get employees with other types
exec SP_GetEmployees @EmpType = 'other'

-------------------------------------------------------------------------------------------------------
--TopRankedEmployeesByType proc
--Retrieves the top-ranked employees by salary, filtered by employee type
go
create or alter procedure SP_TopRankedEmployeesByType @TopCount int, @EmpType varchar(20)
with encryption 
as
begin
    -- Handle invalid employee type
    if @EmpType not in ('Doctor', 'Nurse', 'Receptionist', 'Unknown')
    begin
        print 'Invalid employee type. Use ''Doctor'', ''Nurse'', ''Receptionist'', or ''Unknown''.'
        return
    end

    -- Query with filtering
    select * 
    from (
        select E.*, 
               dense_rank() over (order by E.Salary desc) as RankBySalary
        from V_AllEmployees E
        where E.EmployeeType = @EmpType
    ) as RankedEmployees
    where RankBySalary <= @TopCount
    order by RankBySalary
end

--Execution Example
go
exec SP_TopRankedEmployeesByType @TopCount = 5, @EmpType = 'Doctor'
go
exec SP_TopRankedEmployeesByType @TopCount = 4, @EmpType = 'Nurse'
go
exec SP_TopRankedEmployeesByType @TopCount = 3, @EmpType = 'Receptionist'
go
exec SP_TopRankedEmployeesByType @TopCount = 2, @EmpType = 'Unknown'

