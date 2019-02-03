function Weight()
	aitwp_Log("Weight::Economy", "dynasty")
	if not dyn_GetIdleMember("dynasty", "SIM") or not AliasExists("SIM") then
		return 0
	end
	
	return 25
end

function Execute()
	aitwp_Log("Going into ECONOMY measures", "dynasty")
end

-- production and profitable measures
-- send carts for special goods
-- gamble
-- buy/sell workshops
