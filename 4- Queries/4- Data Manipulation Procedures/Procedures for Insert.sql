Use Hospital

--------------------------------------------------------------------------------------------------
--InsertDepartment Proc
 --Insert a new department
 go
 create or alter procedure SP_InsertDepartment @Name varchar(100)
with encryption 
as
begin
    begin try
        if @Name is null
        begin
            print 'Error: Department name cannot be NULL.'
            return
        end
        if exists (select 1 from Department where Name = @Name)
        begin
            print 'Department already exists'
            return
        end
        insert into Department (Name)
        values (@Name)
        print 'Department inserted successfully.'
    end try
    begin catch
        print 'An error occurred while inserting Department.' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertDepartment 'Dermatology'

--------------------------------------------------------------------------------------------------
--InsertDoctor Proc
--Insert a new doctor
go
create or alter procedure SP_InsertDoctor @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Salary money, @Street varchar(100), @City varchar(50) = 'Cairo', 
	@State varchar(50) = 'Egypt', @DeptID int, @Speciality nvarchar(100)  
with encryption 
as
begin
    begin try
        begin transaction

        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Doctor already exists'
            rollback transaction
            return
        end

        declare @NewEmpID int
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Salary, Street, City, State, DeptID)
        values ('D', @Fname, @Lname, @DOB, @Phone, @Gender, @Salary, @Street, @City, @State, @DeptID)
        set @NewEmpID = scope_identity()

        insert into Doctor (Id, Speciality)
        values (@NewEmpID, @Speciality)

        commit transaction
        print 'Doctor inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the doctor: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertDoctor @Fname = 'Ahmed',@Lname = 'Talaat',@DOB = '1980-05-15', @Phone = '04112793478',
@Gender = 'M', @Salary = 12700, @Street = '123 Elm St',@DeptID = 106, @Speciality = 'Dermatology'

--------------------------------------------------------------------------------------------------
--InsertNurse Proc
--Insert a new nurse
go
create or alter procedure SP_InsertNurse @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Salary money, @Street varchar(100), 
    @City varchar(50) = 'Cairo', @State varchar(50) = 'Egypt', @DeptID int
with encryption 
as
begin
    begin try
        begin transaction

        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Nurse already exists'
            rollback transaction
            return
        end

        declare @NewEmpID int
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Salary, Street, City, State, DeptID)
        values ('N', @Fname, @Lname, @DOB, @Phone, @Gender,@Salary, @Street, @City, @State, @DeptID)
        set @NewEmpID = scope_identity()

        insert into Nurse (Id)
        values (@NewEmpID)

        commit transaction
        print 'Nurse inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the nurse: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertNurse @Fname = 'Nour',@Lname = 'Adel',@DOB = '1980-05-15', @Phone = '01142793478', @Gender = 'F',
 @Salary = 6660, @Street = '123 Elm St', @DeptID = 106

--------------------------------------------------------------------------------------------------
--InsertReceptionist Proc
--Insert a new receptionist
go
create or alter procedure SP_InsertReceptionist @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Salary money, @Street varchar(100), 
    @City varchar(50) = 'Cairo', @State varchar(50) = 'Egypt', @DeptID int
with encryption 
as
begin
    begin try
        begin transaction

        if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Receptionist already exists'
            rollback transaction
            return
        end

        declare @NewEmpID int
        insert into Employee (EmpType, Fname, Lname, DOB, Phone, Gender, Salary, Street, City, State, DeptID)
        values ('R', @Fname, @Lname, @DOB, @Phone, @Gender, @Salary, @Street, @City, @State, @DeptID)
        set @NewEmpID = scope_identity()

        insert into Receptionist (Id)
        values (@NewEmpID)

        commit transaction
        print 'Receptionist inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the receptionist: ' + error_message()
    end catch
end
--Execution Example
go
exec SP_InsertReceptionist @Fname = 'Radwa',@Lname = 'Mohamed',@DOB = '1980-05-15', @Phone = '01342793878', @Gender = 'F',
 @Salary = 4800, @Street = '13 maadi St',@DeptID = 105

