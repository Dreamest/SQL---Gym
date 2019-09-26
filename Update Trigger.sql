--Update Trigger

alter trigger tr_trbAuditTable_forupdate
on Manufacturers
for update 
as
begin

		declare @M_ID int
		declare @oldM_Name varchar(50),@newM_Name varchar(50)
		declare @oldM_Speciality varchar(50),@newM_Speciality varchar(50)
		
		declare @auditString nvarchar(1000)

		select * into
		#tempTable
		from inserted

		while(exists (select M_ID from  #tempTable))
		begin 
			set @auditString=''
			
			select top 1 @M_ID=M_ID , @newM_Name=M_Name,
			@newM_Speciality=M_Speciality
			from #tempTable

			select  @M_ID=M_ID , @oldM_Name=M_Name,
			@oldM_Speciality=M_Speciality
			from deleted where @M_ID=M_ID

			set @auditString ='Employye with id ='+cast(@M_ID as nvarchar(4))+' was changed!'
			if(@oldM_Name <> @newM_Name)
				set @auditString =@auditString +' name was changed from  '+ @oldM_Name+ ' to '+@newM_Name + '.'
			if(@oldM_Speciality <> @newM_Speciality)
				set @auditString =@auditString +' Speciality  was changed from'+ @oldM_Speciality+ ' to '+@newM_Speciality + '.'
	        set @auditString =@auditString +' Add on'+ cast(getdate() as nvarchar(20)) +  + '.'
			insert into manufacturerAudit values(@auditString)

			delete from #tempTable where @M_ID=M_ID
		end
end