-- Motivation: I'm broke, gotta sell
function Weight()
	aitwp_Log("Weight::SellWorkshop", "dynasty")
	-- colored dynasties will not sell
	if not DynastyIsShadow("dynasty") then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_SellShop") then
		return 0
	end

	if GetMoney("dynasty") >= 0 then
		return 0
	end

	if not DynastyGetRandomBuilding("dynasty", GL_BUILDING_CLASS_WORKSHOP, -1, "sd_Workshop") then
		return 0
	end
	
--	if BuildingGetOwner("sd_Workshop", "MyOwner") then
--		if SimGetOfficeID("MyOwner") >= 0 then
--			return 0
--		end
--	end
	
	aitwp_Log("Weight::SellWorkshop returns 2", "dynasty")
	return 2
end

function Execute()
	aitwp_Log("Execute::SellWorkshop", "dynasty")
	aitwp_Log("Execute::SellWorkshop for SIM", "SIM")
	SetRepeatTimer("dynasty", "AI_SellShop", 12)
	BuildingSetForSale("sd_Workshop", true)
	SetState("sd_Workshop", STATE_SELLFLAG, true)
end