--------------------------------------------------------------------------------------------------
--InsertPatient Proc
--Insert a new patient
go
create or alter proc SP_InsertPatient @Fname varchar(50), @Lname varchar(50),@DOB date, @Phone varchar(15),
		@Gender char(1), @Street varchar(100), @City varchar(50) = 'Cairo', @State varchar(50) = 'Egypt'
with encryption 
as
begin
    begin try
        insert into Patient (Fname, Lname, DOB, Phone, Gender, Street, City, State)
        values (@Fname, @Lname, @DOB, @Phone, @Gender, @Street, @City, @State)
    end try
    begin catch
        print 'An error occurred while inserting the Patient.' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertPatient @Fname = 'Kamal', @Lname = 'Saad', @DOB = '1995-08-16', @Phone = '0119876543', @Gender = 'M',
 @Street = 'Al-Haram St', @City = 'Giza'
go
exec SP_InsertPatient @Fname = 'Laila', @Lname = 'Naguib', @DOB = '2000-02-28', @Phone = '0122345678', @Gender = 'F',
 @Street = 'Al-Mokattam St'
go
exec SP_InsertPatient @Fname = 'Hassan', @Lname = 'Mounir', @DOB = '1987-11-12', @Phone = '0108765432', @Gender = 'M',
 @Street = 'Tahrir Square'
go
exec SP_InsertPatient @Fname = 'Nadine', @Lname = 'Khalifa', @DOB = '1998-03-23', @Phone = '0111122334', @Gender = 'F',
 @Street = 'El-Maadi St'
go
exec SP_InsertPatient @Fname = 'Layla', @Lname = 'Sami', @DOB = '1995-09-15', @Phone = '0123344556', @Gender = 'F',
 @Street = 'Stanley Rd', @City = 'Alexandria'

--------------------------------------------------------------------------------------------------
--InsertRoom Proc
--Inserts a new room record, ensuring the nurse ID exists before insertion
go
create or alter proc SP_InsertRoom @MaxCapacity int, @CurrentCapacity int = 0, @NId int
with encryption 
as 
begin 
	begin try
		if exists (select 1 from nurse where id = @nid)
		begin
			insert into Room (maxcapacity, currentcapacity, nid)
			values (@maxcapacity, @currentcapacity, @nid)
			print 'Room record inserted successfully'
		end
		else
		begin
			print 'error: the nurse id does not exist in the nurse table'
		end
	end try
	begin catch
			print 'An error occurred while inserting the Patient.' + error_message()
	end catch
end 

--Execution Example
go
exec SP_InsertRoom @MaxCapacity = 3, @NId = 15

--------------------------------------------------------------------------------------------------
--InsertAppointment Proc
--Inserts an appointment record, validating the existence of related doctor, patient, and receptionist IDs
go
create or alter procedure SP_InsertAppointment @AppointmentDate datetime2, @Note varchar(100) = null, @DoctorID int, 
    @PatientID int, @ReceptionistID int, @Status varchar(20) = 'Assigned'       
with encryption 
as
begin
    begin try
        begin transaction

        if not exists (select 1 from Doctor where Id = @DoctorID)
        begin
            print 'Doctor ID does not exist.'
            rollback transaction
            return
        end

        if not exists (select 1 from Patient where Id = @PatientID)
        begin
            print 'Patient ID does not exist.'
            rollback transaction
            return
        end

        if not exists (select 1 from Receptionist where Id = @ReceptionistID)
        begin
            print 'Receptionist ID does not exist.'
            rollback transaction
            return
        end

        insert into Appointment (Date, Note, DId, PId, RId, Status)
        values (@AppointmentDate, @Note, @DoctorID, @PatientID, @ReceptionistID, @Status)

        commit transaction

        print 'Appointment inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the appointment: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertAppointment @AppointmentDate = '2024-12-30 14:30:00', @Note = 'Follow-up visit', @DoctorID = 14, @PatientID = 11, @ReceptionistID = 16, @Status = 'Done'
