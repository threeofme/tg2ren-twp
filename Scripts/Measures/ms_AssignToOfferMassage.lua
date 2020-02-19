function Run()

	local	TimeOut
	
	if not HasProperty("", "ATOM_TimeOut") then
		TimeOut = GetData("TimeOut")
		if TimeOut then
			TimeOut = TimeOut + GetGametime()
			SetProperty("", "ATOM_TimeOut", TimeOut)
		end
	else
		TimeOut = GetProperty("", "ATOM_TimeOut")
	end
	
	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_PIRATESNEST, "WorkBuilding") then
		StopMeasure() 
		return
	end 

	if GetInsideBuildingID("") ~= GetID("WorkBuilding") then
		if not f_MoveTo("", "WorkBuilding", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	end

	SetProperty("","CocotteHasClient",0)
	SetProperty("","CocotteProvidesLove",1)
	
	-- start the labor
	while 1 do
	
		if BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 then
			if TimeOut then
				if TimeOut < GetGametime() then
					RemoveProperty("", "ATOM_TimeOut")
					break
				end
			end
		end
		
		-- some animation stuff
		-- random speech
		local SimFilter = "__F( (Object.GetObjectsByRadius(Sim)==500)AND(Object.HasDifferentSex())AND(Object.GetState(idle))AND NOT(Object.GetState(townnpc))AND NOT(Object.HasImpact(FullOfLove)))"
		local NumSims = Find("",SimFilter,"Sims",-1)
		if NumSims > 0 then
			local DestAlias = "Sims"..Rand(NumSims-1)
			AlignTo("",DestAlias)
			Sleep(1)
			local AnimTime = PlayAnimationNoWait("","point_at")
			MsgSayNoWait("","@L_PIRATE_LABOROFLOVE_PROPOSE")
			Sleep(AnimTime)
			if GetDynastyID(DestAlias)<1 then
				if Rand(100)>50 then
					MeasureRun(DestAlias,"","UseLaborOfLove")
				else
					AddImpact(DestAlias,"FullOfLove",1,4)
				end
			else
					AddImpact(DestAlias,"FullOfLove",1,4)
			end
		end
		-- random sleeptime
		Sleep(5)
	end
	
end

function CleanUp()
  RemoveProperty("","CocotteProvidesLove")
end

function GetOSHData(MeasureID)
end


