---
-- This action seems somewhat useless... at best unmotivated

function Weight()
	if not dyn_GetIdleMember("dynasty", "SIM") then
		return 0
	end 
	
	if GetSettlement("SIM", "City") then
		if (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]>0) then
			if not CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "Guildhouse") then
				return 0
			end
		else
			return 0
		end
	else
		return 0
	end

	if chr_GetAlderman()==GetID("SIM") then
		return 60
	elseif chr_CheckGuildMaster("SIM","Guildhouse") then
		return 40
	end

	return 0
end

function Execute()
	SetRepeatTimer("dynasty", "IABuyRawMaterial", 4)
	MeasureCreate("Measure")

	local measurelabel
	if SimGetClass("SIM")==1 then
		measurelabel = "BuyRawMaterialPatron"
	elseif SimGetClass("SIM")==2 then
		measurelabel = "BuyRawMaterialArtisan"
	elseif SimGetClass("SIM")==3 then
		measurelabel = "BuyRawMaterialScholar"
	else
		measurelabel = "BuyRawMaterialChiseler"
	end
	
	MeasureRun("SIM", "Guildhouse", measurelabel)
end
