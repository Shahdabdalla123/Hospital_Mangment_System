use Hospital

--------------------------------------------------------------------------------------------------
--UpdateRoomCapacityOnInsertPatient Trigger
--Adjusts CurrentCapacity when a patient is admitted, ensuring it doesn't exceed MaxCapacity
go
create or alter trigger Trg_UpdateRoomCapacityOnInsertPatient
on InPatient
after insert
as
begin
    begin try
        begin transaction

        update Room
        set CurrentCapacity = CurrentCapacity + 1
        from Room
        inner join inserted i
        on Room.Num = i.RoNum

        if exists (
            select 1
            from Room r
            where r.CurrentCapacity > r.MaxCapacity and r.Num = (select i.RoNum from inserted i)
        )
        begin
            rollback transaction
            print 'Error: CurrentCapacity exceeds MaxCapacity for one or more rooms.'
            return
        end

        commit transaction
        print 'Room capacity updated successfully for the newly admitted patient(s).'

    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while updating the room capacity: ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--UpdateRoomCapacityOnBillInsert Trigger
--Decreases CurrentCapacity when a bill is inserted for an inpatient discharge, ensuring it doesn't drop below zero
go
create or alter trigger Trg_UpdateRoomCapacityOnBillInsert
on Bill
after insert
as
begin
    begin try
        begin transaction
		
		declare @RoomNum int
        
		update Room
        set @RoomNum = r.Num , CurrentCapacity = CurrentCapacity - 1
        from Room r
        join InPatient ip on ip.RoNum = r.Num
        join inserted i on ip.Id = i.PId
        where exists (
            select 1 
            from Patient p 
            where p.Id = i.PId and p.PType = 'I'
        )

        if exists (
            select 1
            from Room r
            where r.CurrentCapacity < 0 and r.Num = @RoomNum
        )
        begin
            rollback transaction
            print 'Error: CurrentCapacity cannot be less than zero.'
            return
        end

        declare @RowsAffected int
        set @RowsAffected = @@ROWCOUNT

        commit transaction

        if @RowsAffected > 0
        begin
            print cast(@RowsAffected as varchar) + ' room capacity updated successfully.'
        end

    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while updating the room capacity: ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--RestrictUpdateRoomForInPatient Trigger
--Handles room changes for inpatients while checking capacity constraints and bill conditions
go
create or alter trigger Trg_RestrictUpdateRoomForInPatient
on InPatient
instead of update
as
begin
    begin try
		declare @OldRoomNum int, @NewRoomNum int, @PatientId int
		select @OldRoomNum = RoNum, @PatientId = Id from deleted
		select @NewRoomNum = RoNum from inserted

		if exists (select 1 from Bill b where b.PId = @PatientId)
		begin
			print 'Error: The patient has left hospital, and their room cannot be updated.'
			return
		end
        
		begin transaction

        update Room
        set CurrentCapacity = CurrentCapacity + 1
        from Room r
        where r.Num = @NewRoomNum

        if exists (
            select 1
            from Room r
            where r.CurrentCapacity > r.MaxCapacity and r.Num = @NewRoomNum
        )
        begin
            rollback transaction
            print 'Error: CurrentCapacity for new room exceeds MaxCapacity.'
            return
        end

		update Room
        set CurrentCapacity = CurrentCapacity - 1
        from Room r
        where r.Num = @OldRoomNum

        if exists (
            select 1
            from Room r
            where r.CurrentCapacity < 0 and r.Num = @OldRoomNum
        )
        begin
            rollback transaction
            print 'Error: CurrentCapacity for old room cannot be less than zero.'
            return
        end

		 -- If the patient does not have a bill or the room is not being changed, proceed with the update
		update InPatient
		set RoNum = @NewRoomNum
		where Id = @PatientId

        commit transaction
		print 'Room update performed successfully.'
    end try
    
	begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while updating the room: ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--CheckOutPatient Trigger
