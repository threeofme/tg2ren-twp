-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_145_OrderASpying"
----
----	with this measure, the player can send a myrmidon to spy out an sim
----
-------------------------------------------------------------------------------

function Run()
	if not AliasExists("Destination") then
		return
	end
	
	SetProperty("Destination", "SpiedBy"..GetID(""))
	AddImpact("","spying",1,-1)
	MeasureSetNotRestartable()
	MsgMeasure("","@L_GENERAL_MEASURES_145_ORDERASPYING_ACTION_+0", GetID("Destination"))
			
	
	local WhatToDo
	local SpyTheHouse
	local i
	local k
	local Radius = 2000
	
	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end
	

	while true do

		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
		
		--what the spy should do
		WhatToDo = Rand(4)
		
		--simply move to the last known position of the victim
		if (WhatToDo == 0) then
			if GetInsideBuilding("Destination","Building") then
				GetOutdoorMovePosition("","Building","OutdoorMovePos")
				f_MoveTo("","OutdoorMovePos",GL_MOVESPEED_RUN,500)
			else
				f_MoveTo("","Destination",GL_MOVESPEED_RUN,1000)
			end
			AlignTo("","Destination")
			Sleep(1)
			k = Rand(2)
			if (k == 0) then
				PlayAnimation("","watch_for_guard")
			end
		--stand around and cogitate
		elseif (WhatToDo == 1) then
			local Houses = Find("","__F( (Object.GetObjectsByRadius(Building)=="..Radius.."))", "FindResult",1)
			if Houses > 0 then
				GetOutdoorMovePosition("","FindResult","OutdoorMovePos")
				f_MoveTo("","OutdoorMovePos",GL_MOVESPEED_RUN,400)
			end
			
			AlignTo("","Destination")
			Sleep(1)
			k = Rand(2)
			if (k == 0) then
				PlayAnimation("","cogitate")
			end
			
		--stand around and eat
		elseif (WhatToDo == 2) then	
			PlayAnimation("","watch_for_guard")
			
		--move to the home building of the victim 
		elseif (WhatToDo == 3) then
			SpyTheHouse = 1
			if GetHomeBuilding("Destination","VictimsHome") then
				GetOutdoorMovePosition("","VictimsHome","OutdoorMovePos")
				f_MoveTo("","OutdoorMovePos",GL_MOVESPEED_RUN ,500)
			
				--start observation
				while (SpyTheHouse == 1) do
					WhatToDo = Rand(4)
					--Go around the house
					if (WhatToDo == 0) then
						for i=1, 4 do
							if GetLocatorByName("VictimsHome", "Walledge"..i, "VictimsCorner"..i) then
								f_MoveTo("", "VictimsCorner"..i, GL_MOVESPEED_RUN, 50)
							end
							Sleep(1)
							k = Rand(2)
							if (k == 0) then
								PlayAnimation("","watch_for_guard")
							end
						end
					elseif (WhatToDo == 1) then
						if GetLocatorByName("VictimsHome", "Entry1", "VictimsEntry") then
							f_MoveTo("", "VictimsEntry", GL_MOVESPEED_RUN, 50)
						end
						Sleep(3)
					--cancel building observation
					else
						SpyTheHouse = 0
					end
				end
			end
		end
	
	Sleep (5)
	
	end
	
	
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	
	AddImpact("","spying",-1,-1)
	feedback_OverheadActionName("Owner")
	MsgMeasure("","")
	StopAnimation("")
	local Evidences = 0
	if HasProperty("", "SpiedByCount") then
		Evidences = GetProperty("", "SpiedByCount")
		RemoveProperty("", "SpiedByCount")
	end
	
	if AliasExists("Destination") then
		RemoveProperty("Destination", "SpiedBy"..GetID(""))
		if Evidences and Evidences > 0 then
			feedback_MessageCharacter("",
				"@L_GENERAL_MEASURES_145_ORDERASPYING_MSG_SUCCESS_HEAD_+0",
				"@L_GENERAL_MEASURES_145_ORDERASPYING_MSG_SUCCESS_BODY_+0",GetID(""),GetID("Destination"))	
		else
			feedback_MessageCharacter("",
				"@L_GENERAL_MEASURES_145_ORDERASPYING_MSG_FAILED_HEAD_+0",
				"@L_GENERAL_MEASURES_145_ORDERASPYING_MSG_FAILED_BODY_+0",GetID(""),GetID("Destination"))	
		end
	end
	if SimGetWorkingPlace("","SpyWorkBuilding") then
		f_MoveToNoWait("","SpyWorkBuilding")
	end
end

