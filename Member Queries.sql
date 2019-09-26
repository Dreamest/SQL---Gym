--Member Queries

--Which equipment is the highest rated?
select  Equipment.Item_Description, Equipment_usage.rating 
from Equipment_usage inner join Equipment on(Equipment.Serial_Number=Equipment_usage.Serial_Number)
where rating >= all(select rating from Equipment_usage)

--When, what and where is my class?
select Scheduled_Class.class_name,Scheduled_Class.Day_Of_Week, Scheduled_Class.location, Scheduled_Class.time  
from Members inner join participateClass on(Members.Member_ID=participateClass.Member_ID)
			inner join Scheduled_Class on(Scheduled_Class.class_ID=participateClass.Class_ID)
where Members.Member_ID=15 

--Return a list of all equipment I’ve used and is currently broken
select Equipment.Item_Description 
from Members inner join Equipment_usage on(Equipment_usage.Member_ID=Members.Member_ID)
			inner join Equipment on(Equipment.Serial_Number=Equipment_usage.Serial_Number)
			inner join repair_session on(repair_session.Serial_Number=Equipment.Serial_Number)
where Members.Member_ID = 15 and repair_session.fixed_date is null
order by repair_session.decommission_date asc

--What’s the name of the class and the instructor on the last class of a specific day.   
select concat(Employees.fName, ' ', Employees.lName)as 'Instructor Name' ,Scheduled_Class.class_name 
from Employees inner join Instructors on(Employees.ID=Instructors.ID)
				inner join Scheduled_Class on(Scheduled_Class.instructor_ID=Instructors.ID)
where Scheduled_Class.Day_Of_Week='Sunday' and Scheduled_Class.time >= all(select Scheduled_Class.time from Scheduled_Class)

--How much do I pay for the month? Base fee + training sessions
select Members.Member_ID,(sum(Training_Session.price)+ Members.monthly_fee)as 'total monthly cost' 
from Members inner join Training_Session on(Training_Session.Member_ID=Members.Member_ID)
where members.Member_ID = 20 and Training_Session.date between '2018-11-01' and '2018-11-30'
group by members.Member_ID,Members.monthly_fee

--Which class has the most participants, who teaches it?
select Scheduled_Class.class_name, concat(Employees.fName, ' ', Employees.lName)as 'Instructor Name', biggestClass.paricipants
from employees inner join Instructors on(Instructors.ID=employees.ID)
				inner join Scheduled_Class on(Scheduled_Class.instructor_ID=Instructors.ID)
				inner join(select top 1 count(Class_ID)as 'paricipants',Class_ID 
				from participateClass
				group by Class_ID
				order by paricipants desc)as biggestClass on(biggestClass.Class_ID=Scheduled_Class.class_ID)


--What’s the name of the receptionist that works the night shift?
select concat(Employees.fName,' ', Employees.lName) as 'Receptionist Name'
from dbo.Employees inner join Administrators on(Employees.ID=Administrators.ID)
where Administrators.jobRole='Front Desk' and Administrators.shift_time='Night'