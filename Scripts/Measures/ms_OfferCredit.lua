function Run()

	if not GetInsideBuilding("", "BankBuilding") then
		MsgDebugMeasure("@L_MEASURE_OFFERCREDIT_FAIL_+0")
		StopMeasure()
	end
	
	if not BuildingGetOwner("BankBuilding","MyBoss") then
		MsgDebugMeasure("@L_MEASURE_OFFERCREDIT_FAIL_+0")
		StopMeasure()
	end

	if not HasProperty("BankBuilding","BankAccount") then
		MsgBoxNoWait("","BankBuilding","@L_OFFERCREDIT_ERROR_TIME_HEAD_+0","@L_OFFERCREDIT_ERROR_MONEY_BODY_+0")
		StopMeasure()
	end
	
	-- set the properties
	if not HasProperty("BankBuilding","OfferCreditNow") then
		SetProperty("BankBuilding", "OfferCreditWorker", GetID(""))
	end
	SetProperty("BankBuilding", "OfferCreditNow", 1)
	
	-- Only 1 employee can give out credits
	if HasProperty("BankBuilding", "OfferCreditWorker") then
		local OfferID = GetProperty("BankBuilding","OfferCreditWorker")
		if GetID("") ~= OfferID then
			MsgBoxNoWait("MyBoss","BankBuilding","@L_OFFERCREDIT_ERROR_TIME_HEAD_+0","@L_OFFERCREDIT_ERROR_EMPLOYEE_BODY_+0")
			StopMeasure()
		end
	end
	
	-- go to your place
	GetLocatorByName("BankBuilding","Work3","ChiefPos")
	f_BeginUseLocator("","ChiefPos",GL_STANCE_SIT,true)
	
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)

	while true do
		local CreditSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND (Object.HasProperty(WaitForCredit)))"
		local NumCreditSims = Find("", CreditSimFilter,"CreditSim", -1)
		if NumCreditSims <1 then
			-- Do some animation stuff
			if Rand(10) ==0 then
				CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				PlayAnimation("","sit_drink")
				CarryObject("","",false)
			end
			Sleep(5)
		else
			
			SetData("Blocked", 0)
			if not SendCommandNoWait("CreditSim0", "BlockMe") then
				break
			end
			
			if HasProperty("CreditSim0","IgnoreBank") then
				RemoveProperty("CreditSim0","IgnoreBank")
			end
			
			-- sit down at the table
			GetLocatorByName("BankBuilding","wait3","ClientSit")
			f_BeginUseLocator("CreditSim0","ClientSit",GL_STANCE_SIT,true)
			MeasureSetNotRestartable()
			SetState("",STATE_DUEL,true)
			-- Do some talking		
			local anim = { "sit_talk","sit_talk_02" }
			local dowhat = PlayAnimationNoWait("CreditSim0",anim[Rand(2)+1])
			MsgSay("CreditSim0","@L_MEASURE_IDLE_TAKECREDIT_SPRUCH")
					
			local Account = GetProperty("BankBuilding","BankAccount")
			-- Answer
			PlayAnimationNoWait("","sit_talk")
			if SimGetGender("") == 1 then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
			end	
			
			if Account >= 100 then
				PlayAnimationNoWait("","sit_yes")
				-- this line is only for the text
				local InterestText = 25+GetSkillValue("",BARGAINING)-- 25% + Skill 
				MsgSay("","@L_MEASURE_IDLE_TAKECREDIT_ANSWER_POSITIVE",InterestText)
				PlayAnimation("CreditSim0","sit_yes")
			else
				PlayAnimationNoWait("","sit_no")
				MsgSay("","@L_MEASURE_IDLE_TAKECREDIT_ANSWER_NEGATIVE")
				SetProperty("CreditSim0","IgnoreBank",GetID("BankBuilding"))
			end
			
			if HasProperty("CreditSim0", "WaitForCredit") then
				RemoveProperty("CreditSim0", "WaitForCredit")
			end			
					
			if Account>=100 then

				local MyRank = SimGetRank("CreditSim0")
				local CreditChoice = 0
				local Sum = 100
						
				if MyRank>=3 then
					CreditChoice = 2+Rand(4)
				else
					CreditChoice = Rand(2)
				end

				if IsDynastySim("CreditSim0") then
					CreditChoice = 4 + Rand(2)
				end
						
				if CreditChoice == 0 then
					Sum = 100
				elseif CreditChoice == 1 and Account >=200 then
					Sum = 200
				elseif CreditChoice == 2 and Account>=500 then
					Sum = 500
				elseif CreditChoice == 3 and Account >=1000 then
					Sum = 1000
				elseif CreditChoice == 4 and Account >=2000 then
					Sum = 2000
				elseif CreditChoice == 5 and Account >=5000 then
					Sum = 5000
				else
					Sum = 100
				end
				
				-- This line is for the actual interest
				local Interest = 0.25+(GetSkillValue("",BARGAINING)/100)-- 25% + Skill 
				
				-- This line is for the textmessage
				local InterestText = 25+GetSkillValue("",BARGAINING)-- 25% + Skill 
				
				-- Set the properties for the sim
				SetProperty("CreditSim0","CreditBank",GetID("BankBuilding"))
				SetProperty("CreditSim0","CreditSum",Sum)
				SetProperty("CreditSim0","CreditInterest",Interest)
				CreateScriptcall("OrderCredit_End",24,"Measures/ms_OrderCredit.lua","ReturnCredit","CreditSim0","MyBoss")
				
				if GetProperty("BankBuilding","MsgTake")==1 then
					MsgNewsNoWait("MyBoss","CreditSim0","","building",-1,"@L_MEASURE_OfferCredit_HEAD_+0","@L_MEASURE_OfferCredit_BODY_+0",GetID("CreditSim0"),GetID("BankBuilding"),Sum, InterestText)
				end
				
				MoveSetActivity("CreditSim0","")
				SetProperty("BankBuilding","BankAccount",(Account-Sum))
				f_CreditMoney("CreditSim0",Sum,"Bank")
				-- Satisfy the need
				SatisfyNeed("CreditSim0",9,1)
			end
			f_EndUseLocator("CreditSim0","ClientSit",GL_STANCE_STAND)
			SetData("Blocked",1)
			Sleep(8)
			SetState("",STATE_DUEL,false)
			SetState("CreditSim0",STATE_DUEL,false)
		end
	end
	StopMeasure()
