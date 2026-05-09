create database loan_approved;
use loan_approved;

-- Basic Sql Quries

-- 1. View the first 10 records from the table. 
select * from loan_approved_clean limit 10;

-- 2. Count the total number of loan applications. 
select count(*) as total_applications from loan_approved_clean;


-- 3. List all unique property areas.
select distinct(Property_Area) from loan_approved_clean ;

-- 4. Show all applicants who are self-employed and have an income above 5000.
select * from loan_approved_clean where Self_Employed = 'Yes' and ApplicantIncome > 5000;
select count(*) from loan_approved_clean where Self_Employed = 'Yes' and ApplicantIncome > 5000;


-- 5. Find the total number of approved loans. 
select count(*) from loan_approved_clean where Loan_Status = 'Y';

-- 6. Find average loan amount by education level.
select round(avg(LoanAmount),2)as avg_Loan_Amount from loan_approved_clean group by Education;

-- 7. Find average total income (Applicant + Coapplicant) by marital status.
select round(avg(ApplicantIncome + CoapplicantIncome),2)as Total_Income from loan_approved_clean group by Married;
select Married, round(avg(applicantincome + coapplicantincome),2) as avg_totalincome from loan_approved_clean group by Married;

-- 8. Show average loan amount by credit history. 
select avg(LoanAmount) from loan_approved_clean group by Credit_History;
select credit_history,round(avg(loanamount),2) as avg_loanamount from loan_approved_clean group by credit_history;

-- 9. Find total applications and approval rate by gender. 
select Gender,
 count(*) as total_applications, 
 sum(case when Loan_Status = 'Y' then 1 else 0 end) as Approvels,
round(sum(case when Loan_Status = 'Y' then 1 else 0 end) /count(*)*100,2) as Approvel_Rate
from loan_approved_clean group by Gender;

-- 10. Show approval rate by property area. 
select Property_Area,
round(sum(case when Loan_Status = 'Y' then 1 else 0 end) * 100 / count(*),2) as Approvel_Rate
from loan_approved_clean group by Property_Area;

-- 11. Show applicants who are graduates, not self-employed, and have loan amount greater than 150. 
select * from loan_approved_clean where Education = 'Graduate' and Self_Employed = 'No' and LoanAmount >150;

-- 12. Display approved loans from urban area with good credit history. 
select * from loan_approved_clean where Property_Area = 'Urban' and Credit_History = 1 and Loan_Status = 'Y';

-- 13. List top 5 applicants with highest total income. 
select ApplicantIncome ,(ApplicantIncome+ CoapplicantIncome) as Total_Income from loan_approved_clean order by Total_Income desc limit 5;
select * , applicantincome+coapplicantincome as  total_income from loan_approved_clean order by total_income desc limit 5;

-- 14. Create derived columns for total income for each applicant.
select * ,(ApplicantIncome+ CoapplicantIncome) as Total_Income from loan_approved_clean;

-- 15. Classify applicants into income groups (Low, Medium, High) based on applicant income. 
select Loan_Id, ApplicantIncome,
case
	when ApplicantIncome > 3000 then 'Low'
    when ApplicantIncome between 3000 and 7000 then 'Medium'
    else 'High'
end as Income_Group
from loan_approved_clean;

-- 16. Find average loan amount for each income group. 
select
case
	when ApplicantIncome > 3000 then 'Low'
    when ApplicantIncome between 3000 and 7000 then 'Medium'
    else 'High'
end as Income_Group,
round(avg(LoanAmount),2) as avg_loan_amount
from loan_approved_clean group by Income_Group;

-- 17. Find applicants whose loan amount is greater than the overall average loan amount.
select * from loan_approved_clean where LoanAmount > (select avg(LoanAmount) from loan_approved_clean);

-- 18. Identify the property area with the highest average total income.
select Property_Area,
round(avg(ApplicantIncome + CoapplicantIncome),2) as avg_total_income from loan_approved_clean
group by Property_Area
order by avg_total_income;

-- 19. List all applicants whose income is above the average income of their education category. Not Got
select * from loan_approved_clean where ApplicantIncome > ( select avg(ApplicantIncome) from loan_approved_clean group by Education);

-- 20. Rank applicants based on total income (highest income rank = 1).
select * ,(ApplicantIncome + CoapplicantIncome) as Total_Income,
rank() over(order by (ApplicantIncome + CoapplicantIncome) desc
) as Total_Rank
from loan_approved_clean;

-- 21. Show average loan amount per property area using a window function. 
select * ,avg(LoanAmount) over(partition by Property_Area) as Avg_Loan_Amount from loan_approved_clean;

-- 22. Calculate approval rate by education using grouping or window function. 
select Education, count(*) as Total_Applicants,
sum(
	case
		when Loan_Status = 'Y' then 1 else 0 end
	) as Approved_Loan,	
round(sum(case
			when Loan_Status = 'Y' then 1 else 0 end
) * 100 / count(*),2) as Approval_Rate
from loan_approved_clean
group by Education;

--  23 Compare approval rate by credit history and education level to find which combination performs best.
select Credit_History, Education, count(*) as Total_Applicants,
round(sum(
	case
		when Loan_Status = 'Y' then 1 else 0 end
)* 100 / count(*),2) as Approval_Rate 
from loan_approved_clean group by Education,Credit_History order by Approval_Rate desc;

--  24 Find the combination of property area and education with the highest approval rate. 
select Property_Area,Education,
round(sum(
	case
		when Loan_Status = 'Y' then 1 else 0 end
)*100/count(*),2) as Approval_rate
from loan_approved_clean
group by Property_Area,Education
order by Approval_rate desc;

-- 25. Compare approval rate for self-employed vs non-self-employed applicants by credit history.
select Self_Employed,Credit_History,count(*) as Total_Applicants,
round(sum(
	case
		when Loan_Status = 'Y' then 1 else 0 end
)*100/count(*),2) as Approval_Rate
from loan_approved_clean group by Credit_History,Self_Employed
order by Credit_History,Approval_Rate desc;

