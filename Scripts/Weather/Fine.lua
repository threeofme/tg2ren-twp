function Init()
	Weather_SetParticles(0.0)
	Weather_SetLight(0.0)
	Weather_SetWind(0.1)
	Weather_SetCloudFactor(0.0)
end

function Run()
	Sleep(120.0 + Weather_Rand(40))
	
	--chance for clouds
	local chance
	if Weather_GetSeason()==0 then 		--spring
		chance = 20
	elseif Weather_GetSeason()==1 then 	--summer
		chance = 10
	elseif Weather_GetSeason()==2 then 	--fall
		chance = 40
	else					--winter
		chance = 30
	end
	
	local Random = Weather_Rand(100)
	if (Random < chance) then 
		Weather_SetWeather("Cloudy", 20.0)
	else
		Weather_SetWeather("Fine", 10.0)
	end
end

function Cleanup()
	local isnix
end
