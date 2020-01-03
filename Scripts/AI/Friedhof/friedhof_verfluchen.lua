function Weight() 
	if not SimGetWorkingPlace("SIM", "friedhof") then
		return 0
	end

	if BuildingGetLevel("friedhof") < 2 then
		return 0
	else
		if not BuildingHasUpgrade("friedhof","steinkreis") then
			return 0
		end		
	end

	if not IsDynastySim("SIM") then
		return 0
	end

	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("VerFluchen")) > 0 then
		return 0
	end

	if DynastyGetRandomVictim("dynasty", 20, "victim") then
		if DynastyGetDiplomacyState("dynasty", "victim") > DIP_NEUTRAL then
			return 0
		end
		if not DynastyGetRandomBuilding("victim", -1, -1, "victimhouse") then
			return 0
		end
	end 

	if GetItemCount("SIM", "Schadelkerze")>=6 then
		return 100
	else

	if not GetRemainingInventorySpace("",966,INVENTORY_STD) then
		return 0	
	end
		
	local KerzenId = ItemGetID("Schadelkerze")
	local Kerzen = GetProperty("friedhof", "Salescounter"..KerzenId) or 0
	if Kerzen > 6 then
		return 100
	end
	
	end	
end

function Execute()
	if GetItemCount("SIM", "Schadelkerze") <= 6 then
		f_MoveTo("SIM", "friedhof", GL_MOVESPEED_RUN)
	end

	-- still enough there?
	local Kerzen = GetProperty("friedhof", "Salescounter"..KerzenId) or 0
	if Kerzen > 6 then
		economy_BuyItems("friedhof", "", KerzenId, 6)
	end

	Sleep(2)
	MeasureRun("SIM","victimhouse","VerFluchen")
end
