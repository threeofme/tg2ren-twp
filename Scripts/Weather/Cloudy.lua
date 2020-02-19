function Init()
	Weather_SetParticles(0.0)
	Weather_SetLight(0.0)
	Weather_SetWind(0.4)
	Weather_SetCloudFactor(0.65)
end

function Run()
	Sleep(120.0 + Weather_Rand(30))	
	local chance
	if Weather_GetSeason()==0 then 		--spring
		chance = 20
	elseif Weather_GetSeason()==1 then 	--summer
		chance = 5
	elseif Weather_GetSeason()==2 then 	--fall
		chance = 40
	else					--winter
		chance = 30
	end
		
	if(Weather_Rand(100) < chance) then
		if Weather_GetSeason()==2 or Weather_GetSeason()==3 then
		    if Rand(4) == 3 then -- 25% chance of storm
			    Weather_SetWeather("Storm", 20.0)
			else
			    Weather_SetWeather("Rain", 20.0)
			end
		elseif Weather_GetSeason()==1 and Rand(10)  == 1 then --10% chance of storm
			Weather_SetWeather("Storm", 20.0)
		else
			Weather_SetWeather("Rain", 20.0)
		end
	elseif(Weather_Rand(70) < chance)  then -- weather remains cloudy
		Weather_SetWeather("Cloudy", 20.0) 
	else
		Weather_SetWeather("Fine", 10.0)
	end
end

function Cleanup()
end
