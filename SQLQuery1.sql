SELECT *
FROM [Covid deaths]

SELECT location, date, population, total_cases, new_cases, total_deaths
FROM [Covid deaths]
ORDER BY 1,2

--Deaths Per Case
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPerCase
FROM [Covid deaths]
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPerCase
FROM [Covid deaths]
WHERE location = 'United Kingdom'
ORDER BY 1,2

--Death Per Population
SELECT location, population, (CAST(total_deaths AS INT)) AS Max_Deaths, MAX(total_deaths/population)*100 AS MaxDeathPerPop
FROM [Covid deaths]
GROUP BY location, population
ORDER BY 4 DESC

--Cases Per Poulation in the United Kingdom
SELECT location, date, total_cases, population, ROUND((total_cases/population)*100, 3) AS CasePerPop
FROM [Covid deaths]
WHERE location = 'United Kingdom'
ORDER BY 1,2

--Countries With Highest Cases Per Population
SELECT location, population, MAX(total_cases) AS Max_Case, MAX(total_cases/population)*100 AS MaxCasePerPop
FROM [Covid deaths]
GROUP BY location, population
ORDER BY 4 DESC

--Countries With Highest Deaths Per Population
SELECT location, population, MAX(CAST(total_deaths AS INT)) AS Max_Deaths, MAX(total_deaths/population)*100 AS MaxDeathPerPop
FROM [Covid deaths]
GROUP BY location, population
ORDER BY 4 DESC

--Death Count Per Continent
SELECT continent, MAX(CAST(total_deaths AS INT)) AS Max_Deaths
FROM [Covid deaths]
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Max_Deaths DESC

--Global Death Figures
SELECT date, SUM(CAST(new_deaths AS INT)) AS Deaths, SUM(new_cases) AS Cases --(SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS WorldDeathPerCase
FROM [Covid deaths]
GROUP BY date
ORDER BY 1, 3

--Number of People Vaccinated Globally
SELECT cd.date, cd.location, cd.continent, cd.population, cv.new_vaccinations
FROM [Covid deaths] cd
JOIN [Covid vaccinations] cv
ON cd.date = cv.date
AND cd.location = cv.location
WHERE cd.continent IS NOT NULL

--Running Total of Number of People Vaccinated Globally
SELECT cd.date, cd.location, cd.continent, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.date) AS RollingCountVac
FROM [Covid deaths] cd
JOIN [Covid vaccinations] cv
ON cd.date = cv.date
AND cd.location = cv.location
WHERE cd.continent IS NOT NULL
ORDER BY 2, 3

--Running Total Percentage Vaccinated Globally
WITH table1 AS
(SELECT cd.date AS date, cd.location AS location, cd.continent AS continent, cd.population AS pop, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.date) AS RollingCountVac
FROM [Covid deaths] cd
JOIN [Covid vaccinations] cv
ON cd.date = cv.date
AND cd.location = cv.location
WHERE cd.continent IS NOT NULL)
SELECT *, (RollingCountVac/pop)*100 AS RunningCountPerct
FROM table1
ORDER BY location, continent

--CREATING VIEWS
CREATE VIEW 
RunningCountPerct AS
WITH table1 AS
(SELECT cd.date AS date, cd.location AS location, cd.continent AS continent, cd.population AS pop, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.date) AS RollingCountVac
FROM [Covid deaths] cd
JOIN [Covid vaccinations] cv
ON cd.date = cv.date
AND cd.location = cv.location
WHERE cd.continent IS NOT NULL)
SELECT *, (RollingCountVac/pop)*100 AS RunningCountPerct
FROM table1

CREATE VIEW
GlobalDeathFigs AS
SELECT date, SUM(CAST(new_deaths AS INT)) AS Deaths, SUM(new_cases) AS Cases 
FROM [Covid deaths]
GROUP BY date
