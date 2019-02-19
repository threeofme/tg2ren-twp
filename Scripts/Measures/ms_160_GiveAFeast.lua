function AIFunc()
	return Rand(4) 
end

function Run()
	local money = SimGetWealth("")
	if not GetHomeBuilding("","MyHome") then
		StopMeasure()
	end

	-- Essen & trinken bestellen
	local Res1 = MsgNews("","",
		"@B[1, @L_FEAST_1_PLAN_A_ORDERMENUE_+2]"..
		"@B[2, @L_FEAST_1_PLAN_A_ORDERMENUE_+3]"..
		"@B[3, @L_FEAST_1_PLAN_A_ORDERMENUE_+4]"..
		"@B[4, @L_FEAST_1_PLAN_A_ORDERMENUE_+5]"..
		"@B[5, @L_FEAST_1_PLAN_A_ORDERMENUE_+6]@P",
		ms_160_giveafeast_AIFunc,
		"politics",
		25,
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+0",
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+1", 
		money*0.005,
		money*0.004,
		money*0.003,
		money*0.002,
		money*0.001
		)
	if Res1 == "C" then
		StopMeasure()
	end

	local FoodLevel = 0 
	if Res1==1 then
		FoodLevel = 5		
	elseif Res1==2 then
		FoodLevel = 4		
	elseif Res1==3 then
		FoodLevel = 3		
	elseif Res1==4 then
		FoodLevel = 2		
	elseif Res1==5 then
		FoodLevel = 1		
	else
		return
	end		

	-- musiker bestellen
	local Res2 = MsgNews("","",
		"@B[1, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+1]"..
		"@B[2, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+2]"..
		"@B[3, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+3]"..
		"@B[4, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+4]@P",
		ms_160_giveafeast_AIFunc,
		"politics",
		25,
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+0",
		"@L_FEAST_1_PLAN_B_ORDERMUSICIANS_+0",
		money*0.02,
		money*0.015,
		money*0.01,
		money*0.005
		)
	if Res2 == "C" then
		StopMeasure()
	end

	local MusicLevel = 0 
	if Res2==1 then			--Die berühmten >Mittelländer Troubadoure<
		MusicLevel = 4		
	elseif Res2==2 then		--Den bekannten Barden >Willem Hamshakes<
		MusicLevel = 3		
	elseif Res2==3 then		--Eine Truppe Flötisten aus den Anden
		MusicLevel = 2		
	elseif Res2==4 then		--Die berüchtigten >Fürchterlichen Volksmusikanten<
		MusicLevel = 1		
	else
		return
	end		
	local PriceForInvite = FoodLevel*money*0.001
	local PriceForFeast = MusicLevel*money*0.005
	-- zusammenfassung: und ja/nein
	local Res3 = MsgNews("","",
		"@B[1, @L_FEAST_1_PLAN_BTN_+0]@B[2, @L_FEAST_1_PLAN_BTN_+1]@P",
		ms_160_giveafeast_AIFunc,
		"politics",
		25,
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+0",
		"_FEAST_1_PLAN_C_DATE_+0",
		PriceForFeast,
		PriceForInvite
		)
	
	if Res3 == 2 or Res3 == "C" then
		StopMeasure()
	end
	
	if not f_SpendMoney("",PriceForFeast ,"CostSocial") then
		
		StopMeasure()
	end
	
	SetState("MyHome",STATE_FEAST,true)
	SetProperty("","Host")
	SetProperty("MyHome","InvitationsLeft",6)
	SetProperty("MyHome","CanInvite",1)
	SetProperty("MyHome","MusicLevel",MusicLevel)
	SetProperty("MyHome","FoodLevel",FoodLevel)
	SetProperty("MyHome","BaseMoney",money)
	SetProperty("MyHome","PriceForInvite",PriceForInvite)
	
	StopMeasure()
end

function CallToFeast()
	if not GetHomeBuilding("","PartyLocation") then
		StopMeasure()
	end
	if not BuildingHasUpgrade("PartyLocation",531) then	--salon
		StopMeasure()
	end
	if not MeasureRun("","PartyLocation","AttendFestivity") then
		StopMeasure()
	end
end

function CleanUp()
end

