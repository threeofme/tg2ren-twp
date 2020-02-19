function Run()

	GetSettlement("Owner","TheCity")
	if not ai_CreateMutex("TheCity") then
		return
	end

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand 
	local ActionDistance = 100
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--check if destination is too far from city
	GetPosition("TheCity","CityPos")
	if GetInsideBuilding("Destination","CurrentBuilding") then
		GetPosition("CurrentBuilding","BuildingPos")
		if GetDistance("BuildingPos","CityPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	else
		GetPosition("Destination","DestPos")
		if GetDistance("CityPos","DestPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	end
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(0.5)
	
	--Get the office holder
	SimGetServantDynasty("", "ActorDyn")
	
	local found = false
	for i = 0,2 do
		if DynastyGetMember("ActorDyn",i,"Actor") then
			if GetSettlementID("Actor") == GetSettlementID("") then
				if GetImpactValue("Actor", 227) then -- 227 = CommandCityGuard
					found = true
					break
				end
			end
		end
	end		
		
	--SetMeasureRepeat(TimeOut)
	SimGetWorkingPlace("","Workbuilding")
	SetRepeatTimer("Workbuilding", GetMeasureRepeatName(), TimeOut)

	if found == false then
		feedback_MessageCharacter("Destination",
			"@L_PRIVILEGES_112_DETAINCHARACTER_MSG_VICTIM_HEAD_+0",
			"@L_PRIVILEGES_112_DETAINCHARACTER_MSG_VICTIM_BODY_+1",GetID("ActorDyn"),GetID("Destination"),GetID("TheCity"))
	else
		feedback_MessageCharacter("Destination",
			"@L_PRIVILEGES_112_DETAINCHARACTER_MSG_VICTIM_HEAD_+0",
			"@L_PRIVILEGES_112_DETAINCHARACTER_MSG_VICTIM_BODY_+0",GetID("Actor"),GetID("Destination"),GetID("TheCity"))
	end

	CityAddPenalty("TheCity","Destination",PENALTY_PRISON,duration)

end

function CleanUp()
	ai_ReleaseMutex("TheCity", "")
end


function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

