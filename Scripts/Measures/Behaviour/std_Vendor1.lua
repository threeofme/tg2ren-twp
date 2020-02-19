function Run()
	SetState("",STATE_TOWNNPC,true)
	SetProperty("","Vendor",1)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)	
	Sleep(Rand(3)+1)
	if CityGetRandomBuilding("homecity",-1,14,1,-1, FILTER_IGNORE,"mymarket_resource") then
		if not HasProperty("mymarket_resource","OPEN") then
			if GetLocatorByName("mymarket_resource","vendor","SalePosResource") then
				SimSetClass("",GL_CLASS_ARTISAN)
				SetProperty("mymarket_resource","OPEN",1)
				BlockLocator("","SalePosResource")
				if not f_MoveTo("","SalePosResource") then
					SimBeamMeUp("","SalePosResource",false)
				end
				while true do
					Sleep(Rand(49)+73)
				end
				
			end
		end
	end
	if CityGetRandomBuilding("homecity",-1,14,2,-1, FILTER_IGNORE,"mymarket_food") then
		if not HasProperty("mymarket_food","OPEN") then
			if GetLocatorByName("mymarket_food","vendor","SalePosFood") then
				SimSetClass("",GL_CLASS_PATRON)
				SetProperty("mymarket_food","OPEN",1)
				BlockLocator("","SalePosFood")
				if not f_MoveTo("","SalePosFood") then
					SimBeamMeUp("","SalePosFood",false)
				end
				while true do
					Sleep(Rand(49)+73)
				end
				
			end
		end
	end
	if CityGetRandomBuilding("homecity",-1,14,3,-1, FILTER_IGNORE,"mymarket_smithy") then
		if not HasProperty("mymarket_smithy","OPEN") then
			if GetLocatorByName("mymarket_smithy","vendor","SalePosSmithy") then
				SimSetClass("",GL_CLASS_ARTISAN)
				SetProperty("mymarket_smithy","OPEN",1)
				BlockLocator("","SalePosSmithy")
				if not f_MoveTo("","SalePosSmithy") then
					SimBeamMeUp("","SalePosSmithy",false)
				end
				while true do
					Sleep(Rand(49)+73)
				end
				
			end
		end
	end
	if CityGetRandomBuilding("homecity",-1,14,4,-1, FILTER_IGNORE,"mymarket_textile") then
		if not HasProperty("mymarket_textile","OPEN") then
			if GetLocatorByName("mymarket_textile","vendor","SalePosTextile") then
				SimSetClass("",GL_CLASS_ARTISAN)
				SetProperty("mymarket_textile","OPEN",1)
				BlockLocator("","SalePosTextile")
				if not f_MoveTo("","SalePosTextile") then
					SimBeamMeUp("","SalePosTextile",false)
				end
				while true do
					Sleep(Rand(49)+73)
				end
				
			end
		end
	end
	if CityGetRandomBuilding("homecity",-1,14,5,-1, FILTER_IGNORE,"mymarket_alchemist") then
		if not HasProperty("mymarket_alchemist","OPEN") then	
			if GetLocatorByName("mymarket_alchemist","vendor","SalePosAlchemist") then
				SimSetClass("",GL_CLASS_SCHOLAR)
				SetProperty("mymarket_alchemist","OPEN",1)
				BlockLocator("","SalePosAlchemist")
				if not f_MoveTo("","SalePosAlchemist") then
					SimBeamMeUp("","SalePosAlchemist",false)
				end
				while true do
					Sleep(Rand(49)+73)
				end
				
			end
		end
	end
	if CityGetRandomBuilding("homecity",-1,14,7,-1, FILTER_IGNORE,"mymarket_handicraft") then
		if not HasProperty("mymarket_handicraft","OPEN") then
			if GetLocatorByName("mymarket_handicraft","vendor","SalePosHandicraft") then
				SimSetClass("",GL_CLASS_ARTISAN)
				SetProperty("mymarket_handicraft","OPEN",1)
				BlockLocator("","SalePosHandicraft")
				if not f_MoveTo("","SalePosHandicraft") then
					SimBeamMeUp("","SalePosHandicraft",false)
				end
				while true do
					Sleep(Rand(49)+73)
				end
				
			end
		end
	end
end
