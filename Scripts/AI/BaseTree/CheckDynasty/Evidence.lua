function Weight()

	if SimGetAge("SIM")<16 then
		return 0
	end

	if not ReadyToRepeat("dynasty", "AI_Evidence") then
		return 0
	end

	if GetSettlement("SIM", "_city") then
		SetRepeatTimer("dynasty", "AI_Evidence", 1)
		local TopDynastyID = GetProperty("_city","Crimes_TopAccuserDynastyID")
		local TopActorID = GetProperty("_city","Crimes_TopActorID")
		
		if TopDynastyID==GetID("dynasty") then
			if GetAliasByID(TopActorID,"Actor") then
				if GetDynastyID("Actor") ~= GetDynastyID("SIM") then
					if GetSettlementID("Actor") == GetSettlementID("SIM") then
						if DynastyGetDiplomacyState("SIM", "Actor") < DIP_ALLIANCE then
							if DynastyIsShadow("Actor") then
								if SimGetOfficeLevel("Actor")>0 then
									return 100
								else
									return 0
								end
							else
								return 100
							end
						end
					end
				end
			end
		end
	end
	
	return 0
end

function Execute()
	SetRepeatTimer("dynasty", "AI_Evidence", 16)
end