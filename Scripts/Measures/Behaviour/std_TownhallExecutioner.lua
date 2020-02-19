function Run()
	if not HasProperty("","Equiped") then
		AddItems("","Platemail",1,INVENTORY_EQUIPMENT)
		AddItems("","FullHelmet",1,INVENTORY_EQUIPMENT)
		AddItems("","IronBrachelet",1,INVENTORY_EQUIPMENT)
		AddItems("","Longsword",1,INVENTORY_EQUIPMENT)
		AddImpact("","Elite",5,0)
		IncrementXP("",10000)
		SetProperty("","Equiped",1)	
	end

	SetState("",STATE_TOWNNPC,true)
	SetState("", STATE_SCANNING, true)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,23,-1,-1, FILTER_IGNORE,"mytownhall")
		 
	while true do
		-- try to walk to the townhall
		GetInsideBuilding("","currentbuilding")
		if GetID("mytownhall")~=-1 then
			if GetLocatorByName("mytownhall","ExecutionerOffPos","destpos") then
				f_MoveTo("","destpos")
				f_BeginUseLocator("","destpos", GL_STANCE_STAND, true)
			end
		end
		
		Sleep(Gametime2Realtime(1))
		
	end
	
	Sleep(5)
end
