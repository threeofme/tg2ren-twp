function Init()
	Weather_SetParticles(0.85)
	Weather_SetLight(0.8)
	Weather_SetWind(0.4)
	Weather_SetCloudFactor(0.85)
	if Weather_GetSeason()~=3 then
	    Weather_SetSoundLoop("ambient/rain_loop/rain_loop+0.wav", 1.0, 0, 0.4)
	end
end

function Run()
	Sleep(120.0 + Weather_Rand(30))	
	local chanceForRain
	local chanceForStorm
	local chanceForClouds
	local chanceForFine
	
	local Random = Weather_Rand(100)
	
	if Weather_GetSeason()==0 then 		--spring
		chanceForRain = 20
		chanceForStorm = 10
		chanceForClouds = 30
		if (Random < chanceForStorm) then
			Weather_SetWeather("Storm", 20.0)
		elseif (Random < chanceForRain) then
			Weather_SetWeather("Rain", 20.0)
		elseif (Random < chanceForClouds) then
			Weather_SetWeather("Cloudy", 20.0) 
		else
			Weather_SetWeather("Fine", 10.0)
		end
	elseif Weather_GetSeason()==1 then 	--summer
		chanceForRain = 10
		chanceForStorm = 5
		chanceForClouds = 30
		if (Random < chanceForStorm) then
			Weather_SetWeather("Storm", 20.0)
		elseif (Random < chanceForRain) then
			Weather_SetWeather("Rain", 20.0)
		elseif (Random < chanceForClouds) then
			Weather_SetWeather("Cloudy", 20.0) 
		else
			Weather_SetWeather("Fine", 10.0)
		end
	elseif Weather_GetSeason()==2 then 	--fall
		chanceForRain = 25
		chanceForStorm = 15
		chanceForFine = 30
		if (Random < chanceForStorm) then
			Weather_SetWeather("Storm", 20.0)
		elseif (Random < chanceForRain) then
			Weather_SetWeather("Rain", 20.0)
		elseif (Random < chanceForFine) then
			Weather_SetWeather("Fine", 10.0)
		else
			Weather_SetWeather("Cloudy", 20.0) 
		end
	else					--winter
		chanceForRain = 20
		chanceForStorm = 10
		chanceForFine = 30
		if (Random < chanceForStorm) then
			Weather_SetWeather("Storm", 20.0)
		elseif (Random < chanceForRain) then
			Weather_SetWeather("Rain", 20.0)
		elseif (Random < chanceForFine) then
			Weather_SetWeather("Fine", 10.0)
		else
			Weather_SetWeather("Cloudy", 20.0) 
		end
	end
end

function Cleanup()
end
