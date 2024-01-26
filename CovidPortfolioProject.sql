Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--*************************************************************************************************************
--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

Select Location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2

--*************************************************************************************************************	
--Looking at total Cases vs Total Deaths
Select Location,date,total_cases,total_deaths, ((cast(total_deaths as int)/total_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%India%'
order by 1,2

--*************************************************************************************************************
--Looking at total cases vs population
Select Location,date,total_cases,population, (total_cases/population)*100 as CasePercentage
From PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2

--*************************************************************************************************************	
--Looking at Countries with Highest Infection Rate compared to Population
Select Location,MAX(total_cases) as HighestInfectionCount,population, MAX((total_cases/population))*100 as CasePercentage
From PortfolioProject..CovidDeaths
--where location like '%India%'
Group by location,population
order by CasePercentage desc

--*************************************************************************************************************
--Showing Countries with highest death count per population
Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
Group by location
order by TotalDeathCount desc

--*************************************************************************************************************
--Let's Break things down by Continent

--Showing continents with the highest death count per population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--*************************************************************************************************************
--Global Numbers
Select Sum(new_cases) as total_cases,Sum(cast(new_deaths as int)) as total_deaths,Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%India%'
--Group by date
order by 1,2

--*************************************************************************************************************
--Looking at Total Pop vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location
,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

With PopvsVac (Continent,Location,Date,Population,NewVaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location
,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *,(RollingPeopleVaccinated/population)*100
From PopvsVac

--*************************************************************************************************************
--Temp Table


Drop table if exists PercentPopVaccinated
Create Table PercentPopVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location
,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/population)*100
From PercentPopVaccinated

--*************************************************************************************************************
--Creating view to store data for later visualization

Create View PercentVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location
,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentVaccinated


--*************************************************************************************************************











