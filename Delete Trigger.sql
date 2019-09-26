create trigger tr_trbAuditTable_forDelete
on Manufacturers
for delete 
as 
begin 
declare 
         @id int,@mname nvarchar(50),@M_Speciality nvarchar(50)
		select @id=M_ID,@mname=M_Name,@M_Speciality=M_Speciality from deleted
		insert into manufacturerAudit
		values ('Removed existing Manufacturer with id = ' +cast(@id as varchar(5)) +'. Name= '+
		@mname+'. Speciality= '+@M_Speciality+'. At' +CAST(GETDATE() as nvarchar(20)))
end