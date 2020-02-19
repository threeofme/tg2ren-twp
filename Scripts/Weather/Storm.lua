function Init()
	Weather_SetParticles(1.0)
	Weather_SetLight(1.0)
	Weather_SetWind(1.0)
	Weather_SetCloudFactor(1.0)
	if Weather_GetSeason()~=3 then
		Weather_SetSoundLoop("ambient/rain_strong_loop/rain_strong_loop+0.wav", 1.0, 0, 0.4)
	end
	Weather_SetSoundLoop("ambient/wind_stormy/wind_stormy+5.wav", 1.0, 1, 0.4)
end

function Run()
  if (Weather_GetSeason()==3) then
	  Sleep(Rand(10)+100)
	else
    local dauer = (Rand(10)+100)
    local anfang = 1.0
    local dr, wart
    Sleep(10)
    while dauer > anfang do
      dr = Rand(3)
	    Weather_PlaySound("ambient/lightning_thunder_strong/lightning_thunder_strong+"..dr..".wav", 1.0)
	    if dr == 0 then
		    wart = Rand(15)
	      Sleep(4.0 + wart)
				anfang = anfang +(4.0 + wart)
			elseif dr == 1 then
		    wart = Rand(10)
		    Sleep(13.0 + wart)
				anfang = anfang + (13.0 + wart)
			elseif dr == 2 then
		    wart = Rand(20)
		    Sleep(5.0 + wart)
				anfang = anfang + (5.0 + wart)
			end
   	end
	end
	
	local chanceForRain
	local chanceForStorm
	local chanceForClouds
	local chanceForFine
	
	local Random = Weather_Rand(100)
	
	if Weather_GetSeason()==0 then 		--spring
		chanceForRain = 20
		chanceForStorm = 2
		chanceForClouds = 40
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
		chanceForStorm = 1
		chanceForClouds = 40
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
		chanceForStorm = 5
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
		chanceForStorm = 3
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
