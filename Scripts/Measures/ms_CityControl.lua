function Run()
----------------------------------------------------------------------------------------------------
----	Set GodModule 'true' for city events and desasters					----
----												----
	local GodModule = true									----
----												----
----												----
----------------------------------------------------------------------------------------------------
	if GodModule == false then
		StopMeasure()
	end
	
	GetScenario("World")
	if HasProperty("World", "static") then
		StopMeasure()
	end
	
	local CityID = GetProperty("","CityID")
	if not GetAliasByID(CityID,"MyCity") then
		StopMeasure()
	end

	if CityIsKontor("MyCity") then
		StopMeasure()
	end
	
	local Difficulty = ScenarioGetDifficulty()

	while true do
		Sleep(Rand(60)+300)

		local Season = Weather_GetSeason()
		-- spring and fall
		-- infection, Heuschrecken, inferno, black death, ratboy
		local probs = {8, 1, 2, 1, 1}
			
		if Season == 1 then
			-- summer
			probs = {3, 2, 3, 2, 0}
		elseif Season == 3 then
			-- winter
			probs = {15, 0, 0, 2, 0}
		end
	
		local Choice = Rand(100)+1
		if Choice < Difficulty * probs[1] then
			ms_citycontrol_InfectPartyMember()
		elseif Choice < Difficulty * (probs[1] + probs[2]) then
			ms_citycontrol_Heuschrecken()
		elseif Choice < Difficulty * (probs[1] + probs[2] + probs[3]) then
			ms_citycontrol_Inferno()
		elseif Choice < Difficulty * (probs[1] + probs[2] + probs[3] + probs[4])  and GetRound() > (10 - Difficulty) then
			ms_citycontrol_TheBlackDeath()
--		elseif Choice < Difficulty * probs[5] then
--			ms_citycontrol_RatBoy()
		else 
			-- DEBUG
			--MsgNewsNoWait("All","","","intrigue",-1,"Glück gehabt!", "Es ist nichts passiert, Wahl: "..Choice)
		end

	end
end

function InfectPartyMember()
	
	ScenarioGetRandomObject("cl_Dynasty","CurrentDyn")
	if not AliasExists("CurrentDyn") then
		return
	end
	
	local MemberCount = DynastyGetMemberCount("CurrentDyn")
	if MemberCount > 0 then
		 for i=0,MemberCount-1 do
		 	 if DynastyGetMember("CurrentDyn",i,"CurrentMember") then
		 	 	if IsPartyMember("CurrentMember") then 
		 	 		if GetID("CurrentMember") then
		 	 			if GetState("CurrentMember",STATE_SICK) then 
		 	 				return
		 	 			end
		 	 		end
		 	 	end
		 	 end
		 end
	end
	
	if AliasExists("CurrentMember") then
		if GetImpactValue("CurrentMember","Resist")>0 then --check if you were ill or used soap or staff of aesculap
			return 
		end
		if GetImpactValue("CurrentMember","Sickness")>0 then -- check if you are already ill
			return 
		end
	
		local SickChoice = 1+Rand(10)
		local krankH
		-- check the scenario difficulty
		if ScenarioGetDifficulty()>2 then -- hard settings?
		
			if SickChoice<4 then -- 30%
				diseases_Cold("CurrentMember",true, true) -- you got lucky
				krankH = 2
			elseif SickChoice<6 then --20%
				diseases_Sprain("CurrentMember",true,true) -- still lucky
				krankH = 1
			elseif SickChoice <8 then --20%
				diseases_Influenza("CurrentMember",true,true) -- influenza? not nice
				krankH = 3
			elseif SickChoice <9 then --10%
				diseases_Pox("CurrentMember",true,true) -- damn!
				SetState("CurrentMember",STATE_CONTAMINATED,true)
				krankH = 4
			elseif SickChoice <10 then --10%	
				diseases_Fracture("CurrentMember",true,true) -- that hurts
				krankH = 5
			else -- 10%
				diseases_Caries("CurrentMember",true,true) -- c'mon!
				krankH = 6
			end
		else -- low settings
			if SickChoice<6 then -- 50%
				diseases_Cold("CurrentMember",true, true) -- you got lucky
				krankH = 2
			elseif SickChoice <9 then --40%
				diseases_Sprain("CurrentMember",true,true) -- still lucky
				krankH = 1
			else -- 10%
				diseases_Influenza("CurrentMember",true,true) -- influenza? not nice
				krankH = 3
			end
		end
	ms_citycontrol_Warnung(1,"CurrentMember",krankH) -- send a message to the poor guy
	end
	
	RemoveAlias("CurrentMember")	-- cleanup