go
exec SP_InsertAppointment @AppointmentDate = '2024-12-27 16:45:00', @DoctorID = 14, @PatientID = 12, @ReceptionistID = 16, @Status = 'Done'
go
exec SP_InsertAppointment @AppointmentDate = '2024-12-30 14:30:00', @DoctorID = 3, @PatientID = 13, @ReceptionistID = 12
go
exec SP_InsertAppointment @AppointmentDate = '2024-12-27 16:45:00', @Note = 'Cancelled due to personal reasons', @DoctorID = 2, @PatientID = 14, @ReceptionistID = 13, @Status = 'Cancelled'
go
exec SP_InsertAppointment @AppointmentDate = '2024-12-27 16:45:00', @DoctorID = 1, @PatientID = 15, @ReceptionistID = 11

--------------------------------------------------------------------------------------------------
--InsertReport Proc
--Inserts a medical report and associated patient type (InPatient or OutPatient), ensuring relevant validations and updates
go
create or alter proc SP_InsertReport @Disease varchar(100), @Symptom varchar(100), @Diagnosis varchar(100), 
    @PId int, @DID int, @Date datetime2, @PType char(1), @RoNum int = null
with encryption 
as
begin
    begin try
        if not exists (select 1 from Patient where Id = @PId)
        begin
            print 'Error: The patient ID does not exist in the Patient table.'
            return
        end
        if not exists (select 1 from Employee where Id = @DID and EmpType = 'D')
        begin
            print 'Error: The doctor ID does not exist in the Employee table or is not a doctor.'
        end
		begin transaction

        insert into Report (Disease, Symptom, Diagnosis, PId, LatestDIdUpdated, LatestDateUpdated)
        values (@Disease, @Symptom, @Diagnosis, @PId, @DID, @date)
        print 'Report record inserted successfully.'

        if @PType = 'O'
        begin
            if not exists (select 1 from OutPatient where Id = @PId)
            begin
                insert into OutPatient (Id)
                values (@PId)

                print 'OutPatient record inserted successfully.'
            end
        end
        else if @PType = 'I'
        begin
            if @RoNum is null
            begin
                print 'Error: Room number must be provided for InPatient.'
                rollback transaction
                return
            end

            if not exists (select 1 from Room where Num = @RoNum)
            begin
                print 'Error: The room does not exist.'
                rollback transaction
                return
            end

            declare @maxCap int, @curCap int
            select @maxCap = MaxCapacity, @curCap = CurrentCapacity
            from Room where Num = @RoNum

            if @curCap < @maxCap
            begin
                if not exists (select 1 from InPatient where Id = @PId)
                begin
                    insert into InPatient (Id, RoNum)
                    values (@PId, @RoNum)

                    print 'InPatient record inserted successfully.'
                end
            end
            else
            begin
                print 'Error: This room is full.'
                rollback transaction
                return
            end
        end
        else
        begin
            print 'Error: Patient type must be I or O.'
            rollback transaction
            return
        end

        commit transaction
        print 'All records inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while inserting the report: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertReport
@Disease = 'Cold', @Symptom = 'Sneezing, Runny Nose', @Diagnosis = 'Allergic Rhinitis', @PId = 11, @DID = 14, 
@Date = '2024-12-30 14:30:00', @PType = 'O'
go
exec SP_InsertReport
@Disease = 'Pneumonia', @Symptom = 'Shortness of breath, Cough', @Diagnosis = 'Bacterial Infection', @PId = 12, @DID = 14,
@Date = '2024-12-27 16:45:00', @PType = 'I', @RoNum = 105

