function AIDecision()
	return 1
end

function Run()

    -- local plage = GetImpactValue("", 379)
	-- if plage and plage>0.1 then
	    -- return
	-- end

	if not chr_CheckDestroy() then
		return
	end

	local Value		= BuildingGetValue("")
	local Result	= MsgNews("","","@P"..
			"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
			"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
			ms_076_teardownbuilding_AIDecision,  --AIFunc
			"building", --MessageClass
			2, --TimeOut
			"@L_INTERFACE_TEARDOWN_MSG_HEAD_+0",
			"@L_INTERFACE_TEARDOWN_MSG_BODY_+0",
			GetID(""),Value)
			
	if Result == "C" then
		return
	end

	MeasureSetNotRestartable()
	
	local filter
	if ResourceGetItemId("") == 6 then
	    filter ="__F( (Object.GetObjectsByRadius(Sim)==700)AND(Object.GetProfession()==58)AND(Object.HasImpact(HueteTier)))"
	elseif ResourceGetItemId("") == 8 then
	    filter ="__F( (Object.GetObjectsByRadius(Sim)==700)AND(Object.GetProfession()==55)AND(Object.HasImpact(HueteTier)))"
	elseif ResourceGetItemId("") == 11 then
	    filter ="__F( (Object.GetObjectsByRadius(Sim)==700)AND(Object.GetProfession()==57)AND(Object.HasImpact(HueteTier)))"
	end
	if filter then
	    local k = Find("",filter,"PflegeViehs",6)
	    for l=0, k do
		    InternalDie("PflegeViehs"..l)
	      InternalRemove("PflegeViehs"..l)
	    end
	end
	BuildingGetOwner("", "FormerOwner")
	bld_ClearBuildingStash("", "FormerOwner")
	f_CreditMoney("FormerOwner", Value, "BuildingSold")
	SetState("", STATE_DEAD, true)
	
end
