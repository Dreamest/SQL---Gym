create trigger tr_trbAuditTable_InsertMAnufacturer
on Manufacturers
for insert 
as 
begin 
declare 
         @id int,@mname nvarchar(50),@M_Speciality nvarchar(50)
		select @id=M_ID,@mname=M_Name,@M_Speciality=M_Speciality from inserted 
		insert into manufacturerAudit
		values ('add new   Manufacturer with id = ' +cast(@id as varchar(5)) +'. m_name= '+
		@mname+'. Speciality= '+@M_Speciality+' Added on' +CAST(GETDATE() as nvarchar(20)) + '.')
end