-- 1. Create Staging Table to Preserve Raw Data

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
like layoffs;

INSERT layoffs_staging
select * 
from layoffs; 

-- 2. Identify & Remove Duplicates
CREATE TABLE `layoffs_staging3` (
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

insert into layoffs_staging3
SELECT * ,
ROW_NUMBER () OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging3
WHERE row_num  > 1;

-- Delete exact duplicates (row_num > 1)
DELETE 
FROM layoffs_staging3
WHERE row_num > 1;

select *
from layoffs_staging3 
where row_num > 1;

-- 3. Standardizing Data & Formatting
-- Trim white spaces in company names

SELECT DISTINCT trim(company) 
from layoffs_staging3;

UPDATE layoffs_staging3
SET company = trim(company);

SELECT * 
FROM layoffs_staging3;

SELECT DISTINCT industry
FROM layoffs_staging3
ORDER BY 1 ;

-- Standardize industry names (e.g., Crypto)

SELECT *
FROM layoffs_staging3
WHERE  industry LIKE "crypto%";

UPDATE layoffs_staging3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT  DISTINCT industry
FROM layoffs_staging3;

SELECT DISTINCT location
FROM layoffs_staging3
ORDER BY 1;

-- Standardize country names (e.g., remove trailing periods)

SELECT DISTINCT country
FROM layoffs_staging3
ORDER BY 1;

UPDATE layoffs_staging3
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging3
ORDER BY 1;

-- Convert date text to proper DATE format

SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging3
MODIFY COLUMN `date` DATE;

SELECT`date`
FROM layoffs_staging3;

-- 4. Handling Null & Blank Values
-- Replace blank strings in industry with NULL

SELECT*
FROM layoffs_staging3
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging3
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_staging3 
WHERE company = 'Airbnb';


UPDATE layoffs_staging3
SET industry = NULL
WHERE industry = '';

-- Populate missing industry values using self-join (matching company & location)

SELECT ls1.company ,ls2.company
FROM layoffs_staging3 as ls1
JOIN layoffs_staging3 as ls2
	ON ls1.company = ls2.company 
    AND ls1.location = ls2.location
WHERE (ls1.industry IS NULL or ls1.industry = '')
AND ls2.industry IS NOT NULL;   

UPDATE layoffs_staging3 as ls1
JOIN layoffs_staging3 as ls2
	ON ls1.company = ls2.company 
SET ls1.industry = ls2.industry  
WHERE ls1.industry IS NULL 
AND ls2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging3
WHERE company = 'Airbnb';


SELECT * 
FROM layoffs_staging3
WHERE industry IS NULL 
OR industry = '';

SELECT * 
FROM layoffs_staging3
WHERE company LIKE 'bally%';

SELECT*
FROM layoffs_staging3
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Remove records with no analytical value for layoff counts

DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging3;

-- 5. Final Cleanup removing unneccesary column
ALTER TABLE layoffs_staging3
DROP COLUMN row_num;
    




