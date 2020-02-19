function Run()
	SetState("",STATE_TOWNNPC,true)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,23,-1,-1, FILTER_IGNORE,"mytownhall")
		 
	while true do
		-- try to walk to the townhall
		GetInsideBuilding("","currentbuilding")
		if GetID("mytownhall")~=-1 then
			if GetLocatorByName("mytownhall","UsherChairPos","destpos") then
				--f_MoveTo("","destpos")
				--PlayAnimationNoWait("Cogitate")
				while true do
					if f_BeginUseLocator("","destpos", GL_STANCE_SIT, true) then
						break 
					end
					Sleep(2)
				end
	
				--f_BeginUseLocator("","destpos", GL_STANCE_SIT, true)
				
				SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)	
			end
		end

		--PlayAnimation("","idle_panel")
		--PlayAnimation("","idle_panel")
		--PlayAnimation("","idle_panel")
		--Sleep(10)
		--PlayAnimation("","use_book_standing")
		while true do
			std_usher_CheckAge()
			Sleep(500)
		end
	end
	
	Sleep(5)
end

function CheckAge()
	if SimGetAge("")>55 then
		SimSetAge("", 45)
	end
end

function CleanUp()
	if AliasExists("destpos") then
		f_EndUseLocator("","destpos",GL_STANCE_SIT)
	end
	AllowAllMeasures("")
end


