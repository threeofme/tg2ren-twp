-------------------------------------------------------------------------------
----
----	OVERVIEW "as_218_UseWeatherRocket"
----
----	with this artifact, the player can make rain
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "WeatherRocket"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	if GetInsideBuilding("","CurrentBuilding") then
		MsgQuick("","@L_ALCHEMIST_006_HAVEVISION_FAILURES_+3")
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("") 
	local TimeOut = mdata_GetTimeOut(MeasureID)
	MeasureSetNotRestartable()
	GetPositionOfSubobject("","Game_Wrist_r", "ParticleSpawnPos")			
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(4)
	if RemoveItems("","WeatherRocket",1)>0 then
		PlaySound3D("","Locations/branding_iron/branding_iron+1.wav", 1.0)
		StartSingleShotParticle("particles/weatherrocket.nif", "ParticleSpawnPos",1,5)
		Sleep(Time-4)
		PlaySound3D("","Effects/combat_cannon_shot/combat_cannon_shot+0.wav", 1.0)
		--PlayAnimation("","cheer_02")
		SetMeasureRepeat(TimeOut)
		
		if Weather_GetValue(0) > 0 then
			Weather_SetWeather("Fine", 10.0)
		else
			Weather_SetWeather("Rain", 10.0)
		end
			
	
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

