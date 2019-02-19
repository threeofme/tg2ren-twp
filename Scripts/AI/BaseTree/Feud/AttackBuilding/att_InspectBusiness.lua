function Weight()

	local Hour = math.mod(GetGametime(), 24)
	if Hour < 8 or Hour > 16 then
		return 0
	end

	if GetImpactValue("SIM", "InspectBusiness")==0 then
		return 0
	end
	
	if GetImpactValue("dynasty","BeeingInspected")==1 then
		return 0
	end	

	if GetMeasureRepeat("SIM", "InspectBusiness")>0 then
		return 0
	end

	if not GetSettlement("SIM", "CityAlias") then
		return 0
	end

	local NumServant = CityGetServantCount("CityAlias", GL_PROFESSION_INSPECTOR)
	if not CityGetServant("CityAlias", Rand(NumServant), GL_PROFESSION_INSPECTOR, "ib_Servant") then
		return 0
	end

	if not GetState("ib_Servant", STATE_IDLE) then
		return 0
	end
	
	for trys=0,5 do
		
		if AliasExists("RivalBuild") then
			CopyAlias("RivalBuild", "ib_Target")
			return 50
		end
		
		if DynastyGetRandomBuilding("VictimDynasty",2,-1,"ib_Target") then
			if GetSettlementID("ib_Target") == GetSettlementID("SIM") then
				return 50
			end
		end

	end

	return 0
end

function Execute()
	MeasureRun("ib_Servant","ib_Target","InspectBusiness")
end

