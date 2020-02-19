function Run()
end

function OnLevelUp()
end


function Setup()
	worldambient_CreateAnimal("Wolf", "" , 2)
	
	if BuildingGetCartCount("") < 1 then
		GetOutdoorMovePosition(nil, "", "Pos")
		ScenarioCreateCart(EN_CT_MIDDLE, "", "Pos", "NewCart")
	end
end

function PingHour()
	-- Check every worker (only once) for illness and equipment 
	if not HasProperty("", "CheckDefaultWorkers") then
		bld_ResetWorkers("")
		SetProperty("", "CheckDefaultWorkers", 1)
	end
	
	-- Only for AI
	if BuildingGetOwner("", "MyBoss") then
		if GetHomeBuilding("MyBoss", "MyHome") then
			if DynastyIsShadow("MyHome") then -- shadows shall only have 1 cart
				bld_RemoveCart("")
			end
			
			if DynastyIsAI("MyHome") then
				bld_CheckRivals("")
				bld_ForceLevelUp("")
			end
		end
	end
end
