function Run()

	SimGetWorkingPlace("", "workbuilding")
	if GetInsideBuildingID("") == GetID("workbuilding") then
		f_ExitCurrentBuilding("")
	end
	chr_CalculateBuildingBonus("","workbuilding","fire")
    
	-- instead of lowering the values, we simply introduce a blockade. A fired sim can't be married for 5 turns from the dynasty who fired him
	local DynID = GetDynastyID("workbuilding")
	SetProperty("","NoMarry",DynID)
	SetProperty("","NoMarryTime",GetGametime()+120)
	SimResetBehavior("")
	SimSetProduceItemID("", -1, -1)

	Fire("")
end
