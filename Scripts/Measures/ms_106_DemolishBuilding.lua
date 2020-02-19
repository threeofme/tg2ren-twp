-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_106_DemolishBuilding"
----
----	with this privilege the office bearer can demolish an enemy building
----	with structure lower than 30%
----
-------------------------------------------------------------------------------


function Run()
	--how far the Destination can be to start this action
	local MaxDistance = 3000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 400
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	GetSettlement("","CityAlias")
	--check if destination is too far from city
	GetPosition("CityAlias","CityPos")
	
	if not GetPosition("Destination","BuildingPos") then
		MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
		StopMeasure()
	end
	if GetDistance("BuildingPos","CityPos") > 10000 then
		MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
		StopMeasure()
	end
	
	
	--run to destination 
	if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,400) then
		return
	end
	
	Sleep(1)
	--Evacuate("Destination")
	--Sleep(1)
	--play animation
	PlayAnimationNoWait("","sentinel_idle")
	MsgSay("","@L_PRIVILEGES_106_DEMOLISHBUILDING_ACTOR_EXECUTOR",GetID("Destination"))
	
	--send message to buildingOwner
	GetSettlement("Destination","City")
	MsgNewsNoWait("Destination","","","building",-1,
		"@L_PRIVILEGES_106_DEMOLISHBUILDING_MSG_VICTIM_HEADLINE_+0",
		"@L_PRIVILEGES_106_DEMOLISHBUILDING_MSG_VICTIM_BODY_+0",GetID(""),GetID("Destination"),GetID("City"))
	
	--demolish building
	SetMeasureRepeat(TimeOut)
		
	--let the sims around Talk
	local Radius = 2000
	local WorkerCount = BuildingGetWorkerCount("Destination")
	local SimCount = BuildingGetSimCount("Destination")
	
	if (WorkerCount > 0) then
		for i=0, WorkerCount-1 do
			if BuildingGetWorker("Destination", i, "Worker") then
				SendCommandNoWait("Worker","PanicWorker")
			end
		end
	else
		for i=0,SimCount-1 do
			if BuildingGetSim("Destination", i, "Sim") then
				SendCommandNoWait("Sim","PanicResident")
			end
		end
	end
	chr_GainXP("",GetData("BaseXP"))
	ModifyHP("Destination",-GetHP("Destination"),false)

end

function PanicWorker()
	Sleep(2.5)
	AlignTo("", "Owner")
	Sleep(Rand(2))
	MsgSay("","@L_PRIVILEGES_106_DEMOLISHBUILDING_SCENE_PANIC_WORKER")
	PlayAnimation("", "appal")
end

function PanicResident()
	Sleep(2.5)
	AlignTo("", "Owner")
	Sleep(Rand(2))
	MsgSay("","@L_PRIVILEGES_106_DEMOLISHBUILDING_SCENE_PANIC_RESIDENT")
	PlayAnimation("", "appal")
end

function CleanUp()
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

