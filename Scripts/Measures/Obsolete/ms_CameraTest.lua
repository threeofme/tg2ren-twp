-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_046_StartDialog"
----
----	with this measure the player can start a dialog with another sim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	-- the action number for the courting
	local CourtingActionNumber = 0
	
	-- case for talk need
	if not(AliasExists("Destination")) then
		return
	end
	
	if not ai_StartInteraction("", "Destination", 350, 100) then
		return
	end

	-- only a player should be able to start a quests
	if IsGUIDriven() and DynastyIsPlayer("") then
		if (QuestTalk("","Destination")) then
			StopMeasure()
			return
		end
	end


	chr_AlignExact("", "Destination", 128)

	SetState("", STATE_LOCKED, true)
	SetState("Destination", STATE_LOCKED, true)

	AlignTo("Destination", "")
	AlignTo("", "Destinationa")

	local index = 1
	while true do
		local value = GetDatabaseValue("Positions", index, "label")
		if not value then
			break
		end

		---------------------------------------------------
		if GetInsideBuilding("", "BuildingSim") then
			CameraIndoorGetBuilding("BuildingCam")
			if not(GetID("BuildingSim") == GetID("BuildingCam")) then
				CameraIndoorSetBuilding("BuildingSim")
				Sleep(1)
			end		
		elseif CameraIndoorGetBuilding("BuildingCam") then
			ExitBuildingWithCamera()
			Sleep(1)
		end

		CameraBlend(1.0,1)
		CameraLock(value,"")
		---------------------------------------------------
		Sleep(1)
	
		PlayAnimationNoWait("", "talk")
	
		MsgSay("", "@T%1SN:$N$N#E[HP_NEUTRAL]Dies ist Test-Text für die Kameraposition:$N$N"..value, GetID(""))
	
		StopAnimation("")
	
		index = index + 1
	end

	CameraBlend(1.0,2)
	CameraUnlock()

	SetState("", STATE_LOCKED, false)
	SetState("Destination", STATE_LOCKED, false)

end

function CleanUp()

	if(AliasExists("Destination")) then
		RemoveProperty("Destination","InTalk")
		StopAnimation("Destination")
	end

	RemoveProperty("", "InTalk")
	StopAnimation("")
	
end