--Ensure patients can't be both inpatients and outpatients simultaneously
go
create or alter trigger Trg_CheckOutPatient
on OutPatient
instead of insert
as
begin
    -- Check if the patient is already an inpatient
    if exists (select 1 from InPatient where Id in (select Id from inserted))
    begin
        print 'Error: The patient is already an InPatient and cannot be an OutPatient at the same time.'
        return
    end
    
    insert into OutPatient (Id)
    select Id from inserted
end

--------------------------------------------------------------------------------------------------
--CheckInPatient Trigger
--Ensure patients can't be both inpatients and outpatients simultaneously
go
create or alter trigger Trg_CheckInPatient
on InPatient
instead of insert
as
begin
    -- Check if the patient is already an outpatient
    if exists (select 1 from OutPatient where Id in (select Id from inserted))
    begin
        print 'Error: The patient is already an OutPatient and cannot be an InPatient at the same time.'
        return
    end
    
    insert into InPatient (Id, RoNum)
    select Id, RoNum from inserted
end

--------------------------------------------------------------------------------------------------
--UpdatePatientTypeToInPatient Trigger
--Update patient types (PType) upon admission or discharge
go
create or alter trigger Trg_UpdatePatientTypeToInPatient
on InPatient
after insert
as
begin
    begin try
        update Patient
        set PType = 'I'
        from Patient
        inner join inserted i
        on Patient.Id = i.Id

        print 'Patient type updated to "I" for the newly inserted InPatient.'
    end try
    begin catch
        print 'An error occurred while updating Patient type to "I": ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--UpdatePatientTypeToOutPatient Trigger
--Update patient types (PType) upon admission or discharge
go
create or alter trigger Trg_UpdatePatientTypeToOutPatient
on OutPatient
after insert
as
begin
    begin try
        update Patient
        set PType = 'O'
        from Patient
        inner join inserted i
        on Patient.Id = i.Id

        print 'Patient type updated to "O" for the newly inserted OutPatient.'
    end try
    begin catch
        print 'An error occurred while updating Patient type to "O": ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--RestrictAppointmentUpdates Trigger
--Restricts updates to appointments with a specific status
go
create or alter trigger Trg_RestrictAppointmentUpdates
on Appointment
instead of update
as
begin
    begin try
        -- Check if the status of any updated rows is not "Assigned"
        if exists (
            select 1 
            from inserted i
            join Appointment a on i.Id = a.Id
            where a.Status != 'Assigned'
        )
        begin
            print 'Error: Updates are only allowed for appointments with status "Assigned".'
            return
        end

        -- Perform the update as no restrictions were violated
        update Appointment
        set 
            Note = i.Note,
            Status = i.Status,
            DId = i.DId,
            RId = i.RId
        from inserted i
        where Appointment.Id = i.Id

        print 'Appointment updated successfully.'
    end try
    begin catch
        print 'An error occurred while updating the appointment: ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--HandleAppointmentInsert Trigger
--Synchronize patient-doctor relationships based on appointment changes
go
create or alter trigger Trg_HandleAppointmentInsert
on Appointment
after insert
as
begin
    begin try
        if not exists (select 1 from inserted)
        begin
            print 'No appointments were affected. The appointment does not exist.'
            return
        end

        update Patient
        set DId = i.DId
        from Patient p
        join inserted i on p.Id = i.PId
		where i.Status != 'Cancelled'

        print 'Patient-Doctor relationships updated based on Appointment changes.'
    end try
    begin catch
        print 'An error occurred in the trigger: ' + error_message()
    end catch
end
go
--------------------------------------------------------------------------------------------------
--HandleAppointmentUpdates Trigger
--Synchronize patient-doctor relationships based on appointment changes
go
create or alter trigger Trg_HandleAppointmentUpdates
on Appointment
after update
as
begin
    begin try
        if not exists (select 1 from inserted)
        begin
            print 'No appointments were affected. The appointment does not exist.'
            return
        end

		update Patient
        set DId = i.DId
        from Patient p
        join deleted d on p.Id = d.PId
        join inserted i on d.Id = i.Id
        where d.Status = 'Assigned' and i.Status != 'Cancelled'

        update Patient
        set DId = null
        from Patient p
        join deleted d on p.Id = d.PId
        join inserted i on d.Id = i.Id
        where d.Status = 'Assigned' and i.Status = 'Cancelled'

        print 'Patient-Doctor relationships updated based on Appointment changes.'
    end try
    begin catch
        print 'An error occurred in the trigger: ' + error_message()
    end catch
