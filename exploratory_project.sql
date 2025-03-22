SELECT * FROM covid_v.coviddeaths_clean;

SELECT COUNT(*) FROM coviddeaths_clean;

with duplicada_covid as
(
select *,
row_number() over(
partition by location,`date`,population) as row_num
from coviddeaths_clean
)
SELECT COUNT(*) FROM duplicada_covid where row_num >1;

CREATE TABLE `coviddeaths_clean2` (
  `iso_code` text,
  `continent` text,
  `location` text,
  `date` text,
  `population` text,
  `total_cases` text,
  `new_cases` text,
  `new_cases_smoothed` text,
  `total_deaths` text,
  `new_deaths` text,
  `new_deaths_smoothed` text,
  `total_cases_per_million` text,
  `new_cases_per_million` text,
  `new_cases_smoothed_per_million` text,
  `total_deaths_per_million` text,
  `new_deaths_per_million` text,
  `new_deaths_smoothed_per_million` text,
  `reproduction_rate` text,
  `icu_patients` text,
  `icu_patients_per_million` text,
  `hosp_patients` text,
  `hosp_patients_per_million` text,
  `weekly_icu_admissions` text,
  `weekly_icu_admissions_per_million` text,
  `weekly_hosp_admissions` text,
  `weekly_hosp_admissions_per_million` text,
  `Unnamed: 26` text,
  `Unnamed: 27` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into coviddeaths_clean2
select *,
row_number()over(
partition by location,`date`,population) as row_num
from coviddeaths_clean
;
SELECT * FROM covid_v.coviddeaths_clean2;

SELECT COUNT(*) FROM coviddeaths_clean2;

delete
from coviddeaths_clean2
where row_num>1;


-- total cases vs total deaths 

select location, `date`,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
from coviddeaths_clean2
where location = 'Argentina' and continent IS NOT NULL AND continent != 'NULL'
order by 1,2;

-- total cases vs population

select location, `date`,total_cases, population, (total_cases/population)*100 as contag_percentage
from coviddeaths_clean2
where location = 'Argentina' and continent IS NOT NULL AND continent != 'NULL'
order by 1,2;

-- countries with highest infection rates vs population
select location,population, max(total_cases) as highest_inf, max((total_cases/population)*100) as perc_population_inf
from coviddeaths_clean2
-- where location = 'Argentina'
group by location, population
order by 4 desc;

-- countries with highest death count vs population
select location, max(cast(total_deaths as signed)) as total_death_count
from coviddeaths_clean2
WHERE continent IS NOT NULL AND continent != 'NULL'
group by location
order by total_death_count desc
limit 10; 

-- by continent
select continent, max(cast(total_deaths as signed)) as total_death_count
from coviddeaths_clean2
WHERE continent IS NOT NULL AND continent != 'NULL'
group by continent
order by total_death_count desc; 

select location, max(cast(total_deaths as signed)) as total_death_count
from coviddeaths_clean2
WHERE continent IS  NULL or continent = 'NULL'
group by location
order by total_death_count desc; 

-- n° globales

select `date`,sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as death_perc
from coviddeaths_clean2
-- where location = 'Argentina' 
where continent IS NOT NULL AND continent != 'NULL'
group by `date`
order by 1,2;

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as death_perc
from coviddeaths_clean2
-- where location = 'Argentina' 
where continent IS NOT NULL AND continent != 'NULL'
order by 1,2;

