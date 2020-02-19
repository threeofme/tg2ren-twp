function Run()
	if IsGUIDriven() then
		GetInsideBuilding("","Destination")
	end

	if not AliasExists("Destination") then
		return 
	end
	
	if GetInsideBuildingID("")~=GetID("Destination") then
		-- sim is not in building - first move to church
		if not GetOutdoorMovePosition("", "Destination", "MovePos") then
			return
		end
		
		if not f_MoveTo("", "MovePos") then
			return
		end
	end
	
	local	TimeOut

	-- wait up to 3 hours for beginning of mass
	if GetImpactValue("Destination","MassInProgress")~=1 then
	
		TimeOut = math.mod(GetGametime(),24)+3
		while GetImpactValue("Destination","MassInProgress")~=1 and (math.mod(GetGametime(),24)<TimeOut) do
			Sleep(3)
			PlayAnimation("","cogitate")
			Sleep(2)
			if Rand(5) == 0 then
				f_Stroll("", 400, 2)
			end
			Sleep(1.5)
		end
		
		if GetImpactValue("Destination","MassInProgress")~=1 then
			return
		end

	end

	SetAvoidanceRange("",15)
	local success = false
	local	Value
	
	for trys=0,10 do
		Value = Rand(29)+1
		if GetFreeLocatorByName("Destination","Sit",Value,Value,"SitPos") then
			success = f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
			if success then
				break
			end
		end
	end
	
	if not success then
		if GetFreeLocatorByName("Destination","Sit",1,29,"SitPos") then
			success = f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
		end
	end
	
--	if not success then
--		LocIndex = 1 + Rand(5)
--		GetLocatorByName("Destination","Stroll"..LocIndex,"MovePos")
--		SetAvoidanceRange("",15)
--		success = f_MoveToNoWait("", "MovePos",GL_MOVESPEED_WALK,300)
--	end
	
	if not success then
		-- sim was unable to get to it's position, so the church is closed ?
		return
	end

	BuildingGetOwner("Destination","Boss")	
	local	Attr = GetImpactValue("Destination", "Attractivity") + 1
	local Money = math.floor(GetSkillValue("Boss", RHETORIC) * SimGetRank("") * Attr) + 7
	if GetImpactValue("Destination","FalseRelict")>0 then
		Money = Money + 10
	end
	SetData("MessMoney",Money)
	local Transfered
	local HouselTaken = false
	local HasKerzen = GetItemCount("", "Kerzen")
	SetData("Endtime",math.mod(GetGametime(),24)+3)
	
	while (math.mod(GetGametime(),24)<GetData("Endtime")) do

		Sleep(12)

		if not HouselTaken then
			local BoughtHousels = economy_BuyItems("Destination", "", ItemGetID("Housel"), 1)
			if BoughtHousels >= 1 then
				HouselTaken = true
			end
		end
		
		-- Fajeth Mod
		if HasKerzen>0 then
			RemoveItems("", "Kerzen", 1)
			if (SimGetReligion("")==0) then
				chr_SimModifyFaith("",1,0)
			else
				chr_SimModifyFaith("",1,1)
			end
			Sleep(0.8)
			chr_GainXP("",25)
		end
		-- Mod end

		if GetDynastyID("Destination") ~= GetDynastyID("") then
			f_CreditMoney("Destination", Money, "Offering")
			economy_UpdateBalance("Destination", "Service", Money)
		end
		
		if GetImpactValue("Destination","MassInProgress")~=1 then
			break
		end
		
		if Rand(20) == 1 then
			MsgSayNoWait("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_COMMENT")
		end
		
		Sleep(12)
	end
	
	SatisfyNeed("", 4, 1)
	
	if GetDynastyID("Destination") ~= GetDynastyID("") then
		if GetImpactValue("Destination","gargoyle") == 1 then
			chr_ModifyFavor("","Boss",5)
		end
	end
	
	if GetImpactValue("Destination","FalseRelict")>0 then
		MsgNewsNoWait("","Destination","","building",-1,
						"@L_MEASURE_ATTENDMASS_FALSERELICT_HEAD", "@L_MEASURE_ATTENDMASS_FALSERELICT_BODY",GetID(""),GetID("Destination"))
		chr_GainXP("",200)
	end
	
	CommitAction("church","","","")
	ms_attendmass_AffectFaith()
	StopAction("church","")
end

function CleanUp()
	StopAction("church","")
	SetAvoidanceRange("",-1)
	AddImpact("","WasInChurch",1,4)
	if SimIsInside("") and IsGUIDriven() then
		SetState("", STATE_EXPEL, true)
	end
	if DynastyIsAI("") then
		idlelib_GoHome("")
		return
	end
end

function AffectFaith()
	-- eigener Glauben steigt
	SimSetFaith("",SimGetFaith("")+5)
	local MyFaith = SimGetFaith("")
	
	if(f_SpendMoney("",GetData("MessMoney"),"MessMoney")) then
		-- gunst steigt bei allen Dynastien deren Anführer die gleiche Religion hat 
		GetDynasty("", "dynasty")
		local iCount = ScenarioGetObjects("Dynasty", 99, "Dynasties")
		
		if iCount==0 then
			return
		end
	
		for dyn=0, iCount-1 do
			Alias = "Dynasties"..dyn
			if not (GetID(Alias)==GetID("dynasty")) then
				local BossID = dyn_GetValidMember(Alias)
				GetAliasByID(BossID, "char")
				if SimGetReligion("")==SimGetReligion("char") then
					ModifyFavorToDynasty("",Alias,MyFaith*SimGetFaith("char")/1000) -- 0..10
				end
			end
		end	
		
		-- gunst steigt bei anwesenden sims gleichen glaubens
		if GetInsideBuilding("","church") then
			BuildingGetInsideSimList("church","sim_list")
			for i=0,ListSize("sim_list")-1 do
				ListGetElement("sim_list",i,"sim")
				if SimGetReligion("")==SimGetReligion("sim") then
					chr_ModifyFavor("","sim",MyFaith*SimGetFaith("sim")/1000)	-- 0..10
				end
			end
		end
	end
end
