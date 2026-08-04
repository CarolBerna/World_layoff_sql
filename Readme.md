# 📉 World Layoffs Data Cleaning \& Exploratory Data Analysis (MySQL)

## 📌 Project Overview

This project presents an end-to-end SQL analysis of global tech industry layoffs using **MySQL Workbench**. The project is split into two phases:

1. **Data Cleaning:** Transforming raw, messy dataset records into a clean, query-ready schema.
2. **Exploratory Data Analysis (EDA):** Uncovering layoff patterns, rolling monthly totals, geographic hotspots, and top annual impacts using advanced SQL techniques (CTEs, Window Functions, and Dense Ranks).

\---

## 🛠️ Phase 1: Data Cleaning Highlights

* **Staging Data:** Created staging tables (`layoffs\_staging`) to preserve the raw dataset.
* **Deduplication:** Applied `ROW\_NUMBER()` partitioned across all key attributes to identify and delete duplicate rows (`row\_num > 1`).
* **Standardization:**

  * Trimmed leading/trailing whitespace in company names using `TRIM()`.
  * Consolidated industry classifications (e.g., standardizing `'Crypto Currency'` and `'Cryptocurrency'` to `'Crypto'`).
  * Standardized country entries (e.g., removing trailing periods like `'United States.'`).
  * Converted string dates to standard SQL `DATE` data types (`YYYY-MM-DD`) via `STR\_TO\_DATE()` and `ALTER TABLE`.
* **Handling Nulls:** Utilized **self-joins** on `company` and `location` to populate missing industry values from matching non-null records.
* **Data Pruning:** Dropped entries where both `total\_laid\_off` and `percentage\_laid\_off` were `NULL`.

\---

## 📊 Phase 2: Exploratory Data Analysis (EDA) Key Insights

* **Workforce Liquidations:** Identified companies that underwent 100% layoffs (`percentage\_laid\_off = 1`).
* **Industry \& Location Impacts:** Aggregated total layoffs across industries and geographic regions to identify sectors with the highest workforce reductions.
* **Rolling Monthly Total:** Implemented a CTE with window function aggregation (`SUM() OVER(ORDER BY month)`) to visualize cumulative layoff trends over time.
* **Annual Top Rankings:** Utilized `DENSE\_RANK()` window functions partitioned by year to determine the top 5 companies, industries, and countries impacted annually.

\---

## 📁 Repository Structure

```text
world-layoff-sql/
│
├── data/
│   ├── layoffs\_raw.csv        <-- Original raw dataset
│   └── layoffs\_cleaned.csv    <-- Final cleaned dataset
│
├── scripts/
│   ├── 01\_data\_cleaning.sql   <-- MySQL data cleaning script
│   └── 02\_EDA.sql     <-- MySQL EDA script
│
└── README.md                  <-- Project documentation

