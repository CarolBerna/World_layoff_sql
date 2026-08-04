# 📉 World Layoffs Data Cleaning \& Exploratory Data Analysis (MySQL)

## 📌 Project Overview

This project presents an end-to-end SQL analysis of global tech industry layoffs using **MySQL Workbench**. The project is split into two phases:

1. **Data Cleaning:** Transforming raw, messy dataset records into a clean, query-ready schema.
2. **Exploratory Data Analysis (EDA):** Uncovering layoff patterns, rolling monthly totals, geographic hotspots, and top annual impacts using advanced SQL techniques (CTEs, Window Functions, and Dense Ranks).

\---

## 🛠️ Phase 1: Data Cleaning Highlights

* **Staging Data:** Created staging tables (`layoffs\\\_staging`) to preserve the raw dataset.
* **Deduplication:** Applied `ROW\\\_NUMBER()` partitioned across all key attributes to identify and delete duplicate rows (`row\\\_num > 1`).
* **Standardization:**

  * Trimmed leading/trailing whitespace in company names using `TRIM()`.
  * Consolidated industry classifications (e.g., standardizing `'Crypto Currency'` and `'Cryptocurrency'` to `'Crypto'`).
  * Standardized country entries (e.g., removing trailing periods like `'United States.'`).
  * Converted string dates to standard SQL `DATE` data types (`YYYY-MM-DD`) via `STR\\\_TO\\\_DATE()` and `ALTER TABLE`.
* **Handling Nulls:** Utilized **self-joins** on `company` and `location` to populate missing industry values from matching non-null records.
* **Data Pruning:** Dropped entries where both `total\\\_laid\\\_off` and `percentage\\\_laid\\\_off` were `NULL`.

\---

## 📊 Phase 2: Exploratory Data Analysis (EDA) Key Insights

* **Workforce Liquidations:** Identified companies that underwent 100% layoffs (`percentage\\\_laid\\\_off = 1`).
* **Industry \& Location Impacts:** Aggregated total layoffs across industries and geographic regions to identify sectors with the highest workforce reductions.
* **Rolling Monthly Total:** Implemented a CTE with window function aggregation (`SUM() OVER(ORDER BY month)`) to visualize cumulative layoff trends over time.
* **Annual Top Rankings:** Utilized `DENSE\\\_RANK()` window functions partitioned by year to determine the top 5 companies, industries, and countries impacted annually.
* Funding vs. Layoff Volume: Evaluated top-funded companies (using `MAX(funds\_raised\_millions)`) against total headcount reductions to analyze corporate capital efficiency.
* Capital Loss in Shut Down Companies: Identified companies undergoing complete 100% workforce liquidation (`percentage\_laid\_off = 1`) and quantified the total capital lost in those shutdowns.
* Stage Severity Analysis: Aggregated total, average, and percentage-based layoff intensity across funding stages (e.g., Post-IPO, Series A–J), revealing how enterprise maturity correlates with workforce cuts.
* Year-over-Year Stage Progression: Tracked how layoff distributions across funding stages evolved annually from early-stage startups to mature public companies.



## 

