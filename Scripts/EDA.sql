-- EXPLORATORY DATA ANALYSIS

-- Review cleaned dataset
SELECT * 
FROM layoffs_staging3;

-- 1. High-Level Metrics
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;
-- Companies with 100% workforce layoffs
SELECT *
FROM layoffs_staging3 
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Total layoffs per company
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY company
ORDER BY 2  Desc;

-- Date range of dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging3 ;

-- Total layoffs by industry, country, year, and company stage
SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2  Desc;

SELECT country, SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY country
ORDER BY 2  Desc;

SELECT  year(`date`), SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY year(`date`)
ORDER BY 1  Desc;

SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 Desc;

SELECT substring(`date`, 1,7) as `MONTH` , SUM(total_laid_off)
FROM layoffs_staging3
WHERE substring(`date`, 1,7)  IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH`ASC;

-- 2. Rolling Monthly Layoffs Trend
WITH Rolling_Total as 
(
SELECT substring(`date`, 1,7) as `MONTH` , SUM(total_laid_off) as total
FROM layoffs_staging3
WHERE substring(`date`, 1,7)  IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH`ASC
)
SELECT `MONTH` , total,
SUM(total) OVER(ORDER BY `MONTH`) as rolling_total
FROM Rolling_Total ;

SELECT company,year(`date`), SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY company , year(`date`)
ORDER BY 3 desc;
 
 -- 3. Top 5 Rankings Per Year (Dense Rank Analysis)

-- Top 5 Companies per Year
 WITH company_year(company,years,total_laid_off)as 
 (
 SELECT company,year(`date`), SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY company , year(`date`)
),
Company_year_ranking as
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off Desc) as Ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_ranking
WHERE ranking <=5
;

-- Top 5 Industries per Year
 WITH industry_year(industry,years,total_laid_off)as 
 (
 SELECT industry,year(`date`), SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY industry , year(`date`)
),
industry_year_ranking as
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off Desc) as Ranking
FROM industry_year
WHERE years IS NOT NULL
)
SELECT *
FROM industry_year_ranking
WHERE ranking <=5
;

-- Top 5 Countries per Year
 WITH country_year(company,years,total_laid_off)as 
 (
 SELECT country,year(`date`), SUM(total_laid_off) 
FROM layoffs_staging3
GROUP BY country , year(`date`)
),
Country_year_ranking as
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off Desc) as Ranking
FROM country_year
WHERE years IS NOT NULL
)
SELECT *
FROM country_year_ranking
WHERE ranking <=5
;

SELECT company, MAX(funds_raised_millions) AS max_funds, SUM(total_laid_off) as total_layoff
FROM layoffs_staging3
WHERE total_laid_off is NOT NULL 
GROUP BY company
ORDER BY max_funds DESC
;

-- Top 10 Capital-Backed Companies vs. Total Layoffs
SELECT 
    company, 
    MAX(funds_raised_millions) AS total_funding_millions, 
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL 
GROUP BY company
ORDER BY total_funding_millions DESC
LIMIT 10;

-- Capital Lost in 100% Workforce Liquidationss

SELECT company,SUM(total_laid_off) as total_layoff,
MAX(funds_raised_millions) as total_funds_millions
FROM layoffs_staging3
WHERE percentage_laid_off = 1 AND total_laid_off IS NOT NULL
GROUP BY company,industry
ORDER BY total_funds_millions DESC 
;


SELECT company, stage, sum(total_laid_off) as total_layoffs
FROM layoffs_staging3
WHERE total_laid_off IS NOT NULL
GROUP BY company, stage
ORDER BY company asc;

SELECT company, stage,`date`
from layoffs_staging3
WHERE stage != 'unknown'
ORDER BY company ASC;

-- company layoffs at different stages
SELECT company ,stage, SUM(total_laid_off) as total_layoff
FROM layoffs_staging3
WHERE total_laid_off IS NOT NULL
GROUP BY company, stage
ORDER BY company ASC;

-- total layoffs at different  stages

SELECT stage , SUM(total_laid_off) as total_layoff
FROM layoffs_staging3
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY total_layoff DESC;

SELECT stage , AVG(total_laid_off) as Avg_layoff
FROM layoffs_staging3
WHERE stage IS NOT NULL 
GROUP BY stage
ORDER BY Avg_layoff Desc;

-- Average Layoff Scale & Intensity by Stage
SELECT stage , AVG(CAST(percentage_laid_off AS DECIMAL(10,2)))as avg_percentage_layoff
FROM layoffs_staging3
WHERE stage IS NOT NULL 
GROUP BY stage
ORDER BY avg_percentage_layoff DESC;

-- Year-over-Year Stage Progression
SELECT  year(`date`) as years, stage , sum(total_laid_off) as total_layoff
FROM layoffs_staging3
WHERE stage IS NOT NULL 
GROUP BY years , stage
ORDER BY stage ASC ,years;