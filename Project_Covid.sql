select * from [dbo].[CovidDeaths1]
where continent is not null
order by 3,4

select * from [dbo].[CovidVaccinations1]

--Select Data that we wil be using for query
--select location, date, total_cases, new_cases, total_deaths, population
--from CovidDeaths1

--Total Cases VS. Tota Death (Country wise)

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from CovidDeaths1
where location like '%America%' and continent is not null


-- Total Cases Vs. Population (Pecentage of Population that affected Covid)

Select location, date, total_cases,population, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS Deathpercentage
from CovidDeaths1


--Countries with Highest Infection Rate VS. Population
Select location, population,
MAX(total_cases) as Highest_Infection_Count, 
MAX(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS Percent_Population_Infected
from CovidDeaths1
group by location, population
order by Percent_Population_Infected desc

--Highest Death Count Per Population BY Continent
 Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
 from CovidDeaths1
 where continent is not null
 group by continent
 order by Total_Death_Count desc

--Countries with Highest Death Count Per Population 
 Select location, MAX(cast(total_deaths as int)) as Total_Death_Count
 from CovidDeaths1
 where continent is not null
 group by location
 order by Total_Death_Count desc


--Continents with highest death count
 Select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
 from CovidDeaths1
 where continent is not null
 group by continent
 order by Total_Death_Count desc

--Global Numbers 

Select  SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/ NULLIF (SUM(cast(new_cases as int)),0)*100 as DeathPercent
from CovidDeaths1
where continent is not null
--group by date
order by 1,2

--VIEW Table Vaccinations

select * from CovidVaccinations1

--JOIN Both Tables

select * from CovidDeaths1 as d
join CovidVaccinations1 as vac
 on d.location=vac.location
 and d.date=vac.date


--Looking at Total Population VS. Vacinations

select d.date, d.location, d.continent, d.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeaths1 as d
join CovidVaccinations1 as vac
 on d.location=vac.location
 and d.date=vac.date
 where d.continent is not null
 order by 2,3



 --USE CTE

 With PopVsVac (date, location, continent, population, new_vaccinations, RollingPeopleVaccinated)

 as
 (
 select d.date, d.location, d.continent, d.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeaths1 as d
join CovidVaccinations1 as vac
 on d.location=vac.location
 and d.date=vac.date
 where d.continent is not null
 --order by 2,3
 )
 select *, cast((RollingPeopleVaccinated/population) as bigint)*100
 from PopVsVac


 --TEMP TABLE

 Create Table #PercentPopulationVaccinated
 ( Date DATETIME,
   Location nvarchar(255),
   continent nvarchar (255),
   population numeric,
   new_vaccination numeric,
 )

 

 insert into #PercentPopulationVaccinated
 select d.date, d.location, d.continent, d.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeaths1 as d
join CovidVaccinations1 as vac
 on d.location=vac.location
 and d.date=vac.date
 where d.continent is not null
 --order by 2,3

 select *, cast((RollingPeopleVaccinated/population) as bigint)*100
 from #PercentPopulationVaccinated

 drop table #PercentPopulationVaccinated
 

 --CREATE VIEW

 Create View PercentPopulationVaccinated as 
 select d.date, d.location, d.continent, d.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeaths1 as d
join CovidVaccinations1 as vac
 on d.location=vac.location
 and d.date=vac.date
 where d.continent is not null
 --order by 2,3

 select * from PercentPopulationVaccinated 