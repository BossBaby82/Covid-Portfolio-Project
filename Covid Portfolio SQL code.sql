select *from coviddeathscsv2
order by 3,4;
select * from covidvaccinationscsv
order by 3,4;
select location, date, total_cases, new_cases, total_deaths, population 
from coviddeathscsv2 order by 1,2;

-- now we want to know total cases vs total deaths--

select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercent
from coviddeathscsv2 order by 1,2;

-- now we want to know total cases vs population--

select location, date, total_cases, population, (total_cases / population)*100 as DeathPercent
from coviddeathscsv2 order by 1,2;

--Lets analyse which country has highest infection rate in our dataset--

select location, population, MAX(total_cases) as HighestInfectionRate, Max((total_cases / population))*100 as PercentPopulationInfected
from coviddeathscsv2 group by location, population order by PercentPopulationInfected desc;

-- looking at countries with high death count per population--

select location, max(total_deaths) as DeathCount
from coviddeathscsv2 
where continent is not null
group by location order by DeathCount desc;

-- looking at continents with high death count per population--

select continent, max(total_deaths) as DeathCount
from coviddeathscsv2 
where continent is not null and total_deaths>0coviddeathscsv2continent
group by continent order by DeathCount desc;


-- finding out total new cases and total deaths globally as percent--

Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_Cases)*100 as DeathPercentage
from coviddeathscsv2
where continent is not null 
order by 1,2;

-- Joining the table covid_deaths and covid_vaccinations--
-- finding out Total population vs vaccinated population--

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(new_vaccinations) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
from coviddeathscsv2 cd
join covidvaccinationscsv cv
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null
order by 2,3;


-- using CTE on previous query to find out RollingPeopleVaccinated percent--

With Popvsvac( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(new_vaccinations) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
from coviddeathscsv2 cd
join covidvaccinationscsv cv
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null
order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as percentRollingPeopleVaccinated 
  from Popvsvac;
  
  
-- Making a TEMP Table --

drop table if exists PercentPeopleVaccinated ;
create table PercentPeopleVaccinated (
Continent char(255),
Location char(255),
Date char(200),
Population numeric,
New_vaccinations numeric(10.100),
RollingPeopleVaccinated numeric(10,10)
);
Insert into PercentPeopleVaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(new_vaccinations) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
from coviddeathscsv2 cd
join covidvaccinationscsv cv
on cd.location = cv.location and cd.date = cv.date
;

select *, (RollingPeopleVaccinated/population)*100 
  from PercentPeopleVaccinated;
  

-- Creating View to store data for later visualizations--

create view PercentPeopleVaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(new_vaccinations) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
from coviddeathscsv2 cd
join covidvaccinationscsv cv
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null;

