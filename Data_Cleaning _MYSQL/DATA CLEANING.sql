#DATA CLEANING

SELECT * 
FROM layoffs;

#Creating Duplicate table for cleaning

CREATE TABLE layoffs_new
LIKE layoffs;

INSERT layoffs_new
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_new;

#Inserting Row Numbers

with duplicate_cte AS
(SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_new
)
SELECT * 
FROM duplicate_cte
WHERE row_num >1;

SELECT *
FROM layoffs_new
WHERE company = 'Casper';

#Duplicating again for altering data

CREATE TABLE `layoffs_new2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_new2;

INSERT into layoffs_new2
	SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_new;

SELECT * 
FROM layoffs_new2
WHERE row_num >1;

#Deleting Duplicates

DELETE 
FROM layoffs_new2
WHERE row_num>1;

#Standardize DATA

SELECT trim(Company)
FROM layoffs_new2;

UPDATE layoffs_new2
set company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_new2;

#Checking For Mistakes

SELECT * 
FROM layoffs_new2
WHERE industry LIKE 'Crypto%';

#Correcting the Mistakes

UPDATE layoffs_new2
set industry = 'Crypto'
WHERE industry like 'Crypto%';

SELECT DISTINCT country
FROM layoffs_new2
WHERE country LIKE 'United%';

UPDATE layoffs_new2
set country = TRIM(Trailing '.' FROM country)
WHERE country LIKE 'United State%';

#Changing the data types

SELECT `date`
FROM layoffs_new2;

#Changing the Data Formats

UPDATE layoffs_new2
set date = str_to_date(`date`,'%m/%d/%Y');

ALTER table layoffs_new2
Modify column `date` DATE;

SELECT  * 
FROM layoffs_new2;

#Checking for NUll Values

SELECT *
FROM layoffs_new2
WHERE industry = ''
OR industry IS NULL;

SELECT  * 
FROM layoffs_new2
WHERE company= 'Airbnb';

UPDATE layoffs_new2
set industry = NULL
WHERE industry = '';

#Updating NULL values to their Values Where It can be Updated

UPDATE layoffs_new2 t1
	JOIN layoffs_new2 t2
    on t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is NULL
AND t2.industry is NOT NULL;

SELECT  * 
FROM layoffs_new2
WHERE company LIKE 'Ball%';

SELECT *
FROM layoffs_new2;

#Removing the NUll Valued Data that does not sure

SELECT * 
FROM layoffs_new2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_new2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

#Droping the Column Row Number

ALTER TABLE layoffs_new2
DROP column row_num;

SELECT * 
FROM layoffs_new2;









