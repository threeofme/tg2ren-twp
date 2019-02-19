function Weight()
	local	Item = "ToadExcrements"
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if GetItemCount("", Item, INVENTORY_STD)>0 then
		return 100
	end
	
	if not DynastyGetRandomBuilding("Victim", GL_BUILDING_CLASS_WORKSHOP, -1, "VicBuilding") then
		return 0
	end
	
	if AliasExists("RivalBuild") then
		CopyAlias("RivalBuild", "VicBuilding")
	end
	
	if GetImpactValue("VicBuilding","toadslime")>0 then
		return 0
	end
	
	if GetImpactValue("VicBuilding","toadexcrements")>0 then
		return 0
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price < 0 then
		return 0
	end
	
	if GetMoney("SIM") < 3000 then
		return 0
	end

	return 10
end

function Execute()
	MeasureRun("SIM", "VicBuilding", "UseToadExcrements")
end
