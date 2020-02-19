function Run()
	SetState("",STATE_TOWNNPC,true)
	FindNearestBuilding("", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "myweddingchapel")
	BuildingGetCity("myweddingchapel","homecity")

	while true do
		-- try to walk to the wedding chapel
		if GetID("myweddingchapel")~=-1 then
			if GetLocatorByName("myweddingchapel","WeddingPriest","destpos") then
				while true do
					if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
						break 
					end
					Sleep(2)
				end
	
				SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)	
			end
		end

		while true do
			std_weddingpriest_CheckAge()
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
		f_EndUseLocator("","destpos",GL_STANCE_STAND)
	end
	AllowAllMeasures("")
end


