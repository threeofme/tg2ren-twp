function Run()
	repeat
		-- check for missing title
		if GetNobilityTitle("") < 2 then
			SetNobilityTitle("", 2, true)
		end
	
		if GetImpactValue("", "banned")==1 then
			MeasureRun("", nil, "DynastyBanned")
			StopMeasure()
		end
	
		local	Value = Rand(80)
	
		if Value < 10 then
			idlelib_GoToRandomPosition()
		elseif Value < 20 then
			idlelib_SitDown()
		elseif Value < 30 then
			if DynastyIsShadow("") then
				idlelib_CheckInsideStore(Rand(2)+1)
			else
				idlelib_BuySomethingAtTheMarket(Rand(2)+1)
			end
		elseif Value < 40 then
			if Rand(2) == 0 then
				idlelib_BeADrunkChamp()
			else
				idlelib_BeADiceChamp()
			end
		elseif Value < 50 then
			idlelib_UseCocotte()
		elseif Value < 60 then
			idlelib_CollectWater()
		elseif Value < 70 then
			local need = 2
			if Rand(4) > 0 then
				need = 8
			end
			if SimGetClass("") == 4 then
				idlelib_GoToDivehouse()
			else
				if Rand(3) == 1 then
					idlelib_GoToDivehouse()
				else
					idlelib_GoToTavern(need)
				end
			end
		else
			idlelib_DoNothing()
		end
		Sleep(5)	
	-- will terminate right away for AI, continue until abort for players	
	until not IsGUIDriven()
end

