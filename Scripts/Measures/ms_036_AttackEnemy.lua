function Run()

	MeasureSetNotRestartable()
	
	-- ms_092_SingForPeacefulness.lua active
	if (GetImpactValue("", "Peaceful") ~= 0) then
		StopMeasure("") 
		return
	end	
	
	-- sight distance   
	local DistanceToJoinBattle = gameplayformulas_CalcSightRange("Destination")
	
	-- Favor
	if GetDynasty("Destination", "TargetDyn") then
		ModifyFavorToDynasty("", "TargetDyn", -10)
	end
	
	-- i am a building no need to move
	if IsType("", "Building") then
		BattleJoin("","Destination", false)
		Sleep(1)
		return
	end

	--dont follow buildings and force outdoor position
	if IsType("Destination", "Building") then
		if not BuildingGetOwner("Destination", "BOwner") then
			StopMeasure()
		end
			
		if GetState("Destination", STATE_REPAIRING) then 
			SetState("Destination", STATE_REPAIRING, false)
		end
		
		GetFleePosition("","Destination",1000,"AttackPos")
		if not f_MoveTo("","AttackPos",GL_MOVESPEED_RUN) then
			StopMeasure("")
			return
		end
	
		AlignTo("","Destination")
		
	elseif IsType("Destination", "Ship") then
		local radius = 3200
		if not ai_StartInteraction("", "Destination", radius, radius, nil, true) then
			StopMeasure("")
			return
		end
	elseif IsType("Destination", "Cart") then
		local radius = GetRadius("Destination")*2
		if not ai_StartInteraction("", "Destination", radius, radius, nil, true) then
			StopMeasure("")
			return
		end
	else
		if not ai_StartInteraction("", "Destination", DistanceToJoinBattle, DistanceToJoinBattle, nil, true) then
			StopMeasure("")
			return
		end
	end
	
	gameplayformulas_SimAttackWithRangeWeapon("", "Destination")
	local iBattleID = BattleJoin("","Destination", false)
end


