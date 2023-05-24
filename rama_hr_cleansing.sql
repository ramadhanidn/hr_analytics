create database hr_analytics;

use hr_analytics;


select* from hr;

-- 1. Change column name in Table
ALTER TABLE hr 
CHANGE COLUMN ï»¿id emp_id VARCHAR(50) null;

DESCRIBE hr;

-- 2. Change data format in birthdate column to 'YYYY-MM-DD'
SELECT birthdate from hr;

set sql_safe_updates = 0;

update hr
set birthdate = case
	when birthdate like	'%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    when birthdate like	'%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else null
end;

-- Change data format in birthdate column to Date
alter table hr
modify column birthdate date;

describe hr; 

-- 3. Change data format in hire_date column to 'YYYY-MM-DD'
select * from hr limit 5;

update hr
set hire_date = case
	when hire_date like	'%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    when hire_date like	'%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    else null
end;

select hire_date from hr;

alter table hr
modify column hire_date date;

describe hr;

-- 4. Change data format of termdate
select termdate from hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', 
				  date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), 
                  '0000-00-00')
WHERE true;

set sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

update hr
set termdate = NULL
where termdate = '0000-00-00';

describe hr;
select * from hr limit 5;

-- 5. Add Age column
alter table hr
add column age int;

update hr
set age = timestampdiff(year, birthdate, current_date());

select *
from hr
limit 10;

