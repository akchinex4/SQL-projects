---use the database
use work; 

--create a join table
select * from  Absenteeism_at_work a
left join compensation b
on a.ID = b.ID
left join Reasons r
on a.Reason_for_absence = r.Number 

--1. find the healthiest employees for the bonus
select * from Absenteeism_at_work 
where Social_drinker = 0 and Social_smoker = 0 
and (Body_mass_index between 18.5 and 25) and 
Absenteeism_time_in_hours < (select AVG(Absenteeism_time_in_hours) from Absenteeism_at_work) 

--2. compensation rate increase for non-smokers / budget $983,221 which is 0.68/hr which is $1,414 per employee per year
select COUNT(*) as [non smokers] from Absenteeism_at_work
where Social_smoker = 0

--optimising the query
select 
a.ID, 
r.Reason,
Month_of_absence,
Body_mass_index,
Education,
Age,

case when Body_mass_index < 18.5 then 'underweight'
     when Body_mass_index between 18.5 and 24.9 then 'Healthy weight'
	 when Body_mass_index between 25 and 30 then 'overweight'
	 when Body_mass_index > 30 then 'obese'
	 else 'unknown' end as [BMI Category],

case when Month_of_absence in (12,1,2) then 'winter'
     when Month_of_absence in (3,4,5) then 'spring'
	 when Month_of_absence in (6,7,8) then 'summer'
	 when Month_of_absence in (9,10,11) then 'fall'
	 else 'unknown' end as [Season Names],

case when Education in (1) then 'Highschool'
     when Education in (2) then 'Graduate'
	 when Education in (3) then 'Postgraduate'
	 when Education in (4) then 'Doctorate'
	 else 'unknown' end as [Education Category],

case when Age < 25 then 'young adult'
     when Age between 26 and 35 then 'Early Career'
	 when Age between 36 and 45 then 'Mid career'
	 when Age between 46 and 55 then 'Late career'
	 when Age between 56 and 65 then 'Near retirement'
	 when Age > 66 then 'Retired'
	 end as [Age Category],

Day_of_the_week,
Seasons,
Transportation_expense,
Education,
Son,
Social_drinker,
Social_smoker,
Pet,
Disciplinary_failure,
Work_load_Average_day,
Absenteeism_time_in_hours 

from Absenteeism_at_work a
left join compensation b
on a.ID = b.ID
left join Reasons r
on a.Reason_for_absence = r.Number 