--Use ProjectPortfolio

-- Queries For Data Visualization.

--1. Looking at countries with highest infection rate compared to population.

select location, Population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/Population))*100 as PercentPopulationInfected
from covid_deaths
Group By Location, Population
Order By PercentPopulationInfected desc


--2. Showing countries with highest death count per population.

select location, MAX(cast(Total_deaths as int))as TotalDeathCount
from covid_deaths
where continent is NOT NULL
Group By Location
Order By TotalDeathCount desc


-- 3. looking total cases Vs Population.
-- Shows what percentage of population got covid.

select location, date, Population, total_cases, (total_cases/Population)*100 as DeathPercentage
from covid_deaths
where location = 'United Arab Emirates'
Order By 1,2


--4. Looking at Total Cases vs Total deaths(Percentage of people died and infected)
--    Shows likelihood of dying if you contract covid in your country.

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths
where location = 'United Arab Emirates'
Order By 1,2 desc