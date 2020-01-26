-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_MedicalTreatment"
----
----	with this measure, the player can assign a sim to treat sick sims in hospital
----
-------------------------------------------------------------------------------
function Run()

	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_HOSPITAL, "Hospital") then
		StopMeasure()
	end
	
	if GetInsideBuildingID("") ~= GetID("Hospital") then
		if not f_MoveTo("", "Hospital", GL_MOVESPEED_RUN) then
			return
		end
	end
	
	if BuildingGetAISetting("Hospital", "Produce_Selection")>0 then
		if bld_CalcTreatmentNeed("Hospital", "") < 0 then
			StopMeasure()
		end
	end
	
	local BedFree = false
	local BedNumber = 0
	local MyID = GetID("")
	
	-- check property instead of locator
	for i=1,5 do
		if HasProperty("Hospital","Locator"..i) then
			if GetProperty("Hospital","Locator"..i)==MyID then
				BedFree = true
				BedNumber = i
				SetData("BedNumber",i)
				break
			end
		else
			SetProperty("Hospital","Locator"..i,MyID)
			BedFree = true
			BedNumber = i
			SetData("BedNumber",i)
			break
		end
	end
	
	if not BedFree then
		StopMeasure()
	end
	
	-- go to your place
	
	GetLocatorByName("Hospital","Treatment"..BedNumber,"TreatmentPos")
	if not f_BeginUseLocator("","TreatmentPos",GL_STANCE_STAND,true) then
		return
	end
	
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
	
	while true do
		local SickSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND (Object.HasProperty(WaitingForTreatment)))"
		local NumSickSims = Find("", SickSimFilter,"SickSim", -1)
		if NumSickSims < 1 then
			-- bored
			MoveStop("")
			PlayAnimation("","cogitate")
			
			-- AI stops measure if no patients are available to do better things
			if BuildingGetAISetting("Hospital", "Produce_Selection") >0 then
				if BuildingGetProducerCount("Hospital", PT_MEASURE, "MedicalTreatment") > 1 then
					SimSetProduceItemID("", -1, -1)
					StopMeasure()
				end
			end
		else
			
			-- maybe too many healer assigned?
			if BuildingGetAISetting("Hospital", "Produce_Selection")>0 then
				if bld_CalcTreatmentNeed("Hospital", "") < 0 then
					SimSetProduceItemID("", -1, -1)
					StopMeasure()
				end
			end
			
			-- block the patient
			if not AliasExists("SickSim0") then
				return
			end

			SetData("Blocked", 0)
			if not SendCommandNoWait("SickSim0", "BlockMe") then
				break
			end
			
			-- Patient moves
			Sleep(0.5)
			if not f_MoveTo("SickSim0","Owner",GL_MOVESPEED_WALK,128) then
				return
			end
			AlignTo("SickSim0","")
			AlignTo("","SickSim0")
			
			Sleep(1)
			MeasureSetNotRestartable()
			SetState("",STATE_DUEL,true) -- no measure cancel
			
			MsgSay("SickSim0","@L_MEDICUS_TREATMENT_PATIENT")
			MsgSay("","@L_MEDICUS_TREATMENT_DOC_INTRO")
			PlayAnimation("","manipulate_middle_twohand")
			local Costs = 50
			local Cured = false
			local Disease = false
			local Medicine, Label
			local FavorMod
			
			--SPRAIN
			if GetImpactValue("SickSim0","Sprain")==1 then
				Disease = "Sprain"
				Medicine = "Bandage"
				FavorMod = 5
				Label = "SPRAIN"
			--COLD	
			elseif GetImpactValue("SickSim0","Cold")==1 then
				Disease = "Cold"
				Medicine = "Bandage"
				FavorMod = 5
				Label = "COLD"
			--INFLUENZA
			elseif GetImpactValue("SickSim0","Influenza")==1 then
				Disease = "Influenza"
				Medicine = "Medicine"
				FavorMod = 5
				Label = "INFLUENZA"
			--FRACTURE
			elseif GetImpactValue("SickSim0","Fracture")==1 then
				Disease = "Fracture"
				Medicine = "PainKiller"
				FavorMod = 10
				Label = "FRACTURE"
			--BURNWOUND	
			elseif GetImpactValue("SickSim0","BurnWound")==1 then
				Disease = "BurnWound"
				Medicine = "Salve"
				FavorMod = 10
				Label = "BURNWOUND"
			--POX	
			elseif GetImpactValue("SickSim0","Pox")==1 then
				Disease = "Pox"
				Medicine = "Medicine"
				FavorMod = 10
				Label = "POX"
			--CARIES					
			elseif GetImpactValue("SickSim0","Caries")==1 then
				Disease = "Caries"
				Medicine = "PainKiller"
				FavorMod = 10
				Label = "CARIES"
			--PNEUMONIA
			elseif GetImpactValue("SickSim0","Pneumonia")==1 then
				Disease = "Pneumonia"
				Medicine = "PainKiller"
				FavorMod = 15
				Label = "PNEUMONIA"
			--BLACKDEATH
			elseif GetImpactValue("SickSim0","Blackdeath")==1 then
				Disease = "Blackdeath"
				Medicine = "PainKiller"
				FavorMod = 15
				Label = "BLACKDEATH"
			--ELSE (HP LOSS)
			elseif (GetHP("SickSim0") < GetMaxHP("SickSim0")) then
				Medicine = "Salve"
				FavorMod = 5
				Label = "HPLOSS"
			-- NOTHING
			else
				MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOTHING")
				Cured = true
				SimResetBehavior("SickSim0")
				RemoveProperty("SickSim0","WaitingForTreatment")
			end
			
			if Cured == false then
				-- TREATMENT
				if Disease == false then -- special case HP LOSS
					Costs = GetMaxHP("SickSim0") - GetHP("SickSim0") + 100
				else
					Costs = diseases_GetTreatmentCost(Disease)
				end
				
				local NumOfMeds = 0
				local MedicineId = ItemGetID(Medicine) 
				local MedicineInSalescounter = GetProperty("Hospital", "Salescounter_"..MedicineId) or 0
				
				local CanHeal
				if GetItemCount("Hospital",Medicine,INVENTORY_STD) > 0 then
					CanHeal = 1
				elseif MedicineInSalescounter > 0 then
					CanHeal = 2
				end
				GetDynasty("SickSim0", "SickDyn")
				local MustPay = AliasExists("SickDyn") and GetDynastyID("Hospital") ~= GetDynastyID("SickDyn")
				
				if CanHeal then
					-- only Players need to pay
					if MustPay and not f_SpendMoney("SickSim0", Costs, "Offering") then
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					else
						-- remove medicine
						if CanHeal == 1 then
							RemoveItems("Hospital",Medicine,1,INVENTORY_STD)
						elseif CanHeal == 2 then
							local Current = GetProperty("Hospital", "Salescounter_"..MedicineId) or 0
							SetProperty("Hospital","Salescounter_"..MedicineId,(Current - 1))
						end
						
						f_CreditMoney("Hospital",Costs,"Offering")
						economy_UpdateBalance("Hospital", "Service", Costs)
						
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_"..Label)
						
						if Disease == "Sprain" then
							diseases_Sprain("SickSim0",false)
						elseif Disease == "Cold" then
							diseases_Cold("SickSim0",false)
						elseif Disease == "Influenza" then
							diseases_Influenza("SickSim0",false)
						elseif Disease == "Fracture" then
							ms_medicaltreatment_LayToBed("","SickSim0",BedNumber)
							diseases_Fracture("SickSim0",false)
						elseif Disease == "BurnWound" then
							ms_medicaltreatment_LayToBed("","SickSim0",BedNumber)
							diseases_BurnWound("SickSim0",false)
						elseif Disease == "Pox" then
							ms_medicaltreatment_LayToBed("","SickSim0",BedNumber)
							diseases_Pox("SickSim0",false)
						elseif Disease == "Caries" then
							diseases_Caries("SickSim0", false)
						elseif Disease == "Pneumonia" then
							ms_medicaltreatment_LayToBed("","SickSim0",BedNumber)
							diseases_Pneumonia("SickSim0", false)
						elseif Disease == "Blackdeath" then
							ms_medicaltreatment_LayToBed("","SickSim0",BedNumber)
							diseases_Blackdeath("SickSim0",false)
							-- 120 hours immunity to stop black death
							AddImpact("SickSim0","PlagueImmunity",1,120)
						else
							local ToHeal = GetMaxHP("SickSim0") - GetHP("SickSim0")
							ModifyHP("SickSim0",ToHeal,true)
						end
					
						if HasData("LayStill") then
							RemoveData("LayStill")
						end
						
						-- modify the favor to the boss
						if BuildingGetOwner("Hospital","MyBoss") then
							chr_ModifyFavor("SickSim0","MyBoss",FavorMod)
						end
						Cured = true
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel(Medicine,false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
									"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
									GetID("Hospital"),ItemGetLabel(Medicine,false))
					end
				end
			end

			if not Cured then
			 	-- search for another hospital
			 	SetProperty("SickSim0", "IgnoreHospital", GetID("Hospital"))
			 	SetProperty("SickSim0", "IgnoreHospitalTime", GetGametime()+12)
			else
				MoveSetActivity("SickSim0","")
				if ImpactGetMaxTimeleft("SickSim0","Resist")<4 then
					AddImpact("SickSim0","Resist",1,4) -- def 6
				end
				-- Try to sell soap
				local SoapId = ItemGetID("Soap") 
				local SoapCount = GetProperty("Hospital","Salescounter_"..SoapId) or 0
				
				if SoapCount > 0 then
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_BUYSOAP")
					local Skill = GetSkillValue("",7) -- Rhetoric
					local RandomFactor1 = Rand(3)
					local RandomFactor2 = Rand(3)
					local SkillPatient = GetSkillValue("SickSim0",8) -- Empathy
					
					if (Skill+RandomFactor1)>=(SkillPatient+RandomFactor2) then
						local ItemCount, SoapValue = economy_BuyItems("Hospital", "SickSim0", SoapId, 1)
						if ItemCount > 0 then
							-- TODO replace hospital balance with default balance sheet
							-- for the balance
							local SoapIncome = 0
							if HasProperty("Hospital", "SoapIncome") then
								SoapIncome = GetProperty("Hospital","SoapIncome")
							end
									
							local TotalIncome = 0
							if HasProperty("Hospital", "TotalIncome") then
								TotalIncome = GetProperty("Hospital","TotalIncome")
							end
							local RoundIncome = 0
							if HasProperty("Hospital", "RoundIncome") then
								RoundIncome = GetProperty("Hospital","RoundIncome")
							end
										
							SetProperty("Hospital", "TotalIncome",(TotalIncome+SoapValue))
							SetProperty("Hospital", "RoundIncome",(RoundIncome+SoapValue))
							SetProperty("Hospital", "SoapIncome",(SoapIncome+SoapValue))
						end
								
						if ImpactGetMaxTimeleft("SickSim0","Resist")<6 then
							AddImpact("SickSim0","Resist",1,6)
						end
						AddImpact("SickSim0","Soap",1,6)
						Sleep(1)
						PlayAnimationNoWait("SickSim0","nod")
						MsgSay("SickSim0","@L_MEDICUS_TREATMENT_PATIENT_BUYSOAP")
					else
						Sleep(1)
						PlayAnimationNoWait("SickSim0","shake_head")
						MsgSay("SickSim0","@L_MEDICUS_TREATMENT_PATIENT_NOSOAP")
					end
				end
				if HasProperty("SickSim0","WaitingForTreatment") then
					RemoveProperty("SickSim0","WaitingForTreatment")
				end
			end
			SetData("Blocked", 1)
			Sleep(2)
			SetState("",STATE_DUEL,false)
		end
	end
	StopMeasure()