end

--------------------------------------------------------------------------------------------------
--InsertExamineInPatientOnAppointment Trigger
--Insert examination records when appointments are completed
go
create or alter trigger Trg_InsertExamineInPatientOnAppointment
on Appointment
after insert
as
begin
    insert into ExamineInPatient (DID, InPID, date)
    select 
        i.DId, ip.Id, i.Date
    from 
        inserted i
    join Patient p on i.PId = p.Id
    join InPatient ip on p.Id = ip.Id
    where 
        i.Status = 'Done'

    -- Check if rows were affected
    if @@ROWCOUNT > 0
    begin
        print 'ExamineInPatient record inserted successfully for InPatients with completed appointments.'
    end
end

--------------------------------------------------------------------------------------------------
--InsertExamineInPatientOnUpdateAppointmentStatus Trigger
--Insert examination records when appointments are completed
go
create or alter trigger Trg_InsertExamineInPatientOnUpdateAppointmentStatus
on Appointment
after update
as
begin
    insert into ExamineInPatient (DID, InPID, date)
    select 
        i.DId, ip.Id, i.Date
    from 
        inserted i
    join deleted d on i.Id = d.Id
    join Patient p on i.PId = p.Id
    join InPatient ip on p.Id = ip.Id
    where 
        i.Status = 'Done' and d.Status = 'Assigned' 

    -- Check if rows were affected
    if @@ROWCOUNT > 0
    begin
        print 'ExamineInPatient record inserted successfully for InPatients with updated completed appointments.'
    end
end

--------------------------------------------------------------------------------------------------
--ReportDoctorUpdate Trigger
--Logs doctor-related actions (insert/update) in a separate table
go
Create or alter Trigger Trg_ReportDoctorUpdate
on Report
after insert, update
as
begin
    if exists (select * from inserted) and not exists (select * from deleted)
    begin
        insert into ReportDoctor (RepID, DId, ActionMade, Date)
        select 
            i.Id, 
            i.LatestDIdUpdated, 
            'Insert', 
			i.LatestDateUpdated
        from inserted i
    end

    IF exists (select * FROM inserted) and exists (select * from deleted)
    begin
        insert into ReportDoctor (RepID, DId, ActionMade, Date)
        select 
            i.Id, 
            i.LatestDIdUpdated, 
            'Update', 
			i.LatestDateUpdated
        from inserted i
        join deleted d on i.Id = d.Id
		where i.Disease != d.Disease or i.Symptom != d.Symptom or i.Diagnosis != d.Diagnosis
    end
end

--------------------------------------------------------------------------------------------------
--RestrictUpdateReport Trigger
--Allows updates only if specific fields in the report change
go
create or alter trigger Trg_RestrictUpdateReport
on Report
instead of update
as
begin
    set nocount on

    declare @Disease varchar(100), @Symptom varchar(100), @Diagnosis varchar(100)
    declare @NewDisease varchar(100), @NewSymptom varchar(100), @NewDiagnosis varchar(100)
    
    select @Disease = Disease, @Symptom = Symptom, @Diagnosis = Diagnosis from deleted
    
    select @NewDisease = Disease, @NewSymptom = Symptom, @NewDiagnosis = Diagnosis from inserted
    
    -- Check if any of the fields have changed
    if @Disease != @NewDisease or @Symptom != @NewSymptom or @Diagnosis != @NewDiagnosis
    begin
        update Report
        set 
            Disease = @NewDisease,
            Symptom = @NewSymptom,
            Diagnosis = @NewDiagnosis,
            LatestDIdUpdated = (select LatestDIdUpdated from inserted),
            LatestDateUpdated = (select LatestDateUpdated from inserted)
        where Id = (select Id from inserted)
        
        print 'Report updated successfully.'
    end
    else
    begin
        -- If no change, print a message and do not perform the update
        print 'No change detected in Disease, Symptom, or Diagnosis. Update skipped.'
    end
