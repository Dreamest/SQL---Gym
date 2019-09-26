--Management queries

--How much do we pay monthly for all of our employees, how many employees are there?
select count(Employees.ID)as NumbersOfEmployees,sum(salary) as Salaries
from Employees

--What is the most popular location, how many classes are being held there?
select top 1 Actual_Class.location, count(Actual_Class.actual_ID) as numberOfClass
from Actual_Class
group by Actual_Class.location
order by count(Actual_Class.location) desc

--Who is the most senior employee in the company?
select *
from Employees
where Employees.Works_since <= all ( select Works_since from Employees)

--Get a list of all equipment that took at least half a year to repair, and all equipment that is currently broken.
select Equipment.*, DATEDIFF(month, decommission_date, fixed_date) as 'Months until repaired', concat(Employees.fName,' ', Employees.lName) as 'Decomissioned by'
from  dbo.Equipment inner join dbo.repair_session on (Equipment.Serial_Number = repair_session.Serial_Number)
inner join Administrators on (Administrators.ID = repair_session.id)
inner join Employees on (Employees.ID = Administrators.ID)
where (DATEDIFF(month, decommission_date, fixed_date) >= 6 and Administrators.jobRole = 'Repairs') or fixed_date is null

--What is the most profitable training session?
select CONCAT(Members.fName,' ',Members.lName)as 'Member name',CONCAT(Employees.fname,' ',Employees.lName)
as 'Personal trainer name' ,Training_Session.price
from dbo.Members inner join dbo.Training_Session on( Members.Member_ID=Training_Session.Member_ID)
inner join Personal_Trainers on(Personal_Trainers.ID=Training_Session.Trainer_ID)
inner join Employees on(Employees.ID=Personal_Trainers.ID)
where Training_Session.price >= all(select Training_Session.price from Training_Session)

--Returns all classes where the instructor was changed
select t1.class_name,t1.Day_Of_Week,t1.time,CONCAT(t1.fName,' ',t1.lName)as 'Scheduled Instructors',CONCAT(t2.fName,' ',t2.lName)as 'Actual Instructors' from 
(select Employees.fName,Employees.lName,Scheduled_Class.class_ID,Scheduled_Class.instructor_ID,Scheduled_Class.class_name,Scheduled_Class.Day_Of_Week,Scheduled_Class.time
from Employees inner join Instructors on(Employees.ID=Instructors.ID)
inner join Scheduled_Class on(Instructors.ID=Scheduled_Class.instructor_ID))t1
inner join (select Employees.fName,Employees.lName,Actual_Class.actual_ID,Actual_Class.instructor_ID
from Employees inner join Instructors on(Employees.ID=Instructors.ID)
inner join Actual_Class on(Instructors.ID =Actual_Class.instructor_ID))t2
on(t1.class_ID=t2.actual_ID)
where t1.instructor_ID !=t2.instructor_ID

--Returns classes with classes discrepancies or delays, and shows how long those classes took 
select Scheduled_Class.class_name,Scheduled_Class.Day_Of_Week,Scheduled_Class.duration as 'planned duration'
,DATEDIFF(minute,Actual_Class.StartTime,Actual_Class.endTime)as 'Actual duration'
,Scheduled_Class.time as 'planned start time',Actual_Class.StartTime as 'Actual start time'
from Scheduled_Class inner join Actual_Class on(Scheduled_Class.class_ID=Actual_Class.actual_ID)
where DATEDIFF(minute,Actual_Class.StartTime,Actual_Class.endTime) != Scheduled_Class.duration or Scheduled_Class.time != Actual_Class.StartTime