end

function BlockMe()
	while GetData("Blocked")~=1 do
		Sleep(1)
		if not GetState("", STATE_DUEL) then
			SetState("", STATE_DUEL, true)
		end
	end
	
	if HasProperty("","WaitingForTreatment") then
		RemoveProperty("","WaitingForTreatment")
	end
	
	SetState("",STATE_DUEL,false)
	CreateScriptcall("SendHome", 0.001, "Measures/ms_MedicalTreatment.lua", "LeaveBuilding", "")
	return
end

function LeaveBuilding()
	f_ExitCurrentBuilding("")
	if DynastyIsAI("") then
		if Rand(2) == 0 then
			f_Stroll("", 1000, 6)
		else
			idlelib_GoHome()
		end
	end
end

function LayToBed(Doc,SickSim,BedNumber)
	GetLocatorByName("Hospital","Bed"..BedNumber,"BedPos")
	if not f_BeginUseLocator(SickSim,"BedPos",GL_STANCE_LAY,true) then
		return
	end
	
	if not f_BeginUseLocator(Doc,"TreatmentPos",GL_STANCE_STAND,true) then
		return
	end
	Sleep(0.5)
	SetData("LayStill",1)
	
	if not SendCommandNoWait(SickSim,"LayBack") then
		return
	end

	AlignTo(Doc,SickSim)
	Sleep(0.5)
	PlayAnimation(Doc,"treatpatientinbed_01")
	Sleep(0.5)
	f_EndUseLocator(Doc,"TreatmentPos",GL_STANCE_STAND)
	Sleep(0.5)
end

function LayBack()
	PlayAnimation("","sickinbed_idle_in")
	while HasData("LayStill") do
		LoopAnimation("","sickinbed_idle_01",2)
	end
	PlayAnimationNoWait("","sickinbed_idle_out")
	f_EndUseLocator("","BedPos",GL_STANCE_STAND)
end

function CleanUp()
	SetData("Blocked",1)
	if HasData("BedNumber") then
		RemoveProperty("Hospital","Locator"..(GetData("BedNumber")))
		RemoveData("BedNumber")
	end
	RemoveData("LayStill")
	StopAnimation("")
	f_EndUseLocator("","TreatmentPos",GL_STANCE_STAND)
	
	if HasProperty("","Bored") then
		RemoveProperty("","Bored")
	end
	
	if HasProperty("", "BigBrother") then
		RemoveProperty("","BigBrother")
	end
	
	SetState("",STATE_DUEL,false)
	
	if AliasExists("SickSim0") then
		SetState("SickSim0",STATE_DUEL,false)
	end
end

