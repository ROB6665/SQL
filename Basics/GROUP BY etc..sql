use week;

select * from sales;

SELECT 	LOCATION , count(DOO) AS ORDERS from sales
group by LOCATION
HAVING ORDERS>50
order by ORDERS desc;


SELECT CATAGORIES,LOCATION, count(*) AS ORDERS FROM SALES
GROUP BY CATAGORIES , LOCATION
HAVING LOCATION = 'DELHI'
ORDER BY ORDERS DESC;

alter table SALES
ADD column AGE INT;

SELECT * FROM SALES;

alter table SALES
DROP COLUMN AGE;

ALTER TABLE SALES 
RENAME COLUMN CATAGORIES TO CATEGORIES;

SELECT * FROM SALES;

alter table SALES
ADD  column AGE INT AFTER CUSTOMER_NAME;

alter table SALES
DROP COLUMN AGE;

SELECT * FROM SALES;

SET SQL_SAFE_UPDATES=0;



UPDATE SALES SET QUANTITY = 16 WHERE ORDER_ID = 1;

UPDATE SALES 
SET AGE = 20+rand()*45 WHERE AGE=1 ;

SELECT * FROM SALES;

