function Run()
	
	CopyAlias("","Bank")
	BuildingGetOwner("","BankChief")

	local cash = GetMoney("BankChief")
	cash = math.floor(cash)
	if BuildingGetAISetting("Bank", "Produce_Selection")<0 then
		if cash < 100 and not HasProperty("Bank","BankAccount") then
			MsgBoxNoWait("BankChief","","@L_OFFERCREDIT_ERROR_TIME_HEAD_+0","@L_MEASURE_ORDERCREDIT_FAIL_+0")
			StopMeasure()
		end
	else
		if cash < 100 and not HasProperty("Bank","BankAccount") then
			StopMeasure()
		end
	end
	
	-- properties for messages
	if not HasProperty("Bank","MsgTake") then 
		SetProperty("Bank","MsgTake",1)
		SetProperty("Bank","MsgReturn",1)
		SetProperty("Bank","MsgKeep",1)
		SetProperty("Bank","MsgCollect",1)
	end

	local MinMoney = 0
	local MedMoney = 0
	local BigMoney = 0
	
	if cash >= 10000 then
		MinMoney = 2500
		MedMoney = 5000
		BigMoney = 10000
	elseif cash >= 5000  then
		MinMoney = 1000
		MedMoney = 2500
		BigMoney = 5000
	elseif cash >= 2000 then
		MinMoney = 500
		MedMoney = 1000
		BigMoney = 2000
	elseif cash >= 1000 then
		MinMoney = 300
		MedMoney = 500
		BigMoney = 1000
	elseif cash >= 500 then
		MinMoney = 200
		MedMoney = 300
		BigMoney = 500
	elseif cash >= 250 then
		MinMoney = 150
		MedMoney = 200
		BigMoney = 250	
	elseif cash >= 100 then
		MinMoney = 100
		MedMoney = 100
		BigMoney = 100
	end
		
	local kreditR
	local xtra = ""
	local xtrb = ""
	local Account = 0	
	
	if HasProperty("Bank","BankAccount") then
		xtra = "@B[4,@L_MEASURE_ORDERCREDIT_STUFF_+3]@B[5,@L_MEASURE_ORDERCREDIT_STUFF_+5]@B[7,@L_MEASURE_ORDERCREDIT_STUFF_+6]@B[8,@L_MEASURE_ORDERCREDIT_STUFF_+7]"
		xtrb = "@L_MEASURE_ORDERCREDIT_BODY_+1"
		Account = GetProperty("Bank","BankAccount")
	else
		xtrb = "@L_MEASURE_ORDERCREDIT_BODY_+0"
		Account = 0
	end

	local SimAlias
	local TakeLoanSimCount = 0
	local StolenLoanSimCount = 0
	local RentMoney = 0
	local BankName = GetID("")
	local GBankMoney = 0
	local GStolenMoney = 0
	local TotalSimCount = ScenarioGetObjects("cl_Sim", 9999, "SimAr")
	for i=0, TotalSimCount-1 do
		SimAlias = "SimAr"..i
		local GBankName = GetProperty(SimAlias, "CreditBank")
		if BankName == GBankName then
			if HasProperty(SimAlias, "CreditSum") then
				TakeLoanSimCount = TakeLoanSimCount + 1
				GBankMoney = GetProperty(SimAlias, "CreditSum")
			elseif HasProperty(SimAlias, "StolenSum") then
				StolenLoanSimCount = StolenLoanSimCount +1
				GStolenMoney=GetProperty(SimAlias, "StolenSum")
			end
			RentMoney = RentMoney + GBankMoney + GStolenMoney
		end
	end

	local layCred = ""
	layCred = layCred.."@B[1,@L_MEASURE_ORDERCREDIT_STUFF_+0]"
	layCred = layCred.."@B[2,@L_MEASURE_ORDERCREDIT_STUFF_+1]"
	layCred = layCred.."@B[3,@L_MEASURE_ORDERCREDIT_STUFF_+2]"
	
	if not IsStateDriven() then
	
		kreditR = MsgNews(
			"",
			"",
			"@P"..layCred..xtra.."@B[6,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
			ms_ordercredit_aidecide,
			"intrigue",
			-1,
			"@L_MEASURE_ORDERCREDIT_HEAD_+0",
			xtrb,
			MinMoney, MedMoney, BigMoney, Account, TakeLoanSimCount, RentMoney, StolenLoanSimCount)
	else
		kreditR = ms_ordercredit_aidecide()
	end
	
	if kreditR=="C" then
		StopMeasure()
	end	

	local invest = 0
	if kreditR == 1 then
		invest = MinMoney
	elseif kreditR == 2 then
		invest = MedMoney
	elseif kreditR == 3 then
		invest = BigMoney
	elseif kreditR == 4 then
		-- payout
		invest = GetProperty("Bank","BankAccount")
		local SmallPayout = math.floor(invest*0.2)
		local MediumPayout = math.floor(invest*0.5)
		local FullPayout = invest
		local Payout
		if not IsStateDriven() then
			Payout = MsgNews("","","@P"..
								"@B[0,"..SmallPayout.."]"..
								"@B[1,"..MediumPayout.."]"..
								"@B[2,"..FullPayout.."]"..
								"@B[3,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
								ms_ordercredit_Payout,
								"production",-1,"@L_MEASURE_ORDERCREDIT_PAYOUT_HEAD_+0",
								"@L_MEASURE_ORDERCREDIT_PAYOUT_BODY_+0")
		else
			Payout = ms_ordercredit_Payout()
		end
		if Payout == 0 then
			f_CreditMoney("BankChief",SmallPayout,"Credit")
			SetProperty("Bank","BankAccount",(invest-SmallPayout))
		elseif Payout == 1 then
			f_CreditMoney("BankChief",MediumPayout,"Credit")
			SetProperty("Bank","BankAccount",(invest-MediumPayout))
		elseif Payout == 2 then
			f_CreditMoney("BankChief",FullPayout,"Credit")
			SetProperty("Bank","BankAccount",0)
		end
		StopMeasure()
		
	elseif kreditR == 5 then
		invest = GetProperty("Bank","BankAccount")
		f_CreditMoney("BankChief",invest,"Credit")
		RemoveProperty("Bank","BankAccount")
		StopMeasure()
	elseif kreditR == 6 or kreditR == "C" then
		-- close
		StopMeasure()
	elseif kreditR == 7 then
		-- messages
		local MsgTake = GetProperty("Bank","MsgTake")
		local MsgReturn = GetProperty("Bank","MsgReturn")
		local MsgKeep = GetProperty("Bank","MsgKeep")
		local MsgCollect = GetProperty("Bank","MsgCollect")
		local MsgTakeLabel, MsgReturnLabel, MsgKeepLabel, MsgCollectLabel
		
		if MsgTake == 1 then
			MsgTakeLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_ON_+0"
		else
			MsgTakeLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_OFF_+0"
		end
		
		if MsgReturn == 1 then
			MsgReturnLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_ON_+0"
		else
			MsgReturnLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_OFF_+0"
		end
		
		if MsgKeep == 1 then
			MsgKeepLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_ON_+0"
		else
			MsgKeepLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_OFF_+0"
		end
		
		if MsgCollect == 1 then
			MsgCollectLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_ON_+0"
		else
			MsgCollectLabel = "@L_MEASURE_ORDERCREDIT_MESSAGES_OFF_+0"
		end
		
		local Messages = MsgNews("","","@P"..
							"@B[0,@L_MEASURE_ORDERCREDIT_MESSAGES_BUTTON_+0]"..
							"@B[1,@L_MEASURE_ORDERCREDIT_MESSAGES_BUTTON_+1]"..
							"@B[2,@L_MEASURE_ORDERCREDIT_MESSAGES_BUTTON_+2]"..
							"@B[3,@L_MEASURE_ORDERCREDIT_MESSAGES_BUTTON_+3]"..
							"@B[4,@L_MEASURE_ORDERCREDIT_MESSAGES_BUTTON_+4]"..
							"@B[5,@L_MEASURE_ORDERCREDIT_MESSAGES_BUTTON_+5]"..
							"@B[6,@L_MEASURE_ORDERCREDIT_STUFF_+4]",0,"intrigue",-1,
							"_MEASURE_ORDERCREDIT_MESSAGES_HEAD_+0",
							"_MEASURE_ORDERCREDIT_MESSAGES_BODY_+0",
							MsgTakeLabel, MsgReturnLabel, MsgKeepLabel, MsgCollectLabel)
		
		-- switch it
		if Messages == 0 then
			if MsgTake == 1 then
				SetProperty("Bank","MsgTake",0)
			else
				SetProperty("Bank","MsgTake",1)
			end
			StopMeasure()
		
		elseif Messages == 1 then
			if MsgReturn == 1 then
				SetProperty("Bank","MsgReturn",0)
			else
				SetProperty("Bank","MsgReturn",1)
			end
			StopMeasure()
		
		elseif Messages == 2 then
			if MsgKeep == 1 then
				SetProperty("Bank","MsgKeep",0)
			else
				SetProperty("Bank","MsgKeep",1)
			end
			StopMeasure()
		
		elseif Messages == 3 then
			if MsgCollect == 1 then
				SetProperty("Bank","MsgCollect",0)
			else
				SetProperty("Bank","MsgCollect",1)
			end
			StopMeasure()
			
		elseif Messages == 4 then
			SetProperty("Bank","MsgTake",0)
			SetProperty("Bank","MsgReturn",0)
			SetProperty("Bank","MsgKeep",0)
			SetProperty("Bank","MsgCollect",0)
			StopMeasure()
		elseif Messages == 5 then
			SetProperty("Bank","MsgTake",1)
			SetProperty("Bank","MsgReturn",1)
			SetProperty("Bank","MsgKeep",1)
			SetProperty("Bank","MsgCollect",1)
			StopMeasure()
		elseif Messages == 6 or Messages == "C" then
			StopMeasure()
		end
		StopMeasure()
	elseif kreditR == 8 then
		-- balance
		local BalanceReturnCount = 0
		if HasProperty("Bank","BalanceReturnCount") then
			BalanceReturnCount = GetProperty("Bank","BalanceReturnCount")
		end
		
		local BalanceReturn = 0
		if HasProperty("Bank","BalanceReturn") then
			BalanceReturn = GetProperty("Bank","BalanceReturn")
		end
		
		local BalanceReturnCollect = 0
		if HasProperty("Bank","BalanceReturnCollect") then
			BalanceReturnCollect = GetProperty("Bank","BalanceReturnCollect")
		end
		
		local BalanceReturnFactor = 0
		if BalanceReturnCount >0 then
			BalanceReturnFactor = BalanceReturn/BalanceReturnCount
		end
			MsgBox("","","","@L_MEASURE_ORDERCREDIT_BALANCE_HEAD_+0",
					"@L_MEASURE_ORDERCREDIT_BALANCE_BODY_+0", BalanceReturnCount,
					BalanceReturn,BalanceReturnCollect,BalanceReturnFactor)
	end
		
	
	if invest > 0 then
		f_SpendMoney("BankChief",invest,"Credit")

		if HasProperty("Bank","BankAccount") then
			local habKonto = GetProperty("Bank","BankAccount")
			invest = invest + habKonto
		end

		SetProperty("Bank","BankAccount",invest)
	end

	StopMeasure()
