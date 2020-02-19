function Run()
	SetState("",STATE_TOWNNPC,true)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,GL_BUILDING_TYPE_DUELPLACE, -1, -1, FILTER_IGNORE,"duel_place")
	
	while true do
		-- try to walk to the duel_place
		if GetID("duel_place")~=-1 then
			if GetLocatorByName("duel_place","Doctor","DoctorPos") then
				f_BeginUseLocator("","DoctorPos", GL_STANCE_STAND, true)
				--LoopAnimation("","idle")	
			end
		end

		while true do
			Sleep(100)
		end
	end
	
	Sleep(5)
end

function CleanUp()
	if AliasExists("DoctorPos") then
		f_EndUseLocator("","DoctorPos",GL_STANCE_STAND)
	end
end

