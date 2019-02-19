function Weight()
	if not dyn_GetIdleMember("dynasty", "SIM") or not AliasExists("SIM") then
		return 0
	end
	
	return 25
end

function Execute()
end

-- production and profitable measures
-- send carts for special goods
-- gamble
-- buy/sell workshops
