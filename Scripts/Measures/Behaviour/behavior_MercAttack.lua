function Run()
	if GetProperty("", "Victim")==nil then
		local HeadMoney = GetProperty("", "HeadMoney")
		local Protectorate = GetProperty("", "Protectorate")
		RemoveProperty("","HeadMoney")
		RemoveProperty("","Protectorate")
		chr_RecieveMoney("dynasty", HeadMoney, "HeadMoney")

		if not SimGetWorkingPlace("","MyHome") then
			if IsPartyMember("") then
				local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_MERCENARY)
				if NextBuilding then
					CopyAlias(NextBuilding,"MyHome")
				end
			end
		end
		if AliasExists("MyHome") then
			BuildingGetCity("MyHome","city")
			if GetMoney("city")>HeadMoney then
				f_SpendMoney("city", HeadMoney, "Mercenaries")
				f_CreditMoney("MercOwner", HeadMoney, "HeadMoneyCity")
				
				local MercMoney = HeadMoney
				if HasProperty("city", "Mercenaries") then
					MercMoney = MercMoney + GetProperty("city", "Mercenaries")
				end
				SetProperty("city", "Mercenaries", MercMoney)
			end
		end

		MeasureRun("",Protectorate,"Protectorate",true)
	else
		local VictimID = GetProperty("", "Victim")
		if not (GetAliasByID(VictimID,"Victim") and GetState("Victim", STATE_DEAD)==false) then
			RemoveProperty("","Victim")
		end
	end
end

