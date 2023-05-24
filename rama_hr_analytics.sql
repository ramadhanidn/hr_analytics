-- Analytics
Select *
from hr;

-- What is the average length of employment for employees who have been terminated?
select department, 
	   round(avg(datediff(termdate, hire_date)/365), 2) as timeterm_years
from hr
where termdate is not null and termdate <= curdate()
group by department
order by timeterm_years desc;

-- How many job title in company?
select department,count(distinct(jobtitle))
from hr
group by department;


-- Which jobtitle has the highest turnover rate?
select jobtitle, department, total ,total_term, round((total_term/total)*100, 2) as ratio 
from (select jobtitle, department,
	   count(*) as total, 
       sum(case 
			when termdate is not null and termdate <= curdate() 
            then 1 
            else 0 
            end) as total_term
from hr
where age > 18
group by jobtitle, department) as subquery
order by total_term desc, ratio desc;

select sub.jobtitle, h.department, total, total_term, round((total_term/total)*100, 2) as ratio 
from (select jobtitle, 
	   count(*) as total, 
       sum(case 
			when termdate is not null and termdate <= curdate() 
            then 1 
            else 0 
            end) as total_term
from hr
where age > 18
group by jobtitle, department) as sub
left join (select distinct(jobtitle) as h_jobtitle, department from hr) as h
on sub.jobtitle = h_jobtitle
order by total_term desc, ratio desc;


-- Which deparment has the highest turnover rate?
select department, total, total_term, round((total_term/total)*100, 2) as ratio 
from (select department, 
	   count(*) as total, 
       sum(case 
			when termdate is not null and termdate <= curdate() 
            then 1 
            else 0 
            end) as total_term
from hr
where age > 18
group by department) as subquery
order by total_term desc, ratio desc;

-- How has the company's employee count changed over time based on hire and term dates?
with nett as (select Year, hires, terminations, hires-terminations as nett_emp
from (select year(hire_date) as Year, count(hire_date) as hires, count(termdate) as terminations
	  from hr
      group by Year
      ) as subquery
order by Year)
select Year, hires, terminations, nett_emp,
	   sum(nett_emp) over (order by Year) as Total_emp
       from nett;

-- What is the tenure distribution for each department?



-- Categorizing age into group
select case
			WHEN age BETWEEN 20 AND 25 THEN '18-23'
			WHEN age BETWEEN 26 AND 30 THEN '24-28'
			WHEN age BETWEEN 31 AND 35 THEN '29-33'
			WHEN age BETWEEN 36 AND 40 THEN '34-38'
			WHEN age BETWEEN 31 AND 45 THEN '39-43'
			WHEN age BETWEEN 46 AND 50 THEN '44-48'
            WHEN age BETWEEN 51 AND 55 THEN '49-53'
			ELSE '55 More'
            END AS group_age, count(*) total
from hr
where termdate is null
group by group_age
order by group_age;

-- Hiring per Year
select year(hire_date) Year_Hiring, count(hire_date) as hire_count
from hr
group by Year_Hiring
order by Year_hiring;

-- Termination per Year
select year(termdate) Year_Term, count(*) as term_count
from hr
where termdate is not null
group by Year_Term
order by Year_Term;

-- Join Hire and Termination Table
with hire_counts as (select year(hire_date) as Year_Hiring, 
							count(*) as hire_count
					 from hr
					 group by Year_Hiring
                     order by Year_hiring
                     ),
	term_counts as (select year(termdate) Year_Term, 
						   count(*) as term_count
					from hr
					where termdate is not null
					group by Year_Term
					order by Year_Term)
select coalesce(Year_Hiring, Year_Term) as Year, hire_count, term_count
from hire_counts
left join term_counts
on Year_Hiring = Year_Term
union
select coalesce(Year_Hiring, Year_Term) as Year, hire_count, term_count
from hire_counts
right join term_counts
on Year_Hiring = Year_Term;

select race, count(*) as count_race
from hr
where termdate is null
group by race
order by count_race desc;


