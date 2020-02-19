function Run()
	if not BuildingGetOwner("", "BuildingOwner") then
		return
	end
	
	local currentlevel = BuildingGetLevel("")
	local Proto = ScenarioFindBuildingProto(0, GL_BUILDING_TYPE_RESIDENCE, (currentlevel+1), 0)
	
	if Proto == -1 or currentlevel == 5 then
		MsgQuick("","@P"..
		"@L_UPGRADE_RESIDENCE_FAILED_+0", GetID(""))
		return
	end
	
	
	local currenttitle = GetNobilityTitle("BuildingOwner")
	local maxlevel = GetDatabaseValue("NobilityTitle", currenttitle, "maxresidencelevel")
	
	-- check the title requirements
	
	if currentlevel >= maxlevel then
		MsgQuick("", "@L_GENERAL_MEASURES_073_LEVELUPBUILDING_FAILURES_+0", GetID("BuildingOwner"), GetID(""))
		return
	end

	-- Get the levelup price which is the difference of the buildprice of the two levels of the building
	local UpgradeMoney = 0
	local OldProto = BuildingGetProto("")
	local OldPrice = GetDatabaseValue("Buildings", OldProto, "price")
	local Price = GetDatabaseValue("Buildings", Proto, "price")
	UpgradeMoney = Price - OldPrice
	
	local UpgradeAnswer = MsgNews("","", "@P"..
							"@B[1,@L_UPGRADE_RESIDENCE_ANSWER_+0]"..
							"@B[0,@L_UPGRADE_RESIDENCE_ANSWER_+1]",
							0,
							"economie",
							-1,
							"@L_UPGRADE_RESIDENCE_HEAD_+0",
							"@L_UPGRADE_RESIDENCE_BODY_+0",
							GetID(""), UpgradeMoney)
	
	if UpgradeAnswer ~= 1 then
		return
	end
	
	if not f_SpendMoney("Owner", UpgradeMoney, "BuildingLevelup", false) then
		MsgQuick("", "@L_GENERAL_MEASURES_073_LEVELUPBUILDING_FAILURES_+1", UpgradeMoney, GetID("Owner"))
		return
	end
	
	-- Do the level up
	SetProperty("", "LevelUpProto", Proto)
	SetState("", STATE_LEVELINGUP, true)
end