end
go

--------------------------------------------------------------------------------------------------
--RestrictUpdatePrescription Trigger
--Prevent unnecessary updates to the Prescription table if the Description field remains unchanged
go
create or alter trigger Trg_RestrictUpdatePrescription
on Prescription
instead of update
as
begin
    set nocount on

    declare @OldDescription varchar(max), @NewDescription varchar(max)
    
    select @OldDescription = Description from deleted
    
    select @NewDescription = Description from inserted
    
    -- Check if any of the fields have changed
    if @OldDescription != @NewDescription
    begin
        update Prescription
        set 
            Description = @NewDescription,
            LatestDIdUpdated = (select LatestDIdUpdated from inserted),
            LatestDateUpdated = (select LatestDateUpdated from inserted)
        where Id = (select Id from inserted)
        
        print 'Report updated successfully.'
    end
    else
    begin
        -- If no change, print a message and do not perform the update
        print 'No change detected in Description. Update skipped.'
    end
end
go

--------------------------------------------------------------------------------------------------
--PrescriptionDoctorUpdate Trigger
--Logs doctor-related actions (insert/update) in a separate table
go
Create or alter Trigger Trg_PrescriptionDoctorUpdate
on Prescription
after insert, update
as
begin
    if exists (select * from inserted) and not exists (select * from deleted)
    begin
        insert into PrescriptionDoctor (PreID, DId, ActionMade, Date)
        select 
            i.Id, 
            i.LatestDIdUpdated, 
            'Insert', 
			i.LatestDateUpdated
        from inserted i
    end

    IF exists (select * FROM inserted) and exists (select * from deleted)
    begin
        insert into PrescriptionDoctor (PreID, DId, ActionMade, Date)
        select 
            i.Id, 
            i.LatestDIdUpdated, 
            'Update', 
			i.LatestDateUpdated
        from inserted i
        join deleted d on i.Id = d.Id
        where i.Description != d.Description
    end
end

--------------------------------------------------------------------------------------------------
--PositiveBill Trigger
--Ensure that all bill amounts in the Bill table are positive
go
create or alter trigger Trg_PositiveBill
on Bill
after insert, update
as
begin
  if exists (select 1 from inserted where Amount <= 0)
  begin
    rollback transaction
    print 'Error: Bill amount must be positive.'
  end
end

--------------------------------------------------------------------------------------------------
--CheckDoctorInsert Trigger
--Prevent conflicts in roles assigned to employees
go
create or alter trigger Trg_CheckDoctorInsert
on Doctor
instead of insert
as
begin
    if exists (
        select 1
        from Employee e
        where e.Id in (select Id from inserted)
          and e.EmpType not in ('D')
    )
    begin
        print 'Error: The employee is already registered as a different type and cannot be a Doctor.'
        return
    end

    insert into Doctor (Id, Speciality)
    select Id, Speciality from inserted
end

--------------------------------------------------------------------------------------------------
--CheckNurseInsert Trigger
--Prevent conflicts in roles assigned to employees
go
create or alter trigger Trg_CheckNurseInsert
on Nurse
instead of insert
as
begin
    if exists (
        select 1
        from Employee e
        where e.Id in (select Id from inserted)
          and e.EmpType not in ('N')
    )
    begin
        print 'Error: The employee is already registered as a different type and cannot be a Nurse.'
        return
    end

    insert into Nurse (Id)
    select Id from inserted
end

--------------------------------------------------------------------------------------------------
--CheckReceptionistInsert Trigger
--Prevent conflicts in roles assigned to employees
go
create or alter trigger Trg_CheckReceptionistInsert
on Receptionist
instead of insert
as
begin
    if exists (
        select 1
        from Employee e
        where e.Id in (select Id from inserted)
          and e.EmpType not in ('R')
    )
    begin
        print 'Error: The employee is already registered as a different type and cannot be a Receptionist.'
        return
    end

    insert into Receptionist (Id)
    select Id from inserted
end
