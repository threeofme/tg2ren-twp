-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_143_OrderAShadowing"
----
----	with this measure, the player can send a myrmidon to spy out an sim
----	after 2h the character sheet of the destination will be revealed
----
-------------------------------------------------------------------------------

function Run()
	if not AliasExists("Destination") then
		return
	end
	
	local TimeToShadow = 2
	
	AddImpact("","spying",1,-1)
	
	MsgMeasure("","@L_GENERAL_MEASURES_143_ORDERASHADOWING_ACTION_+0", GetID("Destination"))
	
	
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
	
	StartGameTimer(TimeToShadow)
	local DestDyn = GetDynasty("Destination","DestDynasty")
	local OwnerDyn = GetDynastyID("")
	SendCommandNoWait("","Progress")
	MeasureSetNotRestartable()
	while true do
		
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
		
		if CheckGameTimerEnd() then
			if not HasProperty("DestDynasty","BeeingShadowedBy"..OwnerDyn) then
				SetProperty("DestDynasty","BeeingShadowedBy"..OwnerDyn,1)
				feedback_MessageCharacter("",
					"@L_GENERAL_MEASURES_143_ORDERASHADOWING_MSG_SUCCESS_HEAD_+0",
					"@L_GENERAL_MEASURES_143_ORDERASHADOWING_MSG_SUCCESS_BODY_+0",GetID(""),GetID("Destination"))	
			end
		end
		
		--what the spy should do
		WhatToDo = Rand(4)
		
		--simply move to the last known position of the victim
		if (WhatToDo == 0) then
			if GetInsideBuilding("Destination","Building") then
				GetOutdoorMovePosition("","Building","OutdoorMovePos")
				f_MoveTo("","OutdoorMovePos",GL_MOVESPEED_RUN,"Victim",500)
			else
				f_MoveTo("","Destination",GL_MOVESPEED_RUN,"Victim",1000)
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
				f_MoveTo("","OutdoorMovePos",GL_MOVESPEED_RUN,200)
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
				f_MoveTo("","OutdoorMovePos",GL_MOVESPEED_RUN ,"Victim",500)
			
				--start observation
				while (SpyTheHouse == 1) do
					WhatToDo = Rand(4)
					--Go around the house
					if (WhatToDo == 0) then
						for i=1, 4 do
							if GetLocatorByName("VictimsHome", "Walledge"..i, "VictimsCorner"..i) then
								f_MoveTo("", "VictimsCorner"..i, GL_MOVESPEED_SNEAK, 50)
							end
							Sleep(1)
							k = Rand(2)
							if (k == 0) then
								PlayAnimation("","watch_for_guard")
							end
						end
					elseif (WhatToDo == 1) then
						if GetLocatorByName("VictimsHome", "Entry1", "VictimsEntry") then
							f_MoveTo("", "VictimsEntry", GL_MOVESPEED_SNEAK, 50)
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

function Progress()
	local MaxProgress = 2 * 10
	SetProcessMaxProgress("",MaxProgress)
	local ProgressStartTime = GetGametime()
	local ProgressEndTime = GetGametime() + 2
	while (GetGametime() < ProgressEndTime) do
		SetProcessProgress("",(GetGametime()-ProgressStartTime)*10)
		Sleep(1)
	end
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAnimation("")
	AddImpact("","spying",-1,-1)
	ResetProcessProgress("")
	if AliasExists("Destination") then
		local DestDyn = GetDynasty("Destination","DestDynasty")
		local OwnerDyn = GetDynastyID("","OwnerDynasty")
		if HasProperty("DestDynasty","BeeingShadowedBy"..OwnerDyn) then
			RemoveProperty("DestDynasty","BeeingShadowedBy"..OwnerDyn)
		end
	end

	MsgMeasure("","")
	if SimGetWorkingPlace("","SpyWorkBuilding") then
		f_MoveToNoWait("","SpyWorkBuilding")
	end
end

