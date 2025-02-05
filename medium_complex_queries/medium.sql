--create db
CREATE DATABASE SqlPrepDB;

--use db
USE SqlPrepDB;

--employee table creation
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    DepartmentID INT,
    JobTitle NVARCHAR(100),
    ManagerID INT,
    Salary DECIMAL(10, 2),
    JoiningDate DATE
);

--department table creation 
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);

--jobs table creation
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY,
    EmployeeID INT,
    JobTitle NVARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


--sample data creation

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
    (1, 'HR'),
    (2, 'Engineering'),
    (3, 'Sales');


INSERT INTO Employees (EmployeeID, EmployeeName, DepartmentID, JobTitle, ManagerID, Salary, JoiningDate)
VALUES
    (1, 'Alice', 1, 'HR Manager', NULL, 60000.00, '2020-03-15'),
    (2, 'Bob', 2, 'Software Engineer', 1, 80000.00, '2021-07-10'),
    (3, 'Charlie', 2, 'Senior Software Engineer', 2, 100000.00, '2019-04-20'),
    (4, 'David', 3, 'Sales Executive', NULL, 50000.00, '2022-01-15'),
    (5, 'Eve', 2, 'Software Engineer', 2, 75000.00, '2021-09-05'),
    (6, 'Frank', 3, 'Sales Manager', 4, 95000.00, '2018-11-01'),
    (7, 'Grace', 2, 'QA Engineer', 3, 70000.00, '2020-12-10');


INSERT INTO Jobs (JobID, EmployeeID, JobTitle, StartDate, EndDate)
VALUES
    (1, 2, 'Software Engineer', '2021-07-10', '2023-07-10'),
    (2, 5, 'Software Engineer', '2021-09-05', '2022-09-05'),
    (3, 7, 'QA Engineer', '2020-12-10', '2022-12-10');


--data check
SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Jobs;


--1. Write a query to find duplicate records in a table Employees based on the EmployeeCode.
ALTER TABLE Employees
ADD EmployeeCode VARCHAR(10);

SELECT e.EmployeeCode, COUNT(e.EmployeeID) as count 
FROM Employees e
GROUP BY e.EmployeeCode
HAVING COUNT(e.EmployeeID) > 1


--2. WRT above query, also list down employee data
select * from Employees
    where EmployeeCode in (
    SELECT e.EmployeeCode 
    FROM Employees e
    GROUP BY e.EmployeeCode
    HAVING COUNT(e.EmployeeID) > 1
)

--3. Write a query to find the second highest salary from the Employees table.
select * from Employees

select top 1 Salary
from Employees
where Salary < (select max(Salary) from Employees)
order by Salary desc

--4. Write a query to get the names of employees who work in departments that have more than or equal to 3 employees.

--method1: without CTE
select * from Employees where DepartmentID in
(
    select DepartmentID
    from Employees
    GROUP by DepartmentID
    HAVING COUNT(EmployeeID) >= 3
);

--Method2: with CTE
with dept_emp
AS
(
    select DepartmentID
    from Employees
    GROUP by DepartmentID
    HAVING COUNT(EmployeeID) >= 3
)
select *
from Employees e 
    inner join dept_emp d on d.DepartmentID = e.DepartmentID;



--5. Write a query to get the list of employees with their managers from the Employees table. Assume that ManagerID is a foreign key referring to the EmployeeID of the manager.
select e.EmployeeName as Employee, e.ManagerID, m.EmployeeID, m.EmployeeName as Manager
from Employees e 
inner join Employees m 
on e.ManagerID = m.EmployeeID


--6. Write a query to find employees who have more than one job in the Jobs table (the table records each job an employee has).
select * from Employees
where EmployeeID in (
    SELECT j.EmployeeID
    FROM Jobs j 
    group by j.EmployeeID
    having COUNT(EmployeeID) > 1
)

--7. Write a query to calculate the total salary paid for each department.
select e.DepartmentID, sum(e.Salary) as TotalSalary
from Employees e
GROUP by e.DepartmentID;

--8. Write a query to find employees who joined in the last 30 days.
select * 
FROM Employees
where cast(JoiningDate as date) > cast((GETDATE() - 30) as date);

--9. Write a query to find the number of employees working for each job title.
select JobTitle, count(EmployeeID) employeeCount
from Jobs
GROUP By JobTitle;

--10. Copy table 
select * into EmployeesCopy from Employees 

--11. Copay table without data
select * into EmployeesCopy2 from Employees WHERE 1 = 2;

--12. Insert data from 1 table to anothe having same structure
insert into EmployeesCopy
select * from Employees

drop table EmployeesCopy2;

--11. Write a query to delete duplicate rows in the Employees table where EmployeeName is duplicated.
select * from EmployeesCopy; 
--method 1: with CTE
with duplicate_cte
AS
(
    select Row_number() over (partition by EmployeeCode order by EmployeeID asc) as rank, EmployeeID, EmployeeCode
    from EmployeesCopy 
)
DELETE from EmployeesCopy
where EmployeeID in (select EmployeeID from duplicate_cte where rank > 1);

--method 2: without CTE
delete from EmployeesCopy where EmployeeID in 
(
    select employeeID
    from 
    (
        SELECT ROW_NUMBER() over (partition by EmployeeCode order by EmployeeID desc) as row_num,
        employeeId,
        employeeCode
        from EmployeesCopy
    ) dup
    where row_num > 1
)

--12. List employees having same managers
with manager_data 
as
(
    SELECT e.ManagerID as MgrId, COUNT(e.EmployeeID) as employee_count
    FROM Employees e
    GROUP BY e.ManagerID
    HAVING COUNT(e.EmployeeID) > 1
)
select e.* 
from manager_data md
inner join Employees e 
on e.ManagerID = md.MgrId 

--13. Nth highest salary

select * from Employees order by Salary desc

select *
from
(
    select 
        DENSE_RANK() over (order by salary desc) sal_rank
        , salary
        , EmployeeID
        , DepartmentID
    from 
        Employees
) as sal_data
where sal_rank = 3

--13. 2nd highest salary department wise
select DepartmentID, min(Salary) as Salary
from 
    (
    select 
        Salary
        ,DepartmentID
        ,DENSE_RANK() over (partition by DepartmentID order by salary desc) sal_rank
    from 
        employees
    ) sal_data
where sal_rank < 3
GROUP by DepartmentID

--14. You have an Employees table containing salary details. Write a SQL query using the LEAD() function to display each employee's salary along with the salary of the next employee (ordered by Salary in descending order). If there is no next employee, display NULL.
/*
EmployeeID	EmployeeName	Salary	    NextSalary
1	        Alice	        90000.00	80000.00
2	        Bob	            80000.00	75000.00
3	        Charlie	        75000.00	60000.00
4	        David	        60000.00	50000.00
5	        Eve	            50000.00	NULL
*/

select * from Employees order by Salary desc

select EmployeeID, EmployeeName, Salary, LEAD(Salary, 1) over (order by salary desc) as next_sal
from Employees




