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
	bld_ResetWorkers("")
end

function PingHour()
	bld_HandlePingHour("")
	if BuildingGetAISetting("", "Enable") > 0 then
		-- TODO Manage workers on AI setting
		--CreateScriptcall("Robber-ManageWorkers", 0.3, "Buildings/Robber.lua", "ManageWorkers", "")
	end
end

function ManageWorkers(BldAlias)
	-- 1. Decide, which special measure to start today (plunder, protection, kidnapping)
	
	-- 2. Start measure some time today, use all robbers
	-- plunder: different targets
	-- protection: different targets
	-- kidnapping: one target
	
end
