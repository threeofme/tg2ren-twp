function Run()

	local HorseAllowed = false

	GetDynasty("", "Dyn")
	local	Count = DynastyGetBuildingCount2("Dyn")
	for l=0,Count-1 do
		if DynastyGetBuilding2("Dyn", l, "Check") then
			if BuildingGetType("Check")==111 then
				if BuildingHasUpgrade("Check", "stallung") then
					HorseAllowed = true
				end
			end
		end
	end

	if IsMounted("") then
		SetState("", STATE_RIDING, false)
		if HorseAllowed == false then
			RemoveItems("","Bridle",1)
			MsgQuick("", "@L_USE_HORSE_FAILURE_+0")
			StopMeasure()
		end
	else
		if HorseAllowed == false then
			RemoveItems("","Bridle",1)
			MsgQuick("", "@L_USE_HORSE_FAILURE_+0")
			StopMeasure()
		else
			SetState("", STATE_RIDING, true)
		end
	end

end
