-- Q1. Write a code to check NULL values
SELECT 
    SUM(CASE WHEN `Province` IS NULL THEN 1 ELSE 0 END) AS Province_NULLs,
    SUM(CASE WHEN `Country/Region` IS NULL THEN 1 ELSE 0 END) AS Country_Region_NULLs,
    SUM(CASE WHEN `Latitude` IS NULL THEN 1 ELSE 0 END) AS Latitude_NULLs,
    SUM(CASE WHEN `Longitude` IS NULL THEN 1 ELSE 0 END) AS Longitude_NULLs,
    SUM(CASE WHEN `Date` IS NULL THEN 1 ELSE 0 END) AS Date_NULLs,
    SUM(CASE WHEN `Confirmed` IS NULL THEN 1 ELSE 0 END) AS Confirmed_NULLs,
    SUM(CASE WHEN `Deaths` IS NULL THEN 1 ELSE 0 END) AS Deaths_NULLs,
    SUM(CASE WHEN `Recovered` IS NULL THEN 1 ELSE 0 END) AS Recovered_NULLs
FROM `ig_clone`.`corona virus dataset`;

-- Q2. If NULL values are present, update them with zeros for all columns.
-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Run the update statement
UPDATE `ig_clone`.`corona virus dataset`
SET 
    `Latitude` = IFNULL(`Latitude`, 0),
    `Longitude` = IFNULL(`Longitude`, 0),
    `Confirmed` = IFNULL(`Confirmed`, 0),
    `Deaths` = IFNULL(`Deaths`, 0),
    `Recovered` = IFNULL(`Recovered`, 0);

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;



-- Q3. Check total number of rows
SELECT COUNT(*) AS TotalRows
FROM `ig_clone`.`corona virus dataset`;

-- Q4. Check what is start_date and end_date
SELECT 
    MIN(`Date`) AS StartDate,
    MAX(`Date`) AS EndDate
FROM `ig_clone`.`corona virus dataset`;

-- Q5. Number of months present in dataset
SELECT COUNT(DISTINCT DATE_FORMAT(`Date`, '%Y-%m')) AS NumberOfMonths
FROM `ig_clone`.`corona virus dataset`;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(`Date`, '%Y-%m') AS Month,
    AVG(`Confirmed`) AS AvgConfirmed,
    AVG(`Deaths`) AS AvgDeaths,
    AVG(`Recovered`) AS AvgRecovered
FROM `ig_clone`.`corona virus dataset`
GROUP BY Month;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    Month,
    Confirmed, 
    Deaths, 
    Recovered 
FROM (
    SELECT 
        DATE_FORMAT(`Date`, '%Y-%m') AS Month,
        `Confirmed`, 
        `Deaths`, 
        `Recovered`,
        COUNT(*) AS Frequency,
        ROW_NUMBER() OVER (PARTITION BY DATE_FORMAT(`Date`, '%Y-%m') ORDER BY COUNT(*) DESC) AS RowNum
    FROM `ig_clone`.`corona virus dataset`
    GROUP BY Month, `Confirmed`, `Deaths`, `Recovered`
) AS sub
WHERE RowNum = 1;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(`Date`) AS Year,
    MIN(`Confirmed`) AS MinConfirmed,
    MIN(`Deaths`) AS MinDeaths,
    MIN(`Recovered`) AS MinRecovered
FROM `ig_clone`.`corona virus dataset`
GROUP BY Year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(`Date`) AS Year,
    MAX(`Confirmed`) AS MaxConfirmed,
    MAX(`Deaths`) AS MaxDeaths,
    MAX(`Recovered`) AS MaxRecovered
FROM `ig_clone`.`corona virus dataset`
GROUP BY Year;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    DATE_FORMAT(`Date`, '%Y-%m') AS Month,
    SUM(`Confirmed`) AS TotalConfirmed,
    SUM(`Deaths`) AS TotalDeaths,
    SUM(`Recovered`) AS TotalRecovered
FROM `ig_clone`.`corona virus dataset`
GROUP BY Month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(`Confirmed`) AS TotalConfirmed,
    AVG(`Confirmed`) AS AvgConfirmed,
    VARIANCE(`Confirmed`) AS VarConfirmed,
    STDDEV(`Confirmed`) AS StdevConfirmed
FROM `ig_clone`.`corona virus dataset`;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    DATE_FORMAT(`Date`, '%Y-%m') AS Month,
    SUM(`Deaths`) AS TotalDeaths,
    AVG(`Deaths`) AS AvgDeaths,
    VARIANCE(`Deaths`) AS VarDeaths,
    STDDEV(`Deaths`) AS StdevDeaths
FROM `ig_clone`.`corona virus dataset`
GROUP BY Month;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(`Recovered`) AS TotalRecovered,
    AVG(`Recovered`) AS AvgRecovered,
    VARIANCE(`Recovered`) AS VarRecovered,
    STDDEV(`Recovered`) AS StdevRecovered
FROM `ig_clone`.`corona virus dataset`;

-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    `Country/Region`, 
    SUM(`Confirmed`) AS TotalConfirmed
FROM `ig_clone`.`corona virus dataset`
GROUP BY `Country/Region`
ORDER BY TotalConfirmed DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT 
    `Country/Region`, 
    SUM(`Deaths`) AS TotalDeaths
FROM `ig_clone`.`corona virus dataset`
GROUP BY `Country/Region`
ORDER BY TotalDeaths ASC
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case
SELECT 
    `Country/Region`, 
    SUM(`Recovered`) AS TotalRecovered
FROM `ig_clone`.`corona virus dataset`
GROUP BY `Country/Region`
ORDER BY TotalRecovered DESC
LIMIT 5;
