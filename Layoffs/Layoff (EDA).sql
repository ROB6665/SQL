# Exploratory Data Analysis (EDA)

# Using layoff database 
use layoff;

# See all the tables in the database.
show tables;

# Describe the table
desc layoffs_staging2;


# To view the dataset
Select * from layoffs_staging2;

# Creating a procedure by doing this we do not need to run the particular query again and again we just need to call it.
DELIMITER $$
create procedure ls()
begin
Select * from layoffs_staging2;
end $$
DELIMITER ;

# Now we do not need to write a query ---> (select * from layoffs_staging2) instead of that we just need to call procedure.
# Calling the procedure 
call ls();

select 
max(Total_laid_off) as Max_total_laid_off, 
max(percentage_laid_off) as Max_percentage_laid_off
from Layoffs_staging2;

select *
from Layoffs_staging2
where percentage_laid_off =1
order by Total_laid_off desc;

select *
from Layoffs_staging2
where percentage_laid_off =1
order by Funds_raised_millions desc;

select Company , sum(Total_laid_off) as Total_laid_off
from layoffs_staging2 
group by company
order by 2 desc;

select 
min(date) as Oldest_Date, 
max(date) as Latest_Date
from layoffs_staging2;

select Industry , sum(Total_laid_off) as Total_laid_off
from layoffs_staging2 
group by industry
order by 2 desc;

select Country , sum(Total_laid_off) as Total_laid_off
from layoffs_staging2 
group by Country
order by 2 desc;

select Year(Date) as Years , sum(Total_laid_off) as Total_laid_off
from layoffs_staging2 
group by Years
order by 1 desc;

select Stage , sum(Total_laid_off) as Total_laid_off
from layoffs_staging2 
group by Stage
order by 2 desc;

select substring(`date`,1,7) as Months, Sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by Months
order by 1 asc;
 
With Rolling_Total as 
(
select substring(`date`,1,7) as Months, Sum(total_laid_off) as Total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by Months
order by 1 asc
)
select Months , Total_off,Sum(Total_off) over(order by Months) as Rolling_Total
from Rolling_Total;

select Company, Year(`Date`) , sum(Total_laid_off) as Total_laid_off
from layoffs_staging2 
group by company,Year(`Date`)
order by 3 desc;

With company_year (Company,years,Total_laid_off) as
(
select Company, Year(`Date`) , sum(Total_laid_off) as Total_laid_off
from layoffs_staging2 
group by company,Year(`Date`)
), 
Company_year_rank as
(
select *,
dense_rank() over(partition by years order by Total_laid_off desc) as Ranking
 from company_year
 where years is not null
 )
select * from Company_year_rank 
where Ranking <= 5;

select Company ,Industry,
concat(Sum(Funds_raised_millions),' Million $') as Funds_Raised,
concat(Round(sum(percentage_laid_off * 100),0), ' %') as Percentage 
from layoffs_staging2
group by Company,Industry;

select  Company,sum(Total_laid_off) as Total_laid_off,
Sum(Funds_raised_millions) as Fund_Raised , 
Count(*) as Counts
from layoffs_staging2
group by Company 
having Counts > 4 
order by Fund_Raised desc;

select Company , Sum(Funds_raised_millions) as Fund_Raised from layoffs_staging2 
where company = 'Uber';

call ls();
