function Init()
	Weather_SetWeather("Fine", 80.0)
	Weather_SetParticles(0.0)
	Weather_SetLight(0.75)
	Weather_SetWind(0.25)
	Weather_SetCloudFactor(0.1)
	
end

function Run()	
	Sleep(Rand(40)+40)
end

function Cleanup()
end
