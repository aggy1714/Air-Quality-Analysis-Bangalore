#Analysis

use air_quality_live;
select * from air_quality_live.air_quality_historic aqh;


#Seasonal Averages of Pollutant

select 
	case 
		when month(`date`)  in (12,1,2) then 'Winter'
		when month(`date`) in (3,4,5) then 'Spring'
		when month(`date`) in (6,7,8) then 'Summer'
		when month(`date`) in (9,10,11) then 'Autumn'
	end as seasons,
	round(avg(pm25),2) as avg_pm25,
	round(avg(pm10),2) as avg_pm10,
	round(avg(o3),2) as avg_o3,
	round(avg(no2),2) as avg_no2,
	round(avg(so2),2) as avg_so2,
	round(avg(co),2) as avg_co
from air_quality_live.air_quality_historic aqh 
group by seasons;


#Monthly Deviations of Pollutants Comparision

select  year(`date`) as years, monthname(`date`) as months,
	   round(stddev(pm25), 2) as stddev_pm25,
	   round(stddev(pm10), 2) as stddev_pm10,
	   round(stddev(o3), 2) as stddev_o3,
	   round(stddev(no2), 2) as stddev_no2,
	   round(stddev(so2), 2) as stddev_so2,
	   round(stddev(co), 2) as stddev_co
from air_quality_live.air_quality_historic aqh
group by years, months
order by years, field(months,'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');


	
#Percentage changes in pollutants
-- pm2.5
SELECT 
    date, 
    pm25, 
    (pm25 - LAG(pm25) OVER (ORDER BY date)) / LAG(pm25) OVER (ORDER BY date) * 100 AS percentage_change_pm25 
FROM air_quality_live.air_quality_historic aqh ;

-- pm10 
SELECT 
    date, 
    pm10, 
    (pm10 - LAG(pm10) OVER (ORDER BY date)) / LAG(pm25) OVER (ORDER BY date) * 100 AS percentage_change_pm25 
FROM air_quality_live.air_quality_historic aqh ;

-- o3
SELECT 
    date, 
    o3, 
    (o3 - LAG(o3) OVER (ORDER BY date)) / LAG(pm25) OVER (ORDER BY date) * 100 AS percentage_change_pm25 
FROM air_quality_live.air_quality_historic aqh ; 


# Statuses of Pollutants
-- create table air_quality_live.Monthly_Status_Of_Pollutants As
select year(`date`) as year, monthname(`date`) as Months,
		case 
			when avg(pm25) between 0 and 50 then "Good"
			when avg(pm25) between 51 and 100 then "Fair"
			when avg(pm25) between 101 and 150 then "Unhealthy for Sensitive Groups"
			else "Unhealthy"
		end as Monthly_Status_PM25,
		case 
			when avg(pm10) between 0 and 50 then "Good"
			when avg(pm10) between 51 and 100 then "Fair"
			when avg(pm10) between 101 and 250 then "Unhealthy for Sensitive Groups"
			else "Unhealthy" 
		end as Monthly_Status_PM10,
		case 
			when avg(o3) between 0 and 55 then "Good"
			when avg(o3) between 56 and 70 then "Fair"
			when avg(o3) between 71 and 85 then "Unhealthy for Sensitive Groups"
			else "Unhealthy" 			
		end as Montly_Status_O3,
		case 
			when avg(no2) between 0 and 55 then "Good"
			when avg(no2) between 56 and 100 then "Fair"
			when avg(no2) between 101 and 360 then "Unhealthy for Sensitive Groups"
			else "Unhealthy"			
		end as Monthly_Status_no2,
		case 
			when avg(so2) between 0 and 35 then "Good"
			when avg(so2) between 36 and 75 then "Fair"
			when avg(so2) between 76 and 185 then "Unhealthy for Sensitive Groups"
			else "Unhealthy"		 
		end as Monthly_Status_so2,
		case 
			when avg(co) between 0 and 4.4 then "Good"
			when avg(co) between 4.5 and 9.4 then "Fair"
			when avg(co) between 9.5 and 12.4 then "Unhealthy for Sensitive Groups"
			else "Unhealthy"		
		end Montly_Status_CO
from air_quality_live.air_quality_historic aqh 
group by year, months
order by year, months;

select * from air_quality_live.monthly_status_of_pollutants;
		
		
		
		
		
		
		
		
		

