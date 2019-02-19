function Weight()
	
	if Rand(3) == 0 then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_DEFBUILD") then
		return 0
	end
	
	if ScenarioGetDifficulty()<2 then -- no protection on easy settings
		return 0
	end

	if DynastyGetBuildingCount("SIM",-1,-1) < 1 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("SIM", 2, -1, "ProtectMe") then
		return 0
	end
	
	SetRepeatTimer("dynasty", "AI_DEFBUILD", 1)
	
	-- check to repair buildings
	local BuildHP = GetHPRelative("ProtectMe")
	if BuildHP < 1.0 then
		
		if GetState("ProtectMe", STATE_REPAIRING) then
			return 0
		end
		
		if GetState("ProtectMe", STATE_FIGHTING) then
			return 0
		end
		
		if GetState("ProtectMe", STATE_BURNING) then
			return 0
		end
		
		if GetState("ProtectMe", STATE_LEVELINGUP) then
			return 0
		end
		
		if GetState("ProtectMe", STATE_DEAD) then
			return 0
		end
		
		if BuildHP < 0.75 then
			SetData("WhatToDo",3)
			return 100
		elseif BuildHP <0.85 then
			if Rand(3) == 0 then
				SetData("WhatToDo",3)
				return 100
			end
		else
			if Rand(10) == 0 then
				SetData("WhatToDo",3)
				return 100
			end
		end
	end
	
	if GetImpactValue("ProtectMe","buildingburgledtoday")>0 or BuildingGetType("ProtectMe")==18 or
		BuildingGetType("ProtectMe") == 3 or BuildingGetType("ProtectMe")==108 or 
		BuildingGetType("ProtectMe") == 104 or BuildingGetType("ProtectMe")==12 then
		if ImpactGetMaxTimeleft("ProtectMe","buildingburgledtoday") <=4 then
			if GetMeasureRepeat("SIM", "UseBoobyTrap")==0 then
				if GetImpactValue("ProtectMe","BoobyTrap")==0 then
					if GetItemCount("SIM", "BoobyTrap", INVENTORY_STD)>0 then
						SetData("WhatToDo",2)
						return 100
					elseif ai_CanBuyItem("SIM", "BoobyTrap") and GetMoney("SIM")>1000 then
						SetData("WhatToDo",2)
						return 100
					end
				end
			end
		end
	end
	
	if HasProperty("ProtectMe","RobberProtected") then
		local ProtectorID = GetProperty("ProtectMe","RobberProtected")
		GetAliasByID(ProtectorID,"Protector")
		if "Protector" ~= "dynasty" then
			if DynastyGetDiplomacyState("dynasty","Protector")<DIP_NAP then
				if DynastyGetWorkerCount("dynasty", GL_PROFESSION_MYRMIDON) >0 then
					SetData("WhatToDo",1)
					return 100
				end
			end
		end
	end
	
	return 0
end

function Execute()
	SetRepeatTimer("dynasty", "AI_DEFBUILD", 3)
	local WhatToDo = GetData("WhatToDo")
	if WhatToDo == 2 then
		if GetRound()<5 then
			if BuildingGetType("ProtectMe")==12 then
				-- cheat for mines in the first rounds
				AddItems("SIM","BoobyTrap",1,INVENTORY_STD)
			end
		end
		MeasureRun("SIM", "ProtectMe", "UseBoobyTrap")
	elseif WhatToDO == 1 then
		local TotalFound = 0
		local Count = DynastyGetWorkerCount("dynasty", GL_PROFESSION_MYRMIDON)
		for i=0,Count-1 do
			if DynastyGetWorker("dynasty", GL_PROFESSION_MYRMIDON, i, "CHECKME") then
				if GetState("CHECKME", STATE_IDLE) and SimIsWorkingTime("CHECKME") then
					CopyAlias("CHECKME", "MEMBER"..TotalFound )
					TotalFound = TotalFound + 1
				end
			end
		end
		
		if TotalFound <1 then
			return 0
		end
		
		local random = Rand(TotalFound)
		
		if not CopyAlias("MEMBER"..random, "SIM") then
			return 0
		end
		
		MeasureRun("SIM", "ProtectMe", "PatrolTheTown")
		
	else
		MeasureRun("ProtectMe", "ProtectMe", "RenovateBuilding")
	end
		
end