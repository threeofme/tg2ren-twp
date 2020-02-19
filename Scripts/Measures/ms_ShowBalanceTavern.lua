function Run()

	CopyAlias("","Tavern")

	local Balance = 0
	local BalanceLastItem = "GrainPap"
	local BalanceItemCount = 0
	BuildingGetOwner("Tavern","TavernOwner")
	local BalanceLastBuyer = GetID("TavernOwner")
	local BalanceSmallBeer = 0
	local BalanceSmallBeerSum = 0
	local BalanceWheatBeer = 0
	local BalanceWheatBeerSum = 0
	local BalanceWein = 0
	local BalanceWeinSum = 0
	local BalanceGrainPap = 0
	local BalanceGrainPapSum = 0
	local BalanceSalmonFilet = 0
	local BalanceSalmonFiletSum = 0
	local BalanceRoastBeef = 0
	local BalanceRoastBeefSum = 0
	local BalanceService = 0
	local Service
	local BalanceLastPrice = 0
	local SmallBeerAvg = 0
	local WheatBeerAvg = 0
	local WeinAvg = 0
	local GrainPapAvg = 0
	local SalmonFiletAvg = 0
	local RoastBeefAvg = 0
	local BalanceDancingFee = 0
	local BalanceBathingFee = 0
	local BalanceSleepingFee = 0
	local BalanceBewitchingFee = 0
	local BalanceDanceShow = 0
	local BalanceVersengold = 0
	local BalanceVisitors = 0
	local Wages = 0

	if HasProperty("Tavern","Balance") then
		Balance = GetProperty("Tavern","Balance")
	end
	if HasProperty("Tavern","BalanceLastItem") then
		BalanceLastItem = GetProperty("Tavern","BalanceLastItem")
	end
	if HasProperty("Tavern","BalanceItemCount") then
		BalanceItemCount = GetProperty("Tavern","BalanceItemCount")
	end
	if HasProperty("Tavern","BalanceLastBuyer") then
		BalanceLastBuyer = GetProperty("Tavern","BalanceLastBuyer")
	end
	if HasProperty("Tavern","BalanceSmallBeer") then
		BalanceSmallBeer = GetProperty("Tavern","BalanceSmallBeer")
	end
	if HasProperty("Tavern","BalanceSmallBeerSum") then
		BalanceSmallBeerSum = GetProperty("Tavern","BalanceSmallBeerSum")
	end
	if HasProperty("Tavern","BalanceWheatBeer") then
		BalanceWheatBeer = GetProperty("Tavern","BalanceWheatBeer")
	end
	if HasProperty("Tavern","BalanceWheatBeerSum") then
		BalanceWheatBeerSum = GetProperty("Tavern","BalanceWheatBeerSum")
	end
	if HasProperty("Tavern","BalanceWein") then
		BalanceWein = GetProperty("Tavern","BalanceWein")
	end
	if HasProperty("Tavern","BalanceWeinSum") then
		BalanceWeinSum = GetProperty("Tavern","BalanceWeinSum")
	end
	if HasProperty("Tavern","BalanceGrainPap") then
		BalanceGrainPap = GetProperty("Tavern","BalanceGrainPap")
	end
	if HasProperty("Tavern","BalanceGrainPapSum") then
		BalanceGrainPapSum = GetProperty("Tavern","BalanceGrainPapSum")
	end
	if HasProperty("Tavern","BalanceSalmonFilet") then
		BalanceSalmonFilet = GetProperty("Tavern","BalanceSalmonFilet")
	end
	if HasProperty("Tavern","BalanceSalmonFiletSum") then
		BalanceSalmonFiletSum = GetProperty("Tavern","BalanceSalmonFiletSum")
	end
	if HasProperty("Tavern","BalanceRoastBeef") then
		BalanceRoastBeef = GetProperty("Tavern","BalanceRoastBeef")
	end
	if HasProperty("Tavern","BalanceRoastBeefSum") then
		BalanceRoastBeefSum = GetProperty("Tavern","BalanceRoastBeefSum")
	end
	if HasProperty("Tavern","BalanceService") then
		BalanceService = GetProperty("Tavern","BalanceService")
	end
	if HasProperty("Tavern","BalanceLastPrice") then
		BalanceLastPrice = GetProperty("Tavern","BalanceLastPrice")
	end
	if HasProperty("Tavern","BalanceDancingFee") then
		BalanceDancingFee = GetProperty("Tavern","BalanceDancingFee")
	end
	if HasProperty("Tavern","BalanceBathingFee") then
		BalanceBathingFee = GetProperty("Tavern","BalanceBathingFee")
	end
	if HasProperty("Tavern","BalanceSleepingFee") then
		BalanceSleepingFee = GetProperty("Tavern","BalanceSleepingFee")
	end
	if HasProperty("Tavern","BalanceBewitchingFee") then
		BalanceBewitchingFee = GetProperty("Tavern","BalanceBewitchingFee")
	end
	if HasProperty("Tavern","BalanceDanceShow") then
		BalanceDanceShow = GetProperty("Tavern","BalanceDanceShow")
	end
	if HasProperty("Tavern","BalanceVersengold") then
		BalanceVersengold = GetProperty("Tavern","BalanceVersengold")
	end
	if HasProperty("Tavern","BalanceVisitors") then
		BalanceVisitors = GetProperty("Tavern","BalanceVisitors")
	end
	
	if BalanceService == 1 then
		Service = "@L_MEASURE_showbalancetavern_SERVICE"
	else
		Service = "@L_MEASURE_showbalancetavern_NOSERVICE"
	end
	
	-- wages
	local numFound = 0
	local	Alias
	local count = BuildingGetWorkerCount("Tavern")
	
	for number=0, count-1 do
		Alias = "Worker"..numFound
		if BuildingGetWorker("Tavern", number, Alias) then
			numFound = numFound + 1
		end
	end
	
	if numFound > 0 then
		for loop_var=0, numFound-1 do
			Alias = "Worker"..loop_var
			Wages = Wages + SimGetWage(Alias,"Tavern")
		end
	end
	
	SmallBeerAvg = math.floor(BalanceSmallBeerSum/BalanceSmallBeer)
	WheatBeerAvg = math.floor(BalanceWheatBeerSum/BalanceWheatBeer)
	WeinAvg = math.floor(BalanceWeinSum/BalanceWein)
	GrainPapAvg = math.floor(BalanceGrainPapSum/BalanceGrainPap)
	SalmonFiletAvg = math.floor(BalanceSalmonFiletSum/BalanceSalmonFilet)
	RoastBeefAvg = math.floor(BalanceRoastBeefSum/BalanceRoastBeef)

	MsgBoxNoWait("dynasty", "Tavern", "@L_MEASURE_showbalancetavern_HEAD_+0",
						"@L_MEASURE_showbalancetavern_BODY_+0",GetID("Tavern"), 
						BalanceLastBuyer, BalanceItemCount, ItemGetLabel((BalanceLastItem),false),BalanceLastPrice, 
						Service, 
						BalanceSmallBeer, BalanceSmallBeerSum,
						BalanceWheatBeer, BalanceWheatBeerSum,
						BalanceWein, BalanceWeinSum,
						BalanceGrainPap, BalanceGrainPapSum,
						BalanceSalmonFilet, BalanceSalmonFiletSum,
						BalanceRoastBeef, BalanceRoastBeefSum,
						Balance,
						SmallBeerAvg,WheatBeerAvg,WeinAvg,GrainPapAvg,SalmonFiletAvg,RoastBeefAvg,
						BalanceDancingFee, BalanceSleepingFee, BalanceBathingFee, BalanceBewitchingFee, BalanceDanceShow, BalanceVersengold, BalanceVisitors,
						Wages
						)

end