end

function Payout()
	-- AI always chooses medium payout
	return 1 
end

function ReturnCredit()
	
	local Choice = 25
	local ReturnBank = 0
	if not HasProperty("","CreditBank") then
		StopMeasure()
	else
		ReturnBank = GetProperty("","CreditBank")
	end
	
	if not GetAliasByID(ReturnBank, "Bank") then
		StopMeasure()
	end
	
	local CreditSum = GetProperty("","CreditSum")
	local Interest = GetProperty("","CreditInterest")
	local ReturnCredit = math.floor(CreditSum*(1+Interest))
	local Plus = ReturnCredit - CreditSum
	local ReturnTime = 24
	if HasProperty("","ReturnTime") then
		ReturnTime = GetProperty("","ReturnTime")
	end

	if not AliasExists("Bank") then
		return
	end

	local Account = GetProperty("Bank","BankAccount")
	local MyMoney = GetMoney("")
	if not BuildingGetOwner("Bank","MyBoss") then
		StopMeasure()
	end
	local BalanceReturnCount = 0
	if HasProperty("Bank","BalanceReturnCount") then
		BalanceReturnCount = GetProperty("Bank","BalanceReturnCount")
	end
	local BalanceReturn = 0
	if HasProperty("Bank","BalanceReturn") then
		BalanceReturn = GetProperty("Bank","BalanceReturn")
	end
	
	-- deactivate hunt for debts for AI buildings cause its bugged somehow
	if BuildingGetAISetting("Bank", "Produce_Selection")>0 or DynastyIsAI("MyBoss") then
		Choice = 0
	end
	
	if Rand(100)>=Choice then
		-- Return
		RemoveProperty("","CreditBank")
		RemoveProperty("","CreditSum")
		RemoveProperty("","CreditInterest")
		
		if HasProperty("","OldSum") then
			RemoveProperty("","OldSum")
		end
		
		if HasProperty("","ReturnTime") then
			RemoveProperty("","ReturnTime")
		end
		
		if IsDynastySim("") then
			f_SpendMoney("",ReturnCredit,"Credit")
		end
		
		SetProperty("Bank","BankAccount",(Account+CreditSum))
		SetProperty("Bank","BalanceReturnCount",(BalanceReturnCount+1))
		SetProperty("Bank","BalanceReturn", (BalanceReturn+Plus))
		-- TODO is the money not returned to players if AI controlled?
		f_CreditMoney("MyBoss",Plus,"Credit")
		economy_UpdateBalance("Bank", "Service", Plus)
		
		local ExtraMsg = "@L_MEASURE_IDLE_RETURNCREDIT_SPRUCH"
		if GetProperty("Bank","MsgReturn")==1 then
			MsgNewsNoWait("MyBoss","","","building",-1,"@L_MEASURE_OfferCredit_HEAD_+1",
					"@L_MEASURE_OfferCredit_BODY_+1",GetID(""),GetID("Bank"),CreditSum,ReturnCredit,ReturnTime, ExtraMsg)
		end
	else
		-- Keep it, haha!
		if GetProperty("Bank","MsgKeep")==1 then
			MsgNewsNoWait("MyBoss","","","intrigue",-1,"@L_MEASURE_OfferCredit_KEEPIT_HEAD_+0",
					"@L_MEASURE_OfferCredit_KEEPIT_BODY_+0",GetID(""),GetID("Bank"),CreditSum,ReturnCredit)
		end
		SetProperty("","OldSum", CreditSum)
		SetProperty("","StolenSum",ReturnCredit)
		if HasProperty("Bank","StolenCount") then
			local StolenCount = GetProperty("Bank","StolenCount")
			SetProperty("Bank","StolenCount",(StolenCount+1))
		else
			SetProperty("Bank","StolenCount",1)
		end
		RemoveProperty("","CreditSum")
	end
	
	StopMeasure()
	
