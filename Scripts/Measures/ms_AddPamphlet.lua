function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	-- get the blackboard
	local Radius = 410
	
	if DynastyIsAI("") then
		GetSettlement("","BlackBoardCity")
		CityGetRandomBuilding("BlackBoardCity",-1,41,-1,-1,FILTER_IGNORE,"BlackBoard")
	elseif not AliasExists("BlackBoard") then
		local Filter = "__F((Object.GetObjectsByRadius(Building) == 410) AND (Object.IsType(41)))"
		local result = Find("", Filter,"BlackBoard", -1)
		if result <= 0 then
			StopMeasure() 
		end
	end
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	SetMeasureRepeat(TimeOut)
	local PamphletLabel
	
	if GetProperty("BlackBoard","PamphletCnt")>=4 then
		StopMeasure()
	end
	
	--combine pamphlet text
	if DynastyGetRandomBuilding("Destination",2,-1,"DestBuilding") then
		local BuildingType = BuildingGetType("DestBuilding")
		local Rest = 0
		local Idx = Rand(10)
		if BuildingType == GL_BUILDING_TYPE_FARM then
			if Idx < 5 then
				Rest = "_BERUF_FARMER_1"
			else
				Rest = "_BERUF_FARMER_2"
			end
		elseif BuildingType == GL_BUILDING_TYPE_BAKERY then
			if Idx < 3 then
				Rest = "_BERUF_BAECKER_1"
			elseif Idx < 6 then
				Rest = "_BERUF_BAECKER_2"
			else
				Rest = "_BERUF_BAECKER_3"
			end
		elseif BuildingType == GL_BUILDING_TYPE_TAVERN then
			if Idx < 5 then
				Rest = "_BERUF_WIRT_1"
			else
				Rest = "_BERUF_WIRT_2"
			end
		elseif BuildingType == GL_BUILDING_TYPE_SMITHY then
			if Idx < 3 then
				Rest = "_BERUF_SCHMIED_1"
			elseif Idx < 6 then
				Rest = "_BERUF_SCHMIED_2"
			else
				Rest = "_BERUF_SCHMIED_3"
			end
		elseif BuildingType == GL_BUILDING_TYPE_JOINERY then
			if Idx < 2 then
				Rest = "_BERUF_TISCHLER_1"
			elseif Idx < 4 then
				Rest = "_BERUF_TISCHLER_2"
			elseif Idx < 7 then
				Rest = "_BERUF_TISCHLER_3"
			else
				Rest = "_BERUF_TISCHLER_4"
			end
		elseif BuildingType == GL_BUILDING_TYPE_TAILORING then
			if Idx < 5 then
				Rest = "_BERUF_SCHNEIDER_1"
			else
				Rest = "_BERUF_SCHNEIDER_2"
			end
		elseif BuildingType == GL_BUILDING_TYPE_ALCHEMIST then
			if Idx < 2 then
				Rest = "_BERUF_ALCHIMIST_1"
			elseif Idx < 4 then
				Rest = "_BERUF_ALCHIMIST_2"
			elseif Idx < 7 then
				Rest = "_BERUF_ALCHIMIST_3"
			else
				Rest = "_BERUF_ALCHIMIST_4"
			end
		elseif BuildingType == GL_BUILDING_TYPE_CHURCH_CATH or BuildingType == GL_BUILDING_TYPE_CHURCH_EV then
			if Idx < 2 then
				Rest = "_BERUF_PRIESTER_1"
			elseif Idx < 4 then
				Rest = "_BERUF_PRIESTER_2"
			elseif Idx < 6 then
				Rest = "_BERUF_PRIESTER_3"
			elseif Idx < 8 then
				Rest = "_BERUF_PRIESTER_4"
			else
				Rest = "_BERUF_PRIESTER_5"
			end
		elseif BuildingType == GL_BUILDING_TYPE_THIEF then
			if Idx < 3 then
				Rest = "_BERUF_DIEB_1"
			elseif Idx < 6 then
				Rest = "_BERUF_DIEB_2"
			else
				Rest = "_BERUF_DIEB_3"
			end
		elseif BuildingType == GL_BUILDING_TYPE_ROBBER then
			if Idx < 3 then
				Rest = "_BERUF_RAEUBER_1"
			elseif Idx < 6 then
				Rest = "_BERUF_RAEUBER_2"
			else
				Rest = "_BERUF_RAEUBER_3"
			end
		else
			local NumPamphlet = Rand(26)+1
			PamphletLabel = "@L_LAMPOONS_A"..NumPamphlet
		end	
		if Rest ~= 0 then
			PamphletLabel = "@L_LAMPOONS"..Rest
		end
	else
		local NumPamphlet = Rand(26)+1
		PamphletLabel = "@L_LAMPOONS_A"..NumPamphlet.."_+0"
	end
	
	GetLocatorByName("BlackBoard","entry1","MovePos")
	f_MoveTo("","MovePos",GL_MOVESPEED_WALK)
	AlignTo("","BlackBoard")
	Sleep(1)
	PlayAnimation("","manipulate_middle_up_r")
	local PIdx = BlackBoardAddPamphlet("BlackBoard","Destination",PamphletLabel)
	if  PIdx > -1 then
		SetProperty("BlackBoard","Pamphlet_"..PIdx,GetID("Destination"))		
		StopAction("blackboard","BlackBoard")
		Sleep(0.1)
		CommitAction("blackboard","BlackBoard","BlackBoard")
	end
end

function CleanUp()
	
end


function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

