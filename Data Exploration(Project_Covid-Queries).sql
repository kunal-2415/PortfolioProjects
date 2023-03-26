--Use ProjectPortfolio

--1. Select Data that we are going to use. 

select location, date, total_cases, new_cases,total_deaths,population 
from covid_deaths Order By 1,2


--2. Looking at Total Cases vs Total deaths(Percentage of people died and infected)
--    Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths
where location = 'United Arab Emirates'
Order By 1,2


--3. looking total cases Vs Population.
--   Shows what percentage of population got covid

select location, date, Population, total_cases, (total_cases/Population)*100 as DeathPercentage
from covid_deaths
where location = 'United Arab Emirates'
Order By 1,2


--4. Looking at countries with highest infection rate compared to population.

select location, Population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/Population))*100 as PercentPopulationInfected
from covid_deaths
Group By Location, Population
Order By PercentPopulationInfected desc

 
--5. Showing countries with highest death count per population

select location, MAX(cast(Total_deaths as int))as TotalDeathCount
from covid_deaths
where continent is NOT NULL
Group By Location
Order By TotalDeathCount desc


-- Now Breaking Things Down By Continent
--6. Showing continents with highest death count per population

select Continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
from covid_deaths
where continent is NOT NULL
Group By Continent
Order By TotalDeathCount desc


--7. Global Numbers.

select date, SUM(New_cases) as TotalCases, SUM(cast(New_deaths as int)) as TotalDeaths,
SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
from covid_deaths 
--Where Location = 'United Arab Emirates'(change date to location)
Where continent is NOT NULL
Group BY date
Order By 1,2


--8. Showing overall Cases, deaths and death percentage.

select SUM(New_cases) as TotalCases, SUM(cast(New_deaths as int)) as TotalDeaths,
SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
from covid_deaths 
Where continent is NOT NULL
Order By 1,2


-- 9. JOIN Both the tables

select * from 
ProjectPortfolio..covid_deaths dea
JOIN
ProjectPortfolio..Covid_vaccination vac
ON dea.location = vac.location
AND dea.date = vac.date	


--10. Looking at total population Vs total vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from covid_deaths dea
JOIN covid_vaccination vac
ON
dea.location = vac.location
AND 
dea.date = vac.date
WHERE dea.continent IS NOT NULL
Order By 2,3


-- 11. Exploring Total Population Vs Total Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location,
dea.date) as RollingPeopleVaccinated
from covid_deaths dea
JOIN covid_vaccination vac
ON
dea.location = vac.location
AND 
dea.date = vac.date
WHERE dea.continent IS NOT NULL
Order By 2,3


-- 12. Now we are going to use CTE(Common Table Expressions)

With PopvsVac (Continent, Location, date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location,
dea.date) as RollingPeopleVaccinated
--,	(RollingPeopleVaccinated)*100
from covid_deaths dea
JOIN covid_vaccination vac
ON
dea.location = vac.location
AND 
dea.date = vac.date
WHERE dea.continent IS NOT NULL
--Order By 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopVsVac


-- 13. Using TEMP Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(250),
Location nvarchar(250),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location,
dea.date) as RollingPeopleVaccinated
--,	(RollingPeopleVaccinated)*100
from covid_deaths dea
JOIN covid_vaccination vac
ON
dea.location = vac.location
AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--Order By 2,3
select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


-- 14. Creating Views to store data for later Visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location,
dea.date) as RollingPeopleVaccinated
--,	(RollingPeopleVaccinated)*100
from covid_deaths dea
JOIN covid_vaccination vac
ON
dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--Order By 2,3


--Select * from PercentPopulationVaccinated
 
