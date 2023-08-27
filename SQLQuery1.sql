select * from portfolio..covidDeath
order by 3,4;

----select * from portfolio..covidVaccination
----order by 3,4;

select location,date, new_cases ,total_cases,total_deaths, population from portfolio..covidDeath
order by 1,2;

--total death on total case percent
select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercent from portfolio..covidDeath
order by 1,2;

--death percencent against cases India 
select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercent from portfolio..covidDeath
WHERE location like '%India%'
order by 1,2;

--Total case VS population india
-- case percent V population India
select location,date, total_cases,population, (total_cases/population)*100 as CasePercent from portfolio..covidDeath
WHERE location like '%India%'
order by 1,2;

--Countries with max infection case against population
select location, population, MAX(total_cases) as highestCase, MAX((total_cases/population))*100 as HighestCasePercent from portfolio..covidDeath
--WHERE location like '%states%'
group by location, population
order by HighestCasePercent desc;

--Total death counts
select location, MAX(total_deaths)as TotalDeath from portfolio..covidDeath
where continent is not null
group by location
order by TotalDeath desc;

--by continent
select continent, MAX(total_deaths)as TotalDeath from portfolio..covidDeath
where continent is not null
group by continent
order by TotalDeath desc;

--global number Total death and totalcases

select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeath, (SUM(new_deaths)/SUM(new_cases))*100  as TotalDeathPercent from portfolio..covidDeath
where continent is not null

order by 1,2 desc;

--Total population vs total vaccination

Select death.continent, death.location, death.date, death.population,vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by death.location order by
death.location,death.date) as AddedPeopleVacinated
from portfolio..covidDeath death
join portfolio..covidVaccination  vac
  on death.location = vac.location
  and death.date = vac.date
  where death.continent is not null
order by 2,3

--Use CTE 
--With PopvsVac (continent,location, date, population,new_vaccinations,AddedPeopleVacinated) 
--as
--(
--Select death.continent, death.location, death.date, death.population,vac.new_vaccinations
--, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by death.location order by
--death.location,death.date) as AddedPeopleVacinated
--from portfolio..covidDeath death
--join portfolio..covidVaccination  vac
--  on death.location = vac.location
--  and death.date = vac.date
--  where death.continent is not null
-- )
-- Select *, (AddedPeopleVacinated/population)*100 as AddedVaccinatedPercent
-- from PopvsVac;


 --Temp Table
-- DROP Table if exists #PercentPopulationVaccinated
-- create Table #PercentPopulationVaccinated
-- (
-- Continent nvarchar(255),
-- Location nvarchar(255),
-- Date datetime,
-- population numeric,
-- New_vaccinations numeric,
-- AddedPeopleVaccinated numeric
--)
--insert into #PercentPopulationVaccinated
--Select death.continent, death.location, death.date, death.population,vac.new_vaccinations
--, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by death.location order by
--death.location,death.date) as AddedPeopleVaccinated
--from portfolio..covidDeath death
--join portfolio..covidVaccination  vac
--  on death.location = vac.location
--  and death.date = vac.date
-- -- where death.continent is not null

--   Select *, (AddedPeopleVaccinated/population)*100 
-- from #PercentPopulationVaccinated ;


---Create view 

Create View  PercentPopulationVaccinated as 
Select death.continent, death.location, death.date, death.population,vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by death.location order by
death.location,death.date) as AddedPeopleVaccinated
from portfolio..covidDeath death
join portfolio..covidVaccination  vac
  on death.location = vac.location
  and death.date = vac.date
 where death.continent is not null

 select * from PercentPopulationVaccinated