end

function BlockMe()
	while GetData("Blocked")~=1 do
		Sleep(0.8)
		SetState("",STATE_DUEL,true)
	end
	if HasProperty("","WaitForCredit") then
		RemoveProperty("","WaitForCredit")
	end
	Sleep(1)
	f_ExitCurrentBuilding("")
	if GetState("", STATE_DUEL) then
		SetState("",STATE_DUEL,false)
	end
	SimResetBehavior("")
end

function CleanUp()
	
	SetData("Blocked",1)
	if GetInsideBuilding("", "BankBuilding") then
		if HasProperty("BankBuilding", "OfferCreditNow") then
			RemoveProperty("BankBuilding", "OfferCreditNow")
		end

		if HasProperty("BankBuilding" ,"OfferCreditWorker") then
			RemoveProperty("BankBuilding" ,"OfferCreditWorker")
		end
	end
	if AliasExists("CreditSim0") then
		if GetState("CreditSim0", STATE_DUEL) then
			SetState("CreditSim0",STATE_DUEL,false)
		end
	end
	SetState("",STATE_DUEL,false)
	StopAnimation("")
	CarryObject("","",false)
	CarryObject("","",true)
	MoveSetStance("",GL_STANCE_STAND)
	MoveSetActivity("","")
	f_EndUseLocator("","ChiefPos",GL_STANCE_STAND)
end
