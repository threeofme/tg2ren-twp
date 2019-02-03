function Weight()
	local	Item = "AldermanChain"
	local value = chr_SimGetFameLevel("SIM") * 10
	local Title = GetNobilityTitle("SIM")
	local Price = (Title * Title) * 50

	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM")<1 then
			return 0
		end
	end
	
	if GetSettlement("SIM", "City") then
		if (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]>0) then
			if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "Guildhouse") then
				if chr_CheckGuildMaster("SIM","Guildhouse") then
					Price = (Title * Title) * 30
					if chr_GetAlderman()==GetID("") then
						Price = (Title * Title) * 15
						if GetItemCount("", Item,INVENTORY_STD)>0 then
							return 100
						else
							value = value + 40
						end
					else
						value = value + 20
					end
				end
			
				if Price<0 then
					return 0
				end
			
				if GetItemCount("", Item,INVENTORY_STD)>0 then
					value = value + 30
					return value
				end
			else
				return 0
			end
		else
			return 0
		end
	else
		return 0
	end

	return value
end

function Execute()
	MeasureRun("SIM", nil, "UseAldermanChain")
end
