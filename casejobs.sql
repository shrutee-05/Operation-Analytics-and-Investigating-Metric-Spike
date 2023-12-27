CREATE DATABASE jobsinfo;
USE jobsinfo;

-- Case Study 1: Job Data Analysis
select * from job_data;
-- Jobs Reviewed Over Time:
-- Objective: Calculate the number of jobs reviewed per hour for each day in November 2020.
-- Your Task: Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.

SELECT DS AS DATE, COUNT(DISTINCT JOB_ID) AS JOB_REVIEWED, SUM(TIME_SPENT)/(60 * 60) AS PER_HOUR_TIME_SPEND, ROUND((COUNT(DISTINCT JOB_ID)/SUM(TIME_SPENT))*(60 * 60)) AS JOBS_REVIEWED_PER_HOUR_PER_DAY FROM JOB_DATA
WHERE DS >= '01-11-2020' AND DS <= '30-11-2020'
GROUP BY DS ORDER BY DS
DESC;

-- Throughput Analysis:
-- Objective: Calculate the 7-day rolling average of throughput (number of events per second).
-- Your Task: Write an SQL query to calculate the 7-day rolling average of throughput. Additionally, explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.

WITH DAILY_METRIC AS ( SELECT DS, COUNT(JOB_ID) AS JOB_REVIEW FROM JOB_DATA GROUP BY DS)
SELECT DS, JOB_REVIEW, AVG(JOB_REVIEW) OVER 
(ORDER BY DS ROWS BETWEEN 6 PRECEDING AND CURRENT ROW )AS THROUGHPUT 
FROM DAILY_METRIC ORDER BY
THROUGHPUT DESC ;

-- Language Share Analysis:
-- Objective: Calculate the percentage share of each language in the last 30 days.
-- Your Task: Write an SQL query to calculate the percentage share of each language over the last 30 days.

SELECT LANGUAGE,COUNT(LANGUAGE) AS LANGUAGE_COUNT, 
(COUNT(LANGUAGE)/(SELECT COUNT(*) FROM JOB_DATA)) * 100 AS Percentage_Share 
FROM JOB_DATA GROUP BY LANGUAGE ORDER BY LANGUAGE DESC ;

-- Duplicate Rows Detection:
-- Objective: Identify duplicate rows in the data.
-- Your Task: Write an SQL query to display duplicate rows from the job_data table.

SELECT * FROM (SELECT *, ROW_NUMBER() OVER 
(PARTITION BY JOB_ID) AS DUPLICATE_ROWS FROM JOB_DATA ) A_R
WHERE DUPLICATE_ROWS > 1;

-- -------------------------------------------------------------------------
