/*
Queries used for Tableau Project
*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From coviddeathscsv2
where continent is not null 
order by 1,2;

- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(new_deaths) as TotalDeathCount
From coviddeathscsv2
Where continent is not null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;

-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeathscsv2
Group by Location, Population
order by PercentPopulationInfected desc;


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeathscsv2
Group by Location, Population, date
order by PercentPopulationInfected desc;