end

function RatBoy()
	if not CityGetRandomBuilding("MyCity",3,23,-1,-1,FILTER_IGNORE,"RatBoyHomeBuilding") then
		return
	end
	GetPosition("RatBoyHomeBuilding","RatBoySpawnPos")
	if not SimCreate(904,"RatBoyHomeBuilding","RatBoySpawnPos","RatBoy") then
		return
	end
	SimSetBehavior("RatBoy","RatBoy")
	ms_citycontrol_Warnung(2,"RatBoy")
end

function Inferno()
	-- residences
	local NumBuildings = CityGetBuildingCount("MyCity",1,-1,-1,-1,FILTER_IGNORE)
	CityGetBuildings("MyCity",1,-1,-1,-1,FILTER_IGNORE,"Building")
	local Severity = Rand(70)
	for i=0,NumBuildings-1 do
		if GetImpactValue("Building"..i, 7) * 100 < Severity then
			SetState("Building"..i,STATE_BURNING,true)
			Sleep(3)
		end
	end
	-- workshops
	local NumBuildings = CityGetBuildingCount("MyCity",2,-1,-1,-1,FILTER_IGNORE)
	CityGetBuildings("MyCity",2,-1,-1,-1,FILTER_IGNORE,"Building")
	for i=0,NumBuildings-1 do
		if GetImpactValue("Building"..i, 7) * 100 < Severity then
			SetState("Building"..i,STATE_BURNING,true)
			Sleep(3)
		end
	end
	ms_citycontrol_Warnung(3,"MyCity")
end

function Heuschrecken()
	if not CityGetRandomBuilding("MyCity",6,33,0,-1,FILTER_IGNORE,"Feld") then
	    return
	end
  if not HasProperty("Feld","Heuschrecken") then
	    SetProperty("Feld","Heuschrecken",1)
	else
	    return
	end
	MeasureRun("Feld","","HeuPlage",true)
	ms_citycontrol_Warnung(4,"MyCity")
end

function TheBlackDeath()
	if not ReadyToRepeat("MyCity", "Pest") then
		return
	end
  local opfer = Rand(2)+1
	if CityGetRandomBuilding("MyCity",opfer,-1,-1,-1,FILTER_HAS_DYNASTY,"Ausbruch") then
		if BuildingGetSim("Ausbruch",1,"ErstOpfer") then
			diseases_Blackdeath("ErstOpfer",true,true)
			SetRepeatTimer("MyCity", "Pest", 192)
		end
	end
	
end

function Warnung(danger,opfer,zusatz)

  local krankNam = { "@L_HPFZ_KATASTR_KRANK_NAM_+0", "@L_HPFZ_KATASTR_KRANK_NAM_+1", "@L_HPFZ_KATASTR_KRANK_NAM_+2", "@L_HPFZ_KATASTR_KRANK_NAM_+3", "@L_HPFZ_KATASTR_KRANK_NAM_+4", "@L_HPFZ_KATASTR_KRANK_NAM_+5" }
  if danger == 1 then
	    MsgNewsNoWait(opfer,opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_KRANK_KOPF",
	                    "@L_HPFZ_KATASTR_KRANK_RUMPF_+0"..krankNam[zusatz].."@L_HPFZ_KATASTR_KRANK_RUMPF_+1",GetID(opfer),krankNam[zusatz])
	elseif danger == 2 then
	    MsgNewsNoWait("All",opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_RATTE_KOPF",
	                    "@L_HPFZ_KATASTR_RATTE_RUMPF")
	elseif danger == 3 then
	    MsgNewsNoWait("All",opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_FEUER_KOPF",
	                    "@L_HPFZ_KATASTR_FEUER_RUMPF",GetID(opfer))
	elseif danger == 4 then
	    MsgNewsNoWait("All",opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_GRILLEN_KOPF",
	                    "@L_HPFZ_KATASTR_GRILLEN_RUMPF",GetID(opfer))
	end

end

function CleanUp()
	if HasProperty("","CityID") then
		RemoveProperty("","CityID")
	end
end
