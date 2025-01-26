use Hospital

--------------------------------------------------------------------------------------
--ChangeStatusInsteadOfDeleteAppointment Trigger
go
create or alter trigger Trg_ChangeStatusInsteadOfDeleteAppointment
on Appointment
instead of delete
as
begin
    begin try
        update Appointment set Status = 'Cancelled' where Id=(select id from deleted)
    end try
    begin catch
        print 'Error occurred during trigger execution '+ error_message()
    end catch
end
--------------------------------------------------------------------------------------------------------------------
--PreventDeletePatient Trigger
go
create or alter trigger Trg_PreventDeletePatient
on Patient
instead of delete
as
begin
    print 'Error: Deleting records from the Patient table is not allowed.'
end

--------------------------------------------------------------------------------------------------------------------
--PreventDeleteInPatient Trigger
go
create or alter trigger Trg_PreventDeleteInPatient
on InPatient
instead of delete
as
begin
    print 'Error: Deleting records from the InPatient table is not allowed.'
end


--------------------------------------------------------------------------------------------------------------------
--PreventDeleteOutPatient Trigger
go
create or alter trigger Trg_PreventDeleteOutPatient
on OutPatient
instead of delete
as
begin
    print 'Error: Deleting records from the OutPatient table is not allowed.'
end

--------------------------------------------------------------------------------------------------------------------
--PreventDeletePrescription Trigger
go
Create or alter Trigger Trg_PreventDeletePrescription
on Prescription
instead of delete
as
begin
    Print 'Deletion of prescriptions is not allowed.'
	  rollback transaction
end

--------------------------------------------------------------------------------------------------------------------
--PreventDeleteReport Trigger
go
Create or alter Trigger Trg_PreventDeleteReport
on Report
instead of delete
as
begin
    Print 'Deletion of Report is not allowed.'
	  rollback transaction
end

--------------------------------------------------------------------------------------------------------------------
--PreventDeleteBill Trigger
go
Create or alter Trigger Trg_PreventDeleteBill
on Bill
instead of delete
as
begin
    Print 'Deletion of Bill is not allowed.'
	  rollback transaction
end

--------------------------------------------------------------------------------------------------------------------
--PreventDeleteRoom Trigger
go
Create or alter Trigger Trg_PreventDeleteRoom
on Room
instead of delete
as
begin
    Print 'Deletion of Room is not allowed.'
	  rollback transaction
end

--------------------------------------------------------------------------------------------------------------------
--PreventDeleteDrug Trigger
go
Create or alter trigger Trg_PreventDeleteDrug
on Drug
instead of delete
as
  print 'Error While Deleting You Are not Allowed To Delete From This Table'

--------------------------------------------------------------------------------------------------------------------
--PreventDeleteGivenDrug Trigger
go
Create or alter trigger Trg_PreventDeleteGivenDrug
on GivenDrug
instead of delete
as
  print 'Error While Deleting You Are not Allowed To Delete From This Table'

--------------------------------------------------------------------------------------------------------------------
--PreventDeleteExaminePatient Trigger
go
Create or alter trigger Trg_PreventDeleteExaminePatient
on ExamineInPatient
instead of delete
as
  print 'Error While Deleting You Are not Allowed To Delete From This Table'

--------------------------------------------------------------------------------------------------------------------