--------------------------------------------------------------------------------------------------
--InsertPrescription Proc
--Inserts a prescription record for a patient by a doctor on a specified date
go
create or alter proc SP_InsertPrescription @description varchar(max), @PId int, @DID int, @Date datetime2
with encryption 
as
begin
    begin try
        if not exists (select 1 from Patient where Id = @PId)
        begin
            print 'Error: The patient ID does not exist in the Patient table.'
            return
        end
		if not exists (select 1 from Employee where Id = @DID and EmpType = 'D')
        begin
            print 'Error: The doctor ID does not exist in the Employee table or is not a doctor.'
        end
        begin transaction

        insert into Prescription (description, pid, LatestDIdUpdated, LatestDateUpdated)
        values (@description, @pid, @DID, @Date)
		print 'Prescription record inserted successfully'
        
		commit transaction
        print 'All records inserted successfully.'
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction

        print 'An error occurred while inserting the report: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_insertPrescription @description = 'Take Panadol 400mg every 4-6 hours', @pid = 11, @DID = 14, @Date = '2024-12-30 14:30:00'
go
exec SP_insertPrescription @description = 'Take 500mg Amoxicillin every 8 hours', @pid = 12,@DID = 14, @Date = '2024-12-27 16:45:00'

--------------------------------------------------------------------------------------------------
--InsertBill Proc
--Inserts a billing record, ensuring the existence of related patient and receptionist IDs
go
create or alter procedure SP_InsertBill @Amount money, @PId int, @RID int, @Date datetime2
with encryption 
as
begin
    begin try
        begin transaction

        if exists (select 1 from Patient where Id = @PId)
           and exists (select 1 from Receptionist where Id = @RID)
        begin
            insert into Bill (Amount, PId, RID, Date)
            values (@Amount, @PId, @RID, @Date)

            commit transaction

            print 'Bill record inserted successfully.'
        end
        else
        begin
            rollback transaction
            print 'Error: The Patient ID or Receptionist ID does not exist in their respective tables.'
        end
    end try
    begin catch
        if @@TRANCOUNT > 0
        begin
            rollback transaction
        end

        print 'An error occurred while inserting the bill: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertBill @Amount = 300, @PID = 11, @RID = 16, @Date = '2024-12-30 15:00:00'
go
exec SP_InsertBill @Amount = 5000, @PID = 12, @RID = 16, @Date = '2024-12-28 16:00:00'

--------------------------------------------------------------------------------------------------
--InsertDrug Proc
--Inserts a new drug
go
create or alter procedure SP_InsertDrug @code int,@name varchar(50), @RecDosage varchar(50) 
with encryption 
as 
begin
	Begin try
		insert into Drug (Code, Name, RecDosage) values (@code, @name, @RecDosage)
		print  'Drug record inserted successfully'
	End try
	Begin catch
		print 'An error occurred while inserting Drug.' + error_message()
	End catch
end

--Execution Example
go
exec SP_InsertDrug @code = 127, @name = 'Amoxicillin', @RecDosage = '500 mg every 8 hours'

--------------------------------------------------------------------------------------------------
--InsertExaminePatient Proc
--Records an examination of an inpatient by a doctor on a specific date
go
create or alter procedure SP_InsertExaminePatient @DID int,@InPID int, @date datetime2
with encryption 
as 
begin
	Begin try
		insert into ExamineInPatient (DID, InPID, date) values (@DID, @InPID, @date)
		print 'ExaminePatient record inserted successfully'
	End try
	Begin catch
		print 'An error occurred while inserting ExaminePatient.' + error_message()
	End catch
end

go
exec SP_InsertExaminePatient @DID = 5, @InPID = 12, @Date = '2024-12-27 20:00:00'

--------------------------------------------------------------------------------------------------
--InsertGivenDrug Proc
--Logs the administration of a drug to an inpatient by a nurse on a specific date
go
create or alter procedure SP_InsertGivenDrug @Dosage varchar(30),@Date datetime2,@DragCode int,@Inpid int,@NID int
with encryption 
as 
begin
   Begin try
		insert into GivenDrug (Dosage, GivenDate, DrugCode, Inpid, NID) 
		values(@Dosage,@Date,@DragCode,@Inpid,@NID)
		print 'GivenDrug record inserted successfully'
   End try
   Begin catch
		print 'An error occurred while inserting GivenDrug.' + error_message()
   End catch
