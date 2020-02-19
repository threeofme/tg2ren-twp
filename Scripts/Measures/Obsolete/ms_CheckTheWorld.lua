function Run()

	local	Total = 0
	local	Count

	Count = ScenarioGetObjects("cl_Building", 999, "Obj")
	for l=0,Count-1 do
		CopyAlias("Obj"..l, "Check"..Total)
		Total = Total + 1
	end
	
	Count = ScenarioGetObjects("cl_GuildResource", 999, "Obj")
	for l=0,Count-1 do
		CopyAlias("Obj"..l, "Check"..Total)
		Total = Total + 1
	end
	
	-- *********************************
	--
	-- check for needed outdoor locators
	--
	-- *********************************
	
	local	Arr = { 
	"Ambush", 3, 
	"lingerplace", 3, 
	"well", 3, 
	"farm", 3, 
	"robber", 1, 
	"resource", 12,
	"mine", 1, 
	"rangerhut", 1,
	"church_ev", 1,
	"church_cath", 1, 
	"MapExit1", 1
	}
	
	local Pos = 1
	while Arr[Pos] do
		Count = GetOutdoorLocator(Arr[Pos], -1, "Obj")
		if Count < Arr[Pos+1] then
			LogMessage("@CheckWorld_Failed Locator "..Arr[Pos].."   expected "..Arr[Pos+1].." found "..Count)
		else
			LogMessage("@CheckWorld_Success Locator "..Arr[Pos].."   expected "..Arr[Pos+1].." found "..Count)
		end
		
		for l=0,Count-1 do
			CopyAlias("Obj"..l, "Check"..Total)
			Total = Total + 1
		end
		Pos = Pos + 2
	end

	SetData("Check_Count", Total)
	
	
	
	
	-- *******************************************************************************
	--
	-- Create sim for checking the postions of all of the buildings/locators/... above
	--
	-- *******************************************************************************
	
	local	Create = 42
	SetData("Total", 0)
	
	if not GetOutdoorMovePosition(nil, "", "SpawnPoint") then
		return
	end
		
	for c=0,Create-1 do
		if SimCreate(-1, "", "SpawnPoint", "SIM"..c) then
			SetState("SIM"..c, STATE_LOCKED, true)
			SimSetHireable("SIM"..c, false)
			SetData("SimNumber", c)
			SendCommandNoWait("", "CheckMe")
		end
		Sleep(0.1)
	end
	
	local	TimeCheck
	local x
	local	y
	local z
	local	OldX
	local OldZ
	local	Alias
	
	while (GetData("Total")>0) do
		if not TimeCheck then
			TimeCheck = Gametime2Realtime(1)
		end
		Sleep(2)
		TimeCheck = TimeCheck - 2
		
		if TimeCheck<1 then
			TimeCheck = nil
			
			for c=0,Create-1 do
				Alias = "SIM"..c
				if AliasExists(Alias) then
					GetPosition(Alias, "Pos")
					x,y,z = PositionGetVector("Pos")
					
					OldX = GetData("PosX"..GetID(Alias))
					OldZ = GetData("PosZ"..GetID(Alias))
					
					if OldX==x and OldZ==z then
						LogMessage("@CheckWorld_Failed Possible MoveError of "..GetID(Alias).." - static position")
						local StartAlias 	= "Start"..GetID(Alias)
						local	DestAlias 	= "Dest"..GetID(Alias)
						LogMessage("@CheckWorld_Failed The sim was moving from "..GetName(StartAlias).."("..GetID(StartAlias)..") to "..GetName(DestAlias).."("..GetID(DestAlias)..")")
					end
					SetData("PosX"..GetID(Alias), x)
					SetData("PosZ"..GetID(Alias), z)
				end
			end
		end
	end
	StopMeasure()
end

function CleanUp()
	local c=0
	while AliasExists("SIM"..c) do
		Kill("SIM"..c, -999)
		c = c + 1
	end
end

function CheckMe()

	SetData("Total", GetData("Total") + 1)
	
	local	SimAlias = "SIM"..GetData("SimNumber")

	local Count = GetData("Check_Count")
	local	Shortest
	local	NewAlias
	local	Dist
	local	ToDo
	local	Success
	local	Firsttime = true
	local	Notify
	
	local StartAlias 	= "Start"..GetID(SimAlias)
	local	DestAlias 	= "Dest"..GetID(SimAlias)
	
	CopyAlias("", DestAlias)
		
	while true do

		NewAlias = nil
		Shortest = -1

		f_ExitCurrentBuilding(SimAlias)
		
		ToDo = 0
		
		if Firsttime then
			for l=0,Count-1 do
				if AliasExists("Check"..l) then
					NewAlias = "Check"..l
					ToDo = Count
					break
				end
			end
			Firsttime = false
		end
		
		if not NewAlias then
			for l=0,Count-1 do
				if AliasExists("Check"..l) then
					ToDo = ToDo + 1
					Dist = GetDistance(SimAlias, "Check"..l)
					if Dist>0 and (not NewAlias  or Dist < Shortest) then
						Shortest 		= Dist
						NewAlias = "Check"..l
					end
				end
			end
		end
		
		if not NewAlias then
			SetData("Total", GetData("Total") - 1)
			RemoveAlias(StartAlias)
			RemoveAlias(DestAlias)
			Kill(SimAlias)
			RemoveAlias(SimAlias)
			return
		end

		CopyAlias(DestAlias, StartAlias)
		CopyAlias(NewAlias, DestAlias)
		RemoveAlias(NewAlias)
		
		local	MoveToPos
		
		if IsType(DestAlias, "cl_Building") then
			MoveToPos = "MovePos"..GetID(SimAlias)
			GetOutdoorMovePosition(SimAlias, DestAlias, MoveToPos)
		else
			MoveToPos = DestAlias
		end

		Success = f_MoveTo(SimAlias, MoveToPos, GL_MOVESPEED_RUN)
		
		local x
		local	y
		local z
		GetPosition(DestAlias, "Pos")
		x,y,z = PositionGetVector("Pos")
		
		local	CountOut = "("..ToDo.."/"..Count..")"
		local	Position = "("..x.."/"..z..")"

		if Success then		
			LogMessage("@CheckWorld_Success Reached "..CountOut.." "..GetName(DestAlias).."("..GetID(DestAlias)..")")
		else
			local	CityName = "???"
			if GetSettlement(DestAlias, "City") then
				CityName = GetName("City")
			end
			LogMessage("@CheckWorld_Failed "..CountOut.." "..GetName(DestAlias).."("..GetID(DestAlias)..") of city "..CityName.." at "..Position)
		end
		
	end
end

