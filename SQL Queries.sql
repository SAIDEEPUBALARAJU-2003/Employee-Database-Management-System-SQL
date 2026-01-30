create database Employee_Management_System;
use Employee_Management_System;
-- Table 1: Job Department
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);

-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

select * from employee;
select * from jobdepartment;
select * from leaves;
select * from payroll;
select * from qualification;
select * from salarybonus;

# Employee Insights
# Q1: How many unique employees are currently in the system?
SELECT COUNT(DISTINCT emp_id) AS total_employees FROM employee;

# Q2: Which departments have the highest number of employees?
SELECT jobdept, COUNT(*) AS employee_count
FROM jobdepartment
GROUP BY jobdept
ORDER BY employee_count DESC;

# Q3: What is the average salary per department?
SELECT jobdept, AVG(annual) AS avg_salary
FROM jobdepartment
left JOIN salarybonus USING(job_id)
GROUP BY jobdept;

# Q4: Who are the top 5 highest-paid employees?
SELECT firstname,lastname,annual
FROM employee
left join salarybonus using(job_id)
ORDER BY annual DESC
LIMIT 5;

# Q5: What is the total salary expenditure across the company?
SELECT SUM(amount) AS total_salary_expenditure
FROM salarybonus;

# 2. Job Role and Department Analysis
# Q6: How many different job roles exist in each department?
SELECT jobdept, COUNT(DISTINCT name) AS job_roles
FROM jobdepartment
GROUP BY jobdept;

# Q7: Which job roles offer the highest salary?
SELECT name, annual
FROM jobdepartment
left join salarybonus using(job_id)
ORDER BY annual DESC
limit 1;

# Q8: Which departments have the highest total salary allocation?
SELECT jobdept, sum(annual) AS total_salary
FROM jobdepartment
left join salarybonus using(job_id)
GROUP BY jobdept
ORDER BY total_salary DESC
limit 1;

#3. Qualification and Skills Analysis
# Q9: How many employees have at least one qualification listed?
SELECT * from qualification;
select count(distinct emp_id) as employee_Qualification
from qualification;

# Q10: Which positions require the most qualifications?
SELECT position, COUNT(*) AS num_qualifications
FROM qualification
GROUP BY position
limit 1;

# 4. Leave and Absence Patterns
# Q11: Which year had the most employees taking leaves?
SELECT YEAR(date), COUNT(distinct emp_id) AS employees
FROM leaves
GROUP BY YEAR(date);

# Q12: Which employees have taken the most leaves?
SELECT firstname,lastname, COUNT(leave_id)
FROM employee
left JOIN leaves USING(emp_id)
GROUP BY firstname,lastname;

# Q13: What is the total number of leave days taken company-wide?
SELECT count(*) AS total_leave_days FROM leaves;

# 5. Payroll and Compensation Analysis
# Q14: What is the total monthly payroll processed?
SELECT month(date) as month,SUM(total_amount) AS total_monthly_payroll
FROM payroll
group by month(date);

# Q15: What is the average bonus given per department?
SELECT jobdept, AVG(bonus) AS avg_bonus
FROM jobdepartment
left JOIN salarybonus USING(job_id)
GROUP BY jobdept
order by avg_bonus desc;

# Q16: Which department receives the highest total bonuses?
SELECT jobdept, SUM(bonus) AS highest_bonus
FROM jobdepartment
left JOIN salarybonus USING(job_id)
GROUP BY jobdept
ORDER BY highest_bonus DESC;

# Q17: What is the average value of total_amount after considering leave deductions?
SELECT AVG(annual + bonus) AS avg_net_salary
FROM salarybonus;

# 6. Employee Performance and Growth
# Q18: Which year had the highest number of employee promotions?
SELECT YEAR(Date_In) AS year, COUNT(*) AS promotions
FROM Qualification
GROUP BY (Date_In)
ORDER BY promotions DESC
LIMIT 1;
