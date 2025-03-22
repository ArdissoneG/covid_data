SELECT * 
FROM coviddeaths_clean2 dea
join covidvac vac
	on dea.location = vac.location
    and dea.date = vac.date
WHERE (dea.continent IS not NULL and dea.continent != 'null') and (
 vac.continent IS not NULL and vac.continent != 'null');

-- total population vs vac
SELECT dea.continent, dea.location, dea.`date`, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.`date`)  as rolling_peoplevac
FROM coviddeaths_clean2 dea
join covidvac vac
	on dea.location = vac.location
    and dea.date = vac.date
WHERE (dea.continent IS not NULL and dea.continent != 'NULL') and (
 vac.continent IS not NULL and vac.continent != 'NULL')
order by 2,3;

-- con cte
with population_vs_vac (contient, location, `date`, population, new_vaccinations,rolling_peoplevac)
as
(
SELECT dea.continent, dea.location, dea.`date`, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.`date`)  as rolling_peoplevac
FROM coviddeaths_clean2 dea
join covidvac vac
	on dea.location = vac.location
    and dea.date = vac.date
WHERE (dea.continent IS not NULL and dea.continent != 'NULL') and (
 vac.continent IS not NULL and vac.continent != 'NULL')
order by 2,3
)
select *, (rolling_peoplevac/population)*100 as '%of_population_vacc'
from population_vs_vac;

-- con temp table

drop table if exists populationvsvac;
create temporary table populationvsvac(
continent varchar (50),
location varchar (50),
`date` datetime,
population varchar (50),
new_vaccinations varchar(50),
rolling_peoplevac int
);

insert into populationvsvac
SELECT dea.continent, dea.location, dea.`date`, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.`date`)  as rolling_peoplevac
FROM coviddeaths_clean2 dea
join covidvac vac
	on dea.location = vac.location
    and dea.date = vac.date
WHERE (dea.continent IS not NULL and dea.continent != 'NULL') and (
 vac.continent IS not NULL and vac.continent != 'NULL')
order by 2,3;

select *
from populationvsvac;

create view populationvsvac as
SELECT dea.continent, dea.location, dea.`date`, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.`date`)  as rolling_peoplevac
FROM coviddeaths_clean2 dea
join covidvac vac
	on dea.location = vac.location
    and dea.date = vac.date
WHERE (dea.continent IS not NULL and dea.continent != 'NULL') and (
 vac.continent IS not NULL and vac.continent != 'NULL')