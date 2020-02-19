function Run()

	if not SquadGet("", "Squad") then
		return
	end
	
	local	VictimID = GetProperty("Squad", "VictimID")
	if not VictimID then
		return
	end
	
	if not GetAliasByID(VictimID, "Victim") then
		return
	end
	
	local IsLeader
	local	LeaderID
	
	while true do
	
		IsLeader = false
		LeaderID = GetProperty("Squad", "LeaderID")
		if not LeaderID or LeaderID=="" then
			SetProperty("Squad", "LeaderID", GetID(""))
			IsLeader = true
		else
			IsLeader = (LeaderID==GetID(""))
		end
	
		local 	Phase = GetProperty("Squad", "Phase")
	
		if not IsLeader then
		
			-- Member stuff
			
			if GetAliasByID(LeaderID, "Leader") then
		
				f_FollowNoWait("", "Leader", GL_MOVESPEED_RUN)
			
				while HasProperty("Squad", "LeaderID") do
					Phase = GetProperty("Squad", "Phase")
					if Phase==2 then
						local TargetID = GetProperty("Squad", "TargetID")
						if TargetID and GetAliasByID(TargetID, "Target") then
							if not GetState("Target", STATE_UNCONSCIOUS) then
								if not GetState("Victim",STATE_CUTSCENE) then
									BattleJoin("", "Target", false, true)
								end
							end
--						SetData("DontLeave", 1)
						end
					end
					Sleep(2)
				end
			end
			
		else
			-- Leader stuff
			
			if Phase==0 then
				ms_squadwarmember_Phase0()
			elseif Phase==1 then
				ms_squadwarmember_Phase1()
			elseif Phase==2 then
				ms_squadwarmember_Phase2()
			end
		end
		Sleep(2 + Rand(20)*0.1)
	end
end

-- Phase0 - Sammeln am eigenen Wohnhaus bis genug Leute da sind
function Phase0()

	if SimGetWorkingPlace("", "Place") then
		if GetOutdoorMovePosition("", "Place", "MoveToPos") then
			f_MoveTo("", "MoveToPos", GL_MOVESPEED_RUN, 500)
		end
	end
	
	while true do
		local Check = ai_CheckForces("", "Victim", 2000)
		if Check == false then
			SetProperty("Squad", "Phase", 1)
			return
		end
		Sleep(2)
	end
end

-- Phase1 - Marschbefehl und warten bis genug da sind - eventl. draussen vor dem Haus aufstellen
function Phase1()
	local	WaitTime = GetData("WaitTime")
	
	if GetInsideBuilding("Victim", "Build") then
	
		if not GetOutdoorMovePosition("", "Build", "MovePos") then
			return
		end
		
		if not f_MoveTo("", "MovePos", GL_MOVESPEED_RUN, 200) then
			return
		end
		
		if WaitTime then
		
			if WaitTime < GetGametime() then
				-- attack building
				
				if GetInsideBuildingID("Victim")==GetID("Build") and GetDynastyID("Build")==GetDynastyID("Victim") then
					local Check = ai_CheckForces("", "Victim", 2000)
					if Check == true then
						SetProperty("Squad", "Phase", 2)
						SetProperty("Squad", "TargetID", GetID("Build"))
						SetData("DontLeave", 1)
						
						if not MeasureRun("","Build","AttackEnemy",true) then
							return false
						end
						
						return
					end
				end
			end
			
			return
		end
		
		WaitTime = GetGametime()+0.5+Rand(20)*0.1
		SetData("WaitTime", WaitTime)
		return
	end
	
	if f_Follow("", "Victim", GL_MOVESPEED_RUN, 1000, true) then
		local	Distance = CalcDistance("", "Victim")
		if Distance<0 or Distance>400 then
			return
		end
		
		local Check = ai_CheckForces("", "Victim", 2000)
		if Check == true then
		
			SetProperty("Squad", "Phase", 2)
			SetProperty("Squad", "TargetID", GetID("Victim"))

			SetData("DontLeave", 1)
			if not GetState("Victim",STATE_CUTSCENE) then
				if not MeasureRun("","Victim","AttackEnemy",true) then
					return false
				end
			end
			return
		end
	end
end

function Phase2()
	if GetState("Victim", STATE_UNCONSCIOUS) then
		-- kill char
		SetProperty("Squad", "Phase", 100)

		SetData("DontLeave", 1)
		if not GetState("Victim",STATE_CUTSCENE) then
			if not MeasureRun("","Victim","Kill",true) then
				return false
			end
		end
	end
end

function CleanUp()
	if HasData("DontLeave") then
		RemoveData("DontLeave")
	else
	
		if AliasExists("Squad") then
	
			local LeaderID = GetProperty("Squad", "LeaderID")
			if LeaderID==GetID("") then
				RemoveProperty("Squad", "LeaderID")
			end
			SquadRemoveMember("", true)
			if SquadGetMemberCount("Squad", true)<1 then
				SquadDestroy("Squad")
				return
			end
		end
	end
end

