(Total Deaths Per Country)
SELECT location, continent, MAX(population) AS Pop, MAX((CAST(total_deaths AS INT))) AS deaths, MAX(total_deaths/population)*100 AS DeathPerPop
FROM [Covid deaths]
WHERE continent is NOT NULL
GROUP BY location, continent

(Global Death Figures)
SELECT SUM(Pop) AS GlobalPop, SUM(deaths) AS Globaldeaths, (SUM(deaths)/SUM(Pop)*100) AS GlobalDeathPercent
FROM(SELECT location, continent, MAX(population) AS Pop, MAX((CAST(total_deaths AS INT))) AS deaths, MAX(total_deaths/population)*100 AS DeathPerPop
FROM [Covid deaths]
WHERE continent is NOT NULL
GROUP BY location, continent)t1

(Death Per Month Per Country)
SELECT location, continent, DATEADD(MONTH, DATEDIFF(MONTH, 0, date), 0) AS calc_date, MAX(population) AS Pop, MAX((CAST(total_deaths AS INT))) AS deaths, MAX((CAST(total_deaths AS INT))/population)*100 AS DeathPerPop
FROM [Covid deaths]
WHERE continent is NOT NULL
GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, date), 0), location, continent
ORDER BY 3

(Total Cases Per Country)
SELECT location, continent, MAX(population) AS Pop, MAX(total_cases) AS cases, MAX(total_cases/population)*100 AS CasesPerPop
FROM [Covid deaths]
WHERE continent is NOT NULL
GROUP BY location, continent

*Countries without cases

(Global Cases)
SELECT SUM(Pop) AS GlobalPop, SUM(cases) AS GlobalCases, (SUM(cases)/SUM(Pop)*100) AS GlobalCasesPercent
FROM(SELECT location, continent, MAX(population) AS Pop, MAX(total_cases) AS cases, MAX(total_cases/population)*100 AS CasesPerPop
FROM [Covid deaths]
WHERE continent is NOT NULL
GROUP BY location, continent)t1

(Death Per Month Per Country)
SELECT location, continent, DATEADD(MONTH, DATEDIFF(MONTH, 0, date), 0) AS calc_date, MAX(population) AS Pop, MAX(total_cases) AS cases, (MAX(total_cases)/MAX(population))*100 AS CasesPerPop
FROM [Covid deaths]
WHERE continent is NOT NULL
GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, date), 0), location, continent
ORDER BY 3

(Total Vaccintions Per Country)
SELECT v.location, v.continent, MAX(d.population) AS Pop, MAX(CAST(v.total_vaccinations AS INT)) AS vaccinations, MAX(CAST(v.people_vaccinated AS INT)) AS people_vacc, 
MAX(CAST(v.people_fully_vaccinated AS INT)) AS people_fullvacc, MAX(CAST(v.people_vaccinated AS INT))/MAX(d.population)*100 AS VaccPerPop, 
MAX(CAST(v.people_fully_vaccinated AS INT))/MAX(d.population)*100 AS FullyVaccPerPop
FROM [Covid vaccinations] v 
JOIN [Covid deaths] d
ON v.location = d.location
WHERE v.continent IS NOT NULL
GROUP BY v.location, v.continent

(Global Vaccination Figures)
SELECT SUM(Pop) AS GlobalPop, SUM(people_vacc) AS GlobalPeopleVacc, SUM(people_fullvacc) AS GlobalPeopleFullVacc, (SUM(people_vacc)/SUM(Pop))*100 AS GlobalVaccPerc,
(SUM(people_fullvacc)/SUM(Pop))*100 AS GlobalFullVaccPerc
FROM(SELECT v.location, v.continent, MAX(d.population) AS Pop, MAX(CAST(v.total_vaccinations AS BIGINT)) AS vaccinations, MAX(CAST(v.people_vaccinated AS BIGINT)) AS people_vacc, 
MAX(CAST(v.people_fully_vaccinated AS BIGINT)) AS people_fullvacc, MAX(CAST(v.people_vaccinated AS BIGINT))/MAX(d.population)*100 AS VaccPerPop, 
MAX(CAST(v.people_fully_vaccinated AS BIGINT))/MAX(d.population)*100 AS FullyVaccPerPop
FROM [Covid vaccinations] v 
JOIN [Covid deaths] d
ON v.location = d.location
WHERE v.continent IS NOT NULL
GROUP BY v.location, v.continent)T1

(Vaccinations Per Month Per Country)
SELECT v.location, v.continent, MAX(d.population) AS Pop, DATEADD(MONTH, DATEDIFF(MONTH, 0, v.date), 0) AS calc_date, MAX(CAST(v.total_vaccinations AS BIGINT)) AS vaccinations, MAX(CAST(v.people_vaccinated AS BIGINT)) AS people_vacc, 
MAX(CAST(v.people_fully_vaccinated AS BIGINT)) AS people_fullvacc, MAX(CAST(v.people_vaccinated AS BIGINT))/MAX(d.population)*100 AS VaccPerPop, 
MAX(CAST(v.people_fully_vaccinated AS BIGINT))/MAX(d.population)*100 AS FullyVaccPerPop
FROM [Covid vaccinations] v 
JOIN [Covid deaths] d
ON v.location = d.location
WHERE v.continent IS NOT NULL
GROUP BY v.location, v.continent, DATEADD(MONTH, DATEDIFF(MONTH, 0, v.date), 0)
ORDER BY DATEADD(MONTH, DATEDIFF(MONTH, 0, v.date), 0)


