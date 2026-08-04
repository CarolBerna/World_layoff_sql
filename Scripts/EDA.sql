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
