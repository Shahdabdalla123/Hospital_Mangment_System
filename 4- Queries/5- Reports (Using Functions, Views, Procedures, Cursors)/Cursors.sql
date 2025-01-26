use Hospital

--------------------------------------------------------------------------------------------------
--Cursor for show name of Patient, name of nurse, and number of times patient dealed with this nurse
go
declare @PatientName varchar(50), @NurseName varchar(50), @NumOfTimesDealWithThisNurse int

declare PatientNurseCursor cursor 
for
	select  P.FullName as PatientName, 
			N.FullName as NurseName, 
			Count(*) as NumOfTimesDealWithThisNurse
	from GivenDrug GD
	inner join V_AllPatients P ON GD.InPID = P.PatientID
	inner join V_Nurses N ON GD.NID = N.EmployeeID
	group by P.PatientID, P.FullName,N.EmployeeID, N.FullName
	order by PatientName, NurseName

open PatientNurseCursor

fetch next from PatientNurseCursor into @PatientName, @NurseName, @NumOfTimesDealWithThisNurse

while @@FETCH_STATUS = 0
begin
	select 
		@PatientName as Patient, 
		@NurseName as Nurse,
		@NumOfTimesDealWithThisNurse as NumOfTimesDealWithThisNurse
	
	fetch next from PatientNurseCursor into @PatientName, @NurseName, @NumOfTimesDealWithThisNurse
end

close PatientNurseCursor
Deallocate PatientNurseCursor

--------------------------------------------------------------------------------------------------
----Cursor for show drug details
go
declare @Code varchar(10), @DrugName varchar(20), @recdosage varchar(30)

declare DrugCursor cursor 
for
	select * from Drug

open DrugCursor

fetch DrugCursor into @Code, @DrugName, @recdosage

while @@FETCH_STATUS = 0
begin
    select 
		@Code as DrugCode,
		@DrugName as DrugName,
		@recdosage as RecommendedDosage
    
	fetch DrugCursor into @Code, @DrugName, @recdosage
end

close DrugCursor

deallocate DrugCursor
