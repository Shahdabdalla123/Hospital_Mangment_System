use Hospital

--------------------------------------------------------------------------------------------------------------------
--DeleteAppointment proc
--Deletes an appointment by its ID if it exists in the Appointment table
go
create or alter procedure SP_DeleteAppointment @appointmentId int
with encryption 
as 
begin
   begin try
       begin transaction
	    if not exists (select 1 from Appointment where Id = @appointmentId)
        begin
            print 'error: the Appointment id does not exist in the Appointment table'
			rollback transaction
            return
        end
		delete from Appointment
        where Id = @appointmentId
		commit transaction
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while deleting the appointment: ' + ERROR_MESSAGE()
    end catch
end

--Execution Example
go
exec SP_DeleteAppointment @appointmentId=1014

--------------------------------------------------------------------------------------------------------------------
--DeletePatient proc
--Deletes a patient by their ID if they exist in the Patient table
go
create or alter procedure SP_DeletePatient @PatientId int
with encryption 
as
begin
    begin try
        begin transaction

        if not exists (select 1 from Patient where Id = @PatientId)
        begin
            print 'Error: Patient ID does not exist in the Patient table.'
            rollback transaction
            return
        end

        delete from Patient where Id = @PatientId

        commit transaction
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while deleting the patient: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_DeletePatient @PatientId=11
go
exec SP_DeletePatient @PatientId=12

--------------------------------------------------------------------------------------------------------------------
--DeleteInPatient proc
--Deletes an inpatient and associated patient record from the InPatient and Patient tables
go
create or alter procedure SP_DeleteInPatient @InPatientId int
with encryption 
as
begin
    begin try
        begin transaction

        if not exists (select 1 from InPatient where Id = @InPatientId)
        begin
            print 'Error: InPatient ID does not exist in the InPatient table.'
            rollback transaction
            return
        end

        delete from InPatient where Id = @InPatientId
        delete from Patient where Id = @InPatientId

        commit transaction
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while deleting the InPatient: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_DeleteInPatient @InPatientId=12

--------------------------------------------------------------------------------------------------------------------
--DeleteOutPatient proc
--Deletes an outpatient and associated patient record from the OutPatient and Patient tables
go
create or alter procedure SP_DeleteOutPatient @OutPatientId int
with encryption 
as
begin
    begin try
        begin transaction

        if not exists (select 1 from OutPatient where Id = @OutPatientId)
        begin
            print 'Error: OutPatient ID does not exist in the OutPatient table.'
            rollback transaction
            return
        end

        delete from OutPatient where Id = @OutPatientId
        delete from Patient where Id = @OutPatientId

        commit transaction
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while deleting the OutPatient: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_DeleteOutPatient @OutPatientId=11

--------------------------------------------------------------------------------------------------------------------
--DeletePrescription proc
--Deletes a prescription by its ID from the Prescription table
go
create or alter proc SP_DeletePrescription @Id int
with encryption 
as 
begin
	 begin try
	  delete from  Prescription
	  where Id=@Id
	  if @@ROWCOUNT = 0
		begin
		  print 'No rows were Deleted. Prescription number might not exist.'
		end
    else
		begin
			  print 'Prescription record deleted successfully'
		end

	 end try
	 begin catch
	   print 'Error deleting Prescription record: ' + ERROR_MESSAGE()
	 end catch
end

--Execution Example
go
exec SP_DeletePrescription 10

--------------------------------------------------------------------------------------------------------------------
--DeleteReport proc
--Deletes a report by its ID from the Report table
go
create or alter proc SP_DeleteReport @Id int
with encryption 
as 
begin
    begin try
	 delete from Report 
	 where Id = @Id

	 if @@ROWCOUNT = 0
    begin
      print 'No rows were Deleted. Report number might not exist.'
    end
    else
    begin
      print 'Report record deleted successfully'
    end

	end try
	begin catch
	    print 'Error deleting Report record: ' + ERROR_MESSAGE()
	end catch
end

--Execution Example
go
exec SP_DeleteReport 11

--------------------------------------------------------------------------------------------------------------------
--DeleteBill proc
--Deletes a bill by its ID from the Bill table
go
create proc SP_DeleteBill @Id int
with encryption 
as 
begin 
	 begin try
		delete from Bill
		where  Id = @Id
		if @@ROWCOUNT = 0
    begin
      print 'No rows were Deleted. Bill number might not exist.'
    end
    else
    begin
		print 'Bill record deleted successfully'

    end
	 end try
	 begin catch
	 print 'Error deleting Bill record: ' + ERROR_MESSAGE()
	 end catch
end

--Execution Example
go
exec SP_DeleteBill 12

--------------------------------------------------------------------------------------------------------------------
--DeleteRoom proc
--Deletes a room by its number from the Room table
go
create or alter proc SP_DeleteRoom @Num int
with encryption 
as
begin 
	 begin try
		delete from Room 
		where Num = @Num
		 if @@ROWCOUNT = 0
    begin
      print 'No rows were Deleted. Room number might not exist.'
    end
    else
    begin
      print 'Room record Deleted successfully'
    end
	 end try
	 begin catch
	 print 'Error deleting Room record: ' + ERROR_MESSAGE()
	 end catch
 end

--Execution Example
go
exec SP_DeleteRoom 100
 
--------------------------------------------------------------------------------------------------------------------
--DeleteRoom proc
--Deletes a drug by its code from the Drug table if it exists
go
create or alter procedure SP_DeleteDrug @code int 
with encryption 
as 
	if exists(select * from Drug where Code=@code) 
		delete Drug where Code=@code
	else
		print 'Error While Deleting This Record Not Found'
  
--Execution Example
go
exec SP_DeleteDrug 120

--------------------------------------------------------------------------------------------------------------------
--DeleteExaminePatient proc
--Deletes an examination record for a patient if it exists in the ExamineInPatient table
go
create or alter procedure SP_DeleteExaminePatient @DID int,@PID int
with encryption 
as
	if exists (select * from ExamineInPatient where InPID=@PID and DID=@DID ) 
		Delete from ExamineInPatient where InPID=@PID and DID=@DID 
	else
		print 'Error While Deleting This Record Not Found'
   
--Execution Example
go
exec SP_DeleteExaminePatient 1,8

--------------------------------------------------------------------------------------------------------------------
--DeleteGivenDrug proc
--Deletes a given drug record for a patient from the GivenDrug table if it exists
go
create or alter procedure SP_DeleteGivenDrug @code int,@inpid int,@NID int
with encryption 
as
	if exists (select * from GivenDrug where DrugCode = @code and Inpid=@inpid and NID=@NID)
		Delete from GivenDrug where  DrugCode = @code and Inpid=@inpid and NID=@NID  
	else
		print 'Error While Deleting This Record Not Found'
 
--Execution Example
go
exec SP_DeleteGivenDrug 125,7,7