end

function aidecide()
	BuildingGetOwner("Bank", "BankChief")
	-- only player should manage the credit account
	if DynastyIsPlayer("BankChief") then 
		return "C"
	end

	local cash = GetMoney("BankChief")

	local DecideValue

	if not HasProperty("Bank","BankAccount") then
		if cash > 10000 then
			DecideValue = 3
		elseif cash > 5000 then
			DecideValue = 2+Rand(2)
		else
			DecideValue = 1+Rand(2)
		end
	else
		local Lmoney = GetProperty("Bank","BankAccount")
		DecideValue = "C"
		if Lmoney < 10000 then
			if cash >= 2000 and cash > (Lmoney+1000) then
				DecideValue = 1+Rand(3)
			elseif cash <500 or Lmoney > (cash+1000) then
				DecideValue = 4
			end
		end
	end
	return DecideValue
end

function CleanUp()
	if AliasExists("Actor") then
		if HasProperty("Actor", "SpecialMeasureDestination") then
			RemoveProperty("Actor", "SpecialMeasureDestination")
		end
		if HasProperty("Actor", "SpecialMeasureId") then
			RemoveProperty("Actor", "SpecialMeasureId")
		end
		if HasProperty("Actor", "AIDecideNow") then
			RemoveProperty("Actor", "AIDecideNow")
		end
		RemoveAlias("Actor")
	end
end
