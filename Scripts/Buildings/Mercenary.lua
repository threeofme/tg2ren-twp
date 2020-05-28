function Run()
end

function OnLevelUp()
end

function Setup()
	-- create ambient animals
	if Rand(2)==0 then
		worldambient_CreateAnimal("Cat", "" ,1)
	else
		worldambient_CreateAnimal("Dog", "" ,1)
	end
end

function PingHour()
	
	if not GetState("", STATE_MOVING_BUILDING) and not GetState("", STATE_BUILDING) and not GetState("", STATE_LEVELINGUP) then
		SetState("", STATE_MOVING_BUILDING, true)
	end
	
	-- Check every worker (only once) for illness and equipment 
	if not HasProperty("", "CheckDefaultWorkers") then
		bld_ResetWorkers("")
		SetProperty("", "CheckDefaultWorkers", 1)
	end
	
	-- Only for AI
	
	if BuildingGetOwner("", "MyBoss") then
		if GetHomeBuilding("MyBoss", "MyHome") then
			if DynastyIsShadow("MyHome") then -- shadows shall only have 1 cart
				bld_CheckCarts("")
			end
			
			if DynastyIsAI("MyHome") then
				bld_CheckRivals("")
				bld_ForceLevelUp("")
			end
		end
	end
end