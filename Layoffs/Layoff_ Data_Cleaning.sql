Create database layoff;

use layoff;

Create table layoffs
(Company varchar(50),
Location varchar(50), 
Industry varchar(50), 
Total_laid_off int, 
Percentage_laid_off	float,
Date text,
Stage varchar(50),
Country	varchar(50),
Funds_raised_millions int);

-- LOAD DATA INFILE '{"C:/Users/keyst/OneDrive/Desktop/New folder/Layoffs(1).csv"}'
-- INTO TABLE lay
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 ROWS;


show tables;

describe layoffs;

select * from layoffs;
# 1. Remove duplicates 
# 2. standardize the Data
# 3. Null values and Blank values 
# 4. Remove any columns or rows

# We will create a duplicate table of the raw table for performing further operation.
Create table layoffs_staging 
like layoffs;

# Our table is created but now we only have columns name in the table we need to insert data into this table.
select * from layoffs_staging;

# Now we will insert data in layoffs_staging table from layoffs table. 
insert layoffs_staging 
select * from layoffs;

# The data is inserted into the layoffs_staging table 
select * from layoffs_staging;

# We will create a new column of row numbers in the table to identify duplicate values.  
select * ,
row_number() over(Partition by company, industry, total_laid_off, percentage_laid_off,'date') as Row_num
from layoffs_staging;

# Now we will use the above query in the CTE to see duplicate value in our table if the Row num is greater than one that means those values are the duplicate values.
with duplicate_cte as 
(
select * ,
row_number() over(Partition by company,location, industry, total_laid_off, percentage_laid_off,'date', stage, country, funds_raised_millions) as Row_num
from layoffs_staging
)
select * from duplicate_cte
where Row_num > 1;

# Now we will create a new table which will does not contain any duplicate values.
CREATE TABLE `layoffs_staging2` (
  `Company` varchar(50) DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  `Industry` varchar(50) DEFAULT NULL,
  `Total_laid_off` int DEFAULT NULL,
  `Percentage_laid_off` float DEFAULT NULL,
  `Date` text,
  `Stage` varchar(50) DEFAULT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `Funds_raised_millions` int DEFAULT NULL, 
  `Row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# Our table is created but now it is empty it only contains the column names.
select * from layoffs_staging2;

# now we will insert values into the table 
insert into layoffs_staging2
select * ,
row_number() over(Partition by company,location, industry, total_laid_off, percentage_laid_off,'date', stage, country, funds_raised_millions) as Row_num
from layoffs_staging;

# before updating we need to turn off safe update mode in SQL.
set sql_safe_updates = 0;

# Now we will delete all the duplicate rows into the layoffs_staging2 table 
delete   
from layoffs_staging2
where row_num > 1;

# As we can see the duplicate rows has been deleted from the layoffs_staging2 table.
select *   
from layoffs_staging2
where row_num >1 ;

# Standardizing Data
select distinct(company), trim(company)
from layoffs_staging2;

# Now we will update the company column by triming that for removing blank unwanted spaces.
update layoffs_staging2 
set company = trim(company);

# The company column is updated now.
select *  from layoffs_staging2;

# Checking the types of industries in the table.
select distinct industry  
from layoffs_staging2;

# Now as we can see some industries values needs to be update.
select  *  
from layoffs_staging2
where industry like 'Crypto%';

# We will update CryptoCurrency to Crypto
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

# Checking the distinct locations 
select distinct location 
from layoffs_staging2 
order by 1;

# Checking the distinct Country 
select distinct Country 
from layoffs_staging2 
order by 1;

# we can se that we having issue in United States
select  * 
from layoffs_staging2 
where country like 'United States%'
order by 1;

# We can fix it using trailing 
select  distinct country, trim(trailing '.' from country)
from layoffs_staging2 
where country like 'United States%';

# Now we will update the value 
update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

# As we can see the United State issue is fixed now.
select distinct Country 
from layoffs_staging2 
order by 1;

# Checking the data type of Date column.
desc layoffs_staging2;

# Now we will change the data type of Date column text to date.
select Date,
str_to_date(Date, '%m-%d-%Y' )
from layoffs_staging2;

# Now we are updating the Date column 
update layoffs_staging2
set Date =  str_to_date(Date,'%m-%d-%Y');

# We successfully changed the text Date format
select * from layoffs_staging2;

# Now we will also convert the datatype of Date column text to Date
alter table layoffs_staging2
modify column date date;

# As we can see we successfully changed Date column datatype to Date.
desc layoffs_staging2;

# we are replacing blank to null values in industry column.
update layoffs_staging2
set industry = null
where industry = '';

# Now as we can see we replaced blanks values to null values in industry column
select * from layoffs_staging2
where industry = '' 
or industry is null;

select * from layoffs_staging2
where industry is null;

# Now we will do selfjoin the table 
select t1.industry, t2.industry 
from layoffs_staging2 as t1
join layoffs_staging2 as t2
on t1.company = t2.company
where (t1.industry is null or t1.industry ='')
and t2.industry is not null;

# Now we will update the table with self join and fill the null values in the industry column.
update layoffs_staging2 as t1
join layoffs_staging2 as t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

# As we can see now we only have one null value in the industry column. 
select Industry, count(date) as count from layoffs_staging2
group by industry
order by count ;

# Now we will see null in the total_laid_off and percentage_laid_off columns.
select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

# Now we will Delete the null values in the total_laid_off and percentage_laid_off columns.
delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

# Rows which contains null values in the total_laid_off and percentage_laid_off in both columns together are deleted now.
select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

# now we will drop the Row_num column because we do not need it anymore. 
Alter table layoffs_staging2
Drop column Row_num;

# Our Dataset is cleaned now. 
select * from layoffs_staging2;