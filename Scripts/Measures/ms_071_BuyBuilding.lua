function Run()
	
	local Cost = BuildingGetBuyPrice("")
	if (GetMoney("dynasty") < Cost) then
		MsgQuick("dynasty", "@L_GENERAL_MEASURES_071_BUYBUILDING_FAILURES_+1", Cost, GetID(""))
		return
	end
	
	if HasProperty("","PlunderInProgress") then
		return
	end
	
	if BuildingGetClass("") == 2 then
		if not CanBuildWorkshop("dynasty") then
			MsgQuick("dynasty", "@L_GENERAL_MEASURES_FAILURES_+24", GetMaxWorkshopCount("dynasty"))
			return
		end
	end
	
	-- check if building is an estate
	if BuildingGetType("")==111 then
		local BossID = dyn_GetValidMember("dynasty")
		GetAliasByID(BossID, "Boss")
		if GetNobilityTitle("Boss")<8 then
			MsgQuick("dynasty", "@L_GENERAL_BUILDING_CASTLE_FAILURE_+0")
			return
		else
			local	Count = DynastyGetBuildingCount2("dynasty")
			for l=0,Count-1 do
				if DynastyGetBuilding2("dynasty", l, "Check") then
					if BuildingGetType("Check")==111 then
						MsgQuick("dynasty", "@L_GENERAL_BUILDING_CASTLE_FAILURE_+1")
						return
					end
				end
			end
		end
	end
	
	if not AliasExists("Destination") then 
	
		local Class	= BuildingGetCharacterClass("")
		local Count = DynastyGetMemberCount("dynasty")
		local	Number = 0

		for Number=0,Count-1 do
			if DynastyGetMember("dynasty", Number, "Member") then
				if Class==GL_CLASS_NONE or Class==SimGetClass("Member") then
					if BuildingCanBeOwnedBy("","Member") then
						CopyAlias("Member", "Destination")
						break;
					end
				end
			end
		end
	end
	
	if not AliasExists("Destination") then
		MsgQuick("dynasty", "@L_GENERAL_MEASURES_071_BUYBUILDING_FAILURES_+0", GetID(""))
		return
	end
	
	local Result = MsgNews("Destination","","@P"..
				"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
				"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
				ms_071_buybuilding_AIDecision,  --AIFunc
				"building", --MessageClass
				2, --TimeOut
				"@L_GENERAL_MEASURES_071_BUYBUILDING_MSG_HEAD_+0",
				"@L_GENERAL_MEASURES_071_BUYBUILDING_MSG_BODY_+0",
				GetID(""),Cost)
	if Result == "C" then
		return
	end
	
	BuildingGetOwner("Owner", "FormerOwner")
	
	if not BuildingBuy("Owner", "Destination", BM_NORMAL) then
		MsgQuick("dynasty", "@L_GENERAL_MEASURES_071_BUYBUILDING_FAILURES_+2", GetID("Destination"), GetID(""))
		return
	end

	feedback_MessageWorkshop("Destination",
		"@L_GENERAL_MEASURES_071_BUYBUILDING_SUCCESS_HEAD_+0",
		"@L_GENERAL_MEASURES_071_BUYBUILDING_SUCCESS_BODY_+0", GetID("Destination"), GetID("Owner"), Cost)

-- this message is moved into the source code, to notify the user, if the ai buys a players building
--	if AliasExists("FormerOwner") then
--		feedback_MessageWorkshop("FormerOwner",
--			"@L_GENERAL_MEASURES_071_BUYBUILDING_FORMER_OWNER_HEAD_+0",
--			"@L_GENERAL_MEASURES_071_BUYBUILDING_FORMER_OWNER_BODY_+0", GetID("Destination"), GetID("Owner"), Cost)
--	end

  -- XXX force former workers to stop working
  bld_HandleNewOwner("") 
  SetState("", STATE_SELLFLAG, false)
--	GetLocalPlayerDynasty("LocalPlayer")
	if DynastyIsPlayer("") then
		PlaySound3D("", "fanfare/FanfarPositiveShort_s_01.ogg", 1.0)
	end
	
	
end

function AIDecision()
	return "O"
end

