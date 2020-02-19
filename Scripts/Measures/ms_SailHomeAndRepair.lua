function Run()
	GetHomeBuilding("","MyHarbour")
	if not f_MoveTo("","MyHarbour",GL_MOVESPEED_RUN) then
		return
	end
	
	--arm the ship
	if not HasProperty("","Fights") then
		SetProperty("","Fights",0)	
	end
	
	local Fights = GetProperty("","Fights") + 1
	SetProperty("","Fights",Fights)
	
	local Modifier = 0.25 --light
	if Fights < 4 then
		Modifier = 0.5 --medium
	else
		Modifier = 1 --heavy
	end
	
	local CrewUpgrade = false
	local ShipUpgrade = false
	local IsDynastyShip = false
	local Budget = GetMoney("MyHarbour")
	
	local CartType = CartGetType("")
	local RepairPrice = gameplayformulas_CalcCartRepairPrice(CartType, GetHPRelative(""))
	
	if RepairPrice < Budget then
		Budget = Budget - RepairPrice
		SetData("RestoreBudget",RepairPrice)
	end
	
	if GetDynastyID("MyHarbour") > 0 then
		IsDynastyShip = true
		if BuildingGetAISetting("MyHarbour","Workers") > 0 then
			CrewUpgrade = true
		end
		if BuildingGetAISetting("MyHarbour","Budget") > 0 then
			ShipUpgrade = true
		end
	end
	
	if not HasData("RaiseMenTo") then
		CrewUpgrade = false
	end
	
	if GetImpactValue("","UpgradedToday")>0 then
		ShipUpgrade = false
	end
	
	--crew
	if IsDynastyShip then
		if CrewUpgrade then	
			local MaxCrew = GetProperty("","ShipMenCntMax")
			local CurrentCrew = GetProperty("","ShipMenCnt")
			local NewCrew = 0
			
			local EnemyCrew = GetData("RaiseMenTo")
			NewCrew = EnemyCrew + (EnemyCrew *0.1) + 10
			
			local CrewCost = NewCrew * 50
			if CrewCost < (Budget) then
				Budget = Budget - CrewCost
				SetProperty("","ShipMenCnt",NewCrew)
			else
				if Budget > 0 then
					NewCrew = CurrentCrew + Budget / 50
				end
				Budget = 0
				SetProperty("","ShipMenCnt",NewCrew)
			end
			
		end
	else
		local MaxCrew = GetProperty("","ShipMenCntMax")
		local CurrentCrew = GetProperty("","ShipMenCnt")
		local NewCrew = 0
		if CurrentCrew < MaxCrew then
			if Modifier == 0 then
				Modifier = 0.25
			end
			NewCrew = Modifier * MaxCrew
			SetProperty("","ShipMenCnt",NewCrew)
		end
	end

	-- armament
	if IsDynastyShip then
		if ShipUpgrade then
			local UpgradeCosts = 0
			local UpgradeNeed = 0
			--no crew upgrade
			if GetImpactValue("","ShipMenMod") <= 1 then
				UpgradeNeed = 0.5
			--upgrade 1 is done
			elseif GetImpactValue("","ShipMenMod") <= 1.5 then
				UpgradeNeed = 1
			--all upgrades there
			else
				UpgradeNeed = 0
			end
			
			if UpgradeNeed > 0 then		
				if UpgradeNeed == 0.5 then
					UpgradeCosts = 250
				else
					UpgradeCosts = 500
				end
				
				if UpgradeCosts < Budget then
					if f_SpendMoney("MyHarbour",UpgradeCosts,"Upgrades") then
						Budget = Budget - UpgradeCosts
						AddImpact("","ShipMenMod",0.5,-1) -- 1 for normal, 1.50 for  cutlass, 2.00 for muskets
						if GetImpactValue("","UpgradedToday")==0 then
							AddImpact("","UpgradedToday",1,12)
						end
					end
				end
			end
			
			local ImpactType = "ShipCannonMod"
			
			for i=0,1 do
				if i == 1 then
					ImpactType = "ShipHitpointMod"	
				end
				UpgradeCosts = 0
				UpgradeNeed = 0
				
				--no canon upgrades
				if GetImpactValue("",ImpactType) <= 1 then
					UpgradeNeed = 0.25
				--light upgrades	
				elseif GetImpactValue("",ImpactType) <= 1.25 then
					UpgradeNeed = 0.5
				--medium upgrades
				elseif GetImpactValue("",ImpactType) <= 1.5 then
					UpgradeNeed = 1
				--all upgrades
				else
					UpgradeNeed = 0
				end
				
				if UpgradeNeed > 0 then
					if UpgradeNeed == 0.25 then
						UpgradeCosts = 250
					elseif UpgradeNeed == 0.5 then
						UpgradeCosts = 500
					else
						UpgradeCosts = 750
						UpgradeNeed = 0.5
					end
					if UpgradeCosts < Budget then
						if f_SpendMoney("MyHarbour",UpgradeCosts,"Upgrades") then
							Budget = Budget - UpgradeCosts
							AddImpact("",ImpactType,UpgradeNeed,-1) -- 1 for none, 1.25 for light, 1.50 for medium, 2.00 for heavy
							if GetImpactValue("","UpgradedToday")==0 then
								AddImpact("","UpgradedToday",1,12)
							end
						end
					end	
				end
			end
		end
				
			
	--no dynasty ship	
	else
		
		if GetImpactValue("","ShipCannonMod") < (1 + Modifier) then
			if Modifier > 0.5 then
				Modifier = 0.5
			end
		
			AddImpact("","ShipCannonMod",Modifier,-1) -- 1 for none, 1.25 for light, 1.50 for medium, 2.00 for heavy
		end
		
		if GetImpactValue("","ShipHitpointMod") < (1 + Modifier) then
			if Modifier > 0.5 then
				Modifier = 0.5
			end
			AddImpact("","ShipHitpointMod",Modifier,-1) -- 1 for none, 1.25 for light, 1.50 for medium, 2.00 for heavy
		end
		
		
		if Modifier < 0.5 then
			Modifier = 0
		else
			Modifier = 0.5
		end
		if GetImpactValue("","ShipMenMod") < (1 + Modifier) then	
			AddImpact("","ShipMenMod",0.5,-1) -- 1 for normal, 1.50 for  cutlass, 2.00 for muskets
		end
	end
	
	if GetHPRelative("")<1 then
		if IsDynastyShip then
			if HasData("RestoreBudget") then
				Budget = Budget + GetData("RestoreBudget")
			end
			local CartType = CartGetType("")
			local RepairPrice = gameplayformulas_CalcCartRepairPrice(CartType, GetHPRelative(""))
			if RepairPrice > Budget then
				Sleep(1)
				if GetImpactValue("","FullOfLove")==0 then
					AddImpact("","FullOfLove",1,4)
				end
				return
			end
		end
		
		if not MeasureRun("",nil,"RepairCart",true) then
			StopMeasure()
		end
	end
end

