function Weight()
	
	if ScenarioGetDifficulty() < 2 then
		return 0
	end
	
	if DynastyIsShadow("Victim") then
		return 0
	end
	
	if GetImpactValue("SIM", "DeliverTheFalseGauntlet")==0 then
		return 0
	end
	
	-- to do: select a high office holder
	if not DynastyGetRandomVictim("Victim", 60, "VictimDynasty2") then
		return 0
	end
	
	local Count = DynastyGetMemberCount("VictimDynasty2")
	local Victim = Rand(Count)
	if not (DynastyGetMember("VictimDynasty2", Victim, "Victim2")) then
		return false
	end	

	return 20
end


function Execute()
	MeasureCreate("Measure")
	MeasureAddAlias("Measure","Believer","Victim2",false)
	MeasureStart("Measure","SIM","Victim","DeliverTheFalseGauntlet")
end
