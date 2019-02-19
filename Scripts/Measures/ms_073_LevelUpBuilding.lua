function Run()
	
	local Proto = GetData("Proto")
	
	-- check whether the dynastysim can build this building	
	if(not(BuildingCanLevelUp("", Proto))) then
		BuildingGetOwner("", "BuildingOwner")
		MsgQuick("", "@L_GENERAL_MEASURES_073_LEVELUPBUILDING_FAILURES_+0", GetID("BuildingOwner"), GetID(""))
		return
	end
	
	-- Get the levelup price which is the difference of the buildprice of the two levels of the building
	local UpgradeMoney = 0
	local OldProto	= BuildingGetProto("")
	local OldPrice	= GetDatabaseValue("Buildings", OldProto, "price")
	local Price			= GetDatabaseValue("Buildings", Proto, "price")
	UpgradeMoney		= Price - OldPrice
	
	if not f_SpendMoney("Owner", UpgradeMoney, "BuildingLevelup", false) then
		MsgQuick("", "@L_GENERAL_MEASURES_073_LEVELUPBUILDING_FAILURES_+1", UpgradeMoney, GetID("Owner"))
		return
	end
	SetProperty("", "LevelUpProto", Proto)
	SetState("", STATE_LEVELINGUP, true)
end


