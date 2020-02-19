function Run()
	SetState("",STATE_TOWNNPC,true)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,GL_BUILDING_TYPE_DUELPLACE,-1,-1,FILTER_IGNORE,"duel_place")
	
		 
	while true do
		-- try to walk to the townhall
		if GetID("duel_place")~=-1 then
			if GetLocatorByName("duel_place","Sekundant1","Sekundant1Pos") then
				f_BeginUseLocator("","Sekundant1Pos", GL_STANCE_STAND, true)
			
				LoopAnimation("","idle")	
			end
		end

		while true do
			Sleep(1000)
		end
	end
	
	Sleep(5)
end

function CleanUp()

end

