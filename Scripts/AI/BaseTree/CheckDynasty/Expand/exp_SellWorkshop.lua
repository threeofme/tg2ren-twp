function Weight()
	
	if GetRound() < 2 then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_SellShop") then
		return 0
	end

	if not DynastyIsShadow("SIM") then
		return 0
	end
	
	if SimGetOfficeID("SIM")>= 0 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("SIM", GL_BUILDING_CLASS_WORKSHOP, -1, "sd_Workshop") then
		return 0
	end
	
	if BuildingGetForSale("sd_Workshop") then -- remove for sale after 12 hours
		return 100
	end
	
	if BuildingGetOwner("sd_Workshop", "MyOwner") then
		if SimGetOfficeID("MyOwner") >= 0 then
			return 0
		end
	end
	
	if GetMoney("dynasty") >= 25000 then
		return 0
	end
		
	return 100
end

function Execute()

	SetRepeatTimer("dynasty", "AI_SellShop", 12)

	if BuildingGetForSale("sd_Workshop") then
		BuildingSetForSale("sd_Workshop", false)
		SetState("sd_Workshop", STATE_SELLFLAG, false)
	else
		BuildingSetForSale("sd_Workshop", true)
		SetState("sd_Workshop", STATE_SELLFLAG, true)
	end
end

