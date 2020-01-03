function Weight()
	
	if ScenarioGetTimePlayed() < 4 then
		return 0
	end
	
	if IsDynastySim("SIM") then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "ai_CheckRivals") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM", "MyWork") then
		return 0
	end

	if not BuildingGetOwner("MyWork", "MyBoss") then
		return 0
	end
	
	if DynastyIsPlayer("MyBoss") then
		return 0
	end
	
	if not GetSettlement("MyWork", "MyTown") then 
		return 0
	end
	
	-- Only 1 rival a time
	if HasProperty("dynasty", "RivalID") then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("dynasty", "ai_CheckRivals", 4)
	
	local BuildType = BuildingGetType("MyWork")
	local BuildLevel = BuildingGetLevel("MyWork")
	local BuildID = GetID("MyWork")
	
	-- check for same buisness nearby
	
	local RivalFilter = "__F((Object.GetObjectsByRadius(Building) == 12000) AND (Object.IsType("..BuildType..")) AND (Object.GetLevel()<="..BuildLevel..")AND(Object.HasDynasty()) AND NOT(Object.BelongsToMe()))"
	local NumRivals = Find("MyWork", RivalFilter, "RivalBuilding", -1)
	local Found = false
	
	if NumRivals > 0 then
		for i=0, NumRivals-1 do
			if GetDynastyID("RivalBuilding"..i) ~= GetDynastyID("SIM") then
				if GetSettlementID("RivalBuilding"..i) == GetSettlementID("MyWork") then
					if not GetState("RivalBuilding"..i, STATE_BUILDING) then
						if BuildingGetOwner("RivalBuilding"..i, "RivalBoss") then
							-- rival needs to be a player
							if DynastyIsPlayer("RivalBoss") then
								-- check for diplomacy
								if DynastyGetDiplomacyState("MyBoss", "RivalBoss")~=DIP_ALLIANCE then
									SetProperty("dynasty", "RivalID", GetDynastyID("RivalBuilding")) -- save the enemy dynasty for AI Scripts
									SetProperty("dynasty", "RivalBuilding", GetID("RivalBuilding")) -- save the rival building for AI Scripts
									Found = true
									break
								end
							end
						end
					end
				end
			end
		end
	end
	
	if Found then
		MsgNewsNoWait("RivalBoss", "MyBoss", "", "intrigue", -1,
					"@L_AI_NEWRIVALINTOWN_HEAD", "@L_AI_NEWRIVALINTOWN_BODY",GetID("MyBoss"),GetID("MyWork"),GetID("RivalBuilding"))
		ModifyFavorToDynasty("dynasty", "RivalBoss", -10)
	end
end