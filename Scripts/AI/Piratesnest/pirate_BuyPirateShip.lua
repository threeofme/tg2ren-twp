function Weight()

	if not SimGetWorkingPlace("SIM","PirateHarbor") then
		return 0
	end
	
	if not ReadyToRepeat("PirateHarbor", "ai_BuyPirateShip") then
		return 0
	end
	
	local Found = false
	for i=0,BuildingGetCartCount("PirateHarbor")-1 do
		if BuildingGetCart("PirateHarbor",i,"Cart") then
			if CartGetType("Cart")==EN_CT_CORSAIR then
				Found = true
				break
			end
		end
	end
	
	if Found then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("PirateHarbor", "ai_BuyPirateShip", 24)
	BuildingBuyCart("PirateHarbor",EN_CT_CORSAIR,true,"PirateShip")
end