end

--Execution Example
go
exec SP_InsertGivenDrug @Dosage = '500mg', @Date = '2024-12-27 17:00:00', @DragCode = 127, @Inpid = 12, @NID = 15
go
exec SP_InsertGivenDrug @Dosage = '450mg', @Date = '2024-12-28 3:00:00', @DragCode = 120, @Inpid = 12, @NID = 15

--------------------------------------------------------------------------------------------------
--InsertPatientFromExisting Proc
--Creates a new patient record using an existing person’s ID, with optional updated personal details
go
create or alter proc SP_InsertPatientFromExisting  @ExistingPersonId int, @NewFname varchar(50) = null, @NewLname varchar(50) = null, 
    @NewDOB date = null, @NewPhone varchar(15) = null, @NewGender char(1) = null, @NewStreet varchar(100) = null, 
	@NewCity varchar(50) = null, @NewState varchar(50) = null
with encryption 
as
begin
    begin try
        if not exists (select 1 from Patient where Id = @ExistingPersonId)
        begin
            print 'Error: The specified person ID does not exist in the Patient table.'
            return
        end

        declare @Fname varchar(50), @Lname varchar(50), @DOB date, 
                @Phone varchar(15), @Gender char(1), 
                @Street varchar(100), @City varchar(50), @State varchar(50)

        select @Fname = Fname, @Lname = Lname, @DOB = DOB, 
               @Phone = Phone, @Gender = Gender, 
               @Street = Street, @City = City, @State = State
        from Patient
        where Id = @ExistingPersonId

        set @Fname = coalesce(@NewFname, @Fname)
        set @Lname = coalesce(@NewLname, @Lname)
        set @DOB = coalesce(@NewDOB, @DOB)
        set @Phone = coalesce(@NewPhone, @Phone)
        set @Gender = coalesce(@NewGender, @Gender)
        set @Street = coalesce(@NewStreet, @Street)
        set @City = coalesce(@NewCity, @City)
        set @State = coalesce(@NewState, @State)

        insert into Patient (Fname, Lname, DOB, Phone, Gender, Street, City, State)
        values (@Fname, @Lname, @DOB, @Phone, @Gender, @Street, @City, @State)

        print 'New patient record inserted successfully based on existing person.'
    end try
    begin catch
        print 'An error occurred while inserting the new patient: ' + error_message()
    end catch
end

-----------------------------------------------------------------------------------------------------------------
--InsertEmployee proc
--Insert new employee
go
create or alter procedure SP_InsertEmployee  @Fname varchar(50), @Lname varchar(50),         
    @DOB date, @Phone varchar(15), @Gender char(1), @Salary money, @Street varchar(100), @City varchar(50) = 'Cairo', 
	@State varchar(50) = 'Egypt', @DeptID int
with encryption 
as
begin
    begin try
	begin transaction
	 if exists (select 1 from Employee where Phone = @Phone)
        begin
            print 'Employee already exists'
			rollback transaction
            return
        end
	if not exists (select 1 from Department where Id = @DeptID)
        begin
            print 'error: the Department id does not exist in the department table'
			rollback transaction
            return
        end
    insert into employee (emptype, fname, lname, dob, phone, salary, gender, street, city, state, deptid)
    values (null, @fname, @lname, @dob, @phone, @salary, @gender, @street, @city, @state, @deptid)
	commit transaction
	print 'Employee record inserted successfully'
   end try
   begin catch
		 if @@TRANCOUNT > 0
        begin
            rollback transaction
        end
        print 'An error occurred while inserting the Employee: ' + error_message()
    end catch
end

--Execution Example
go
exec SP_InsertEmployee  @Fname = 'Omar',@Lname = 'Khalid',@DOB = '1988-12-15', @Phone = '01173901654',
@Gender = 'M', @Salary = 9000, @Street = '44 sheikh zayed st',@DeptID = 105