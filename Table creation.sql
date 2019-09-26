--create database SQLProject
use SQLProject

create table Manufacturers(
M_ID int not null primary key,
M_Name nvarchar(50),
M_Speciality nvarchar(50)
);

create table Equipment(
Serial_Number int not null primary key,
Item_Description nvarchar(50) 
);

create table Sale(
Sale_ID int not null primary key,
M_ID int not null foreign key references Manufacturers(M_ID),
Serial_Number int not null foreign key references Equipment(Serial_Number),
Price money,
unitCount int,
Purchase_Date date
);

create table Employees(
ID int not null primary key,
fName nvarchar(50),
lName nvarchar(50),
Salary money,
Works_since date
);

create table Personal_Trainers(
ID int not null primary key references Employees(ID),
speciality nvarchar(50)
);

create table Instructors(
ID int not null primary key references Employees(ID),
teaches nvarchar(50),
availability nvarchar(50)
);

create table Administrators(
ID int not null primary key references Employees(ID),
shift_time nvarchar(50),
jobRole nvarchar(50)
);

create table repair_session(
session_ID int not null primary key,
id int not null foreign key references Administrators(ID),
Serial_Number int not null foreign key references Equipment(Serial_Number),
decommission_date date,
reason nvarchar(50),
fixed_date date
);

create table Members(
Member_ID int not null primary key,
fName nvarchar(50),
lName nvarchar(50),
DOB date,
member_since date,
monthly_fee money not null,
deal nvarchar(50)
);

create table Training_Session(
session_ID int not null primary key,
Member_ID int not null foreign key references Members(Member_ID),
Trainer_ID int not null foreign key references Personal_Trainers(ID),
Admin_ID int not null foreign key references Administrators(ID),
time time,
date date,
price money
);

create table Equipment_usage(
Member_ID int not null references Members(Member_ID),
Serial_Number int not null references Equipment(Serial_Number),
used_on datetime,
rating int,
primary key(Member_ID, Serial_Number)
);

create table Scheduled_Class(
class_ID int not null primary key,
instructor_ID int not null foreign key references Instructors(ID),
Day_Of_Week nvarchar(20),
class_name nvarchar(50),
time time,
duration time,
location nvarchar(50)
);

create table Actual_Class(
actual_ID int not null primary key references Scheduled_Class(Class_ID),
instructor_ID  int not null foreign key references Instructors(ID),
location nvarchar(50),
StartTime time,
endTime time,
);

create table participateClass(
Code int not null primary key,
Member_ID int not null foreign key references Members(Member_ID),
Class_ID int not null foreign key references Actual_Class(actual_ID)
);

create table manufacturerAudit(
line int not null identity(1,1) primary key,
auditInfo nvarchar(1000)
);

