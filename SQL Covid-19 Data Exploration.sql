Select *
From portfolioproject..CovidDeath
Order By 3,4 


Select location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeath
Order By 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
From portfolioproject..CovidDeath
Where location like '%India%'
Order By 1,2


--Looking at Totalcases Vs Population

Select location, date, total_cases, population,(total_deaths/total_cases) * 100 AS DeathPercentage
From portfolioproject..CovidDeath
--Where location like '%India%'
Order By 1,2

--Looking at Countries with highest infection rate compared to population

Select location, population, MAX(Total_Cases) AS HighestInCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected
From portfolioproject..CovidDeath
--Where location like '%India%'
Group by location, population
Order By PercentPopulationInfected DESC


-- SHowing Countries with Higest Death Count per population

Select location, MAX(cast(total_deaths as INT)) As TotalDeathCount
From portfolioproject..CovidDeath
--Where location like '%India%'
Where continent is not null
Group by location
Order By TotalDeathCount DESC


--LET'S BREAK THINGS DOWN BY CONTIENT

Select location, MAX(cast(total_deaths as INT)) As TotalDeathCount
From portfolioproject..CovidDeath
--Where location like '%India%'
Where continent is null
Group by location
Order By TotalDeathCount DESC

--sHOWING cONTINENT WITH HIGEST DEATH RATE

Select continent, MAX(cast(total_deaths as INT)) As TotalDeathCount
From portfolioproject..CovidDeath
--Where location like '%India%'
Where continent is not null
Group by continent
Order By TotalDeathCount DESC

--Global Numbers

Select Sum(new_cases) AS Total_Cases, Sum(cast(New_Deaths as INt)) As Total_death, Sum(cast(New_Deaths as INt))/SUM(New_cases)*100 AS DeathPercentage
From portfolioproject..CovidDeath
--Where location like '%India%'
Where continent is Not null
--Group By date
Order By 1,2


--Total population Vs Vaccinations

Select  CD.continent, CD.location, CD.date, cd.population, cv.new_vaccinations,SUM(Cast(cv.New_Vaccinations as int)) Over (Partition by Cd.Location
 order by cd.location, cd.date) AS RollingPeoplevaccinated,-- (RollingPeoplevaccinated/population)*100
From portfolioproject..CovidDeath CD
Join PortfolioProject..CovidVaccination CV
	ON CD.location = CV.location
	AND CD.date = CV.date
Where cd.continent is not null
Order by 2,3


--USE CTE

With PopvsVac (Continent, Location, Date, population, New_vaccinations, RollingPeoplevaccinated) as (
Select  CD.continent, CD.location, CD.date, cd.population, cv.new_vaccinations,SUM(Cast(cv.New_Vaccinations as int)) Over (Partition by Cd.Location
 order by cd.location, cd.date) AS RollingPeoplevaccinated-- (RollingPeoplevaccinated/population)*100
From portfolioproject..CovidDeath CD
Join PortfolioProject..CovidVaccination CV
	ON CD.location = CV.location
	AND CD.date = CV.date
Where cd.continent is not null
--Order by 2,3
)
Select *, (RollingPeoplevaccinated/population)
From PopvsVac



--Temp table

Drop Table If exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations Numeric,
RollingPeoplevaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select CD.continent, CD.location, CD.date, cd.population, cv.new_vaccinations, SUM(Cast(cv.New_Vaccinations as int)) Over (Partition by Cd.Location
 order by cd.location, cd.date) AS RollingPeoplevaccinated---(RollingPeoplevaccinated/population)*100
From portfolioproject..CovidDeath CD
Join PortfolioProject..CovidVaccination CV
	ON CD.location = CV.location
	AND CD.date = CV.date
--Where cd.continent is not null
--Order by 2,3

Select *, (RollingPeoplevaccinated/population)*100
From #PercentPopulationVaccinated
	

---Creating View to store data for later visualization

Create View PercentPopulationVaccinated As
Select CD.continent, CD.location, CD.date, cd.population, cv.new_vaccinations, SUM(Convert(int,cv.New_Vaccinations)) Over (Partition by Cd.Location
 order by cd.location, cd.date) AS RollingPeoplevaccinated---(RollingPeoplevaccinated/population)*100
From portfolioproject..CovidDeath CD
Join PortfolioProject..CovidVaccination CV
	ON CD.location = CV.location
	AND CD.date = CV.date
Where cd.continent is not null
--Order by 2,3

 