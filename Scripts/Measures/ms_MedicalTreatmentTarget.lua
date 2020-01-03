-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_MedicalTreatmentTarget"
----
----	EN: with this measure, the player can assign a doctor (party member or employee) to treat a specific sick sim in hospital
----	 // DE: mit dieser Maßnahme kann der Spieler einen Doktor (Gruppenmitglied oder Angestellter) anweisen, eine bestimmte Person im Hospital zu behandeln
----
----	>> unofficial mod by Manc (yet unexperienced in modding, suggestions welcome)
----
----	This script is basicly identical to MedicalTreatment.lua, but has no loop and is no production measure.
-------------------------------------------------------------------------------

function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end

	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_HOSPITAL, "Hospital") then
		StopMeasure()
	end
	
	if GetInsideBuildingID("") ~= GetID("Hospital") then
		if not f_MoveTo("", "Hospital", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	end
	
	if not GetInsideBuilding("Destination","Place") then
		StopMeasure()
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
	
	-- block the patient
	SetData("Blocked", 0)
	if not SendCommandNoWait("Destination", "BlockMe") then
		return
	end
			
	-- Patient moves
	Sleep(0.5)
	if not f_MoveTo("Destination", "", GL_MOVESPEED_WALK, 128) then
		return
	end
	AlignTo("Destination","")
	AlignTo("","Destination")
			
	Sleep(1)
	MeasureSetNotRestartable()
	SetState("", STATE_DUEL, true) -- no measure cancel

	MsgSay("Destination","@L_MEDICUS_TREATMENT_PATIENT")
	MsgSay("","@L_MEDICUS_TREATMENT_DOC_INTRO")
	PlayAnimation("","manipulate_middle_twohand")

	local Costs = 50
	local Cured = false
	local Disease = false
	local CanHeal = false
	local Medicine, Label
	local FavorMod
			
	--SPRAIN
	if GetImpactValue("Destination","Sprain")==1 then
		Disease = "Sprain"
		Medicine = "Bandage"
		FavorMod = 5
		Label = "SPRAIN"
	--COLD	
	elseif GetImpactValue("Destination","Cold")==1 then
		Disease = "Cold"
		Medicine = "Bandage"
		FavorMod = 5
		Label = "COLD"
	--INFLUENZA
	elseif GetImpactValue("Destination","Influenza")==1 then
		Disease = "Influenza"
		Medicine = "Medicine"
		FavorMod = 5
		Label = "INFLUENZA"
	--FRACTURE
	elseif GetImpactValue("Destination","Fracture")==1 then
		Disease = "Fracture"
		Medicine = "PainKiller"
		FavorMod = 10
		Label = "FRACTURE"
	--BURNWOUND	
	elseif GetImpactValue("Destination","BurnWound")==1 then
		Disease = "BurnWound"
		Medicine = "Salve"
		FavorMod = 10
		Label = "BURNWOUND"
	--POX	
	elseif GetImpactValue("Destination","Pox")==1 then
		Disease = "Pox"
		Medicine = "Medicine"
		FavorMod = 10
		Label = "POX"
	--CARIES					
	elseif GetImpactValue("Destination","Caries")==1 then
		Disease = "Caries"
		Medicine = "PainKiller"
		FavorMod = 10
		Label = "CARIES"
	--PNEUMONIA
	elseif GetImpactValue("Destination","Pneumonia")==1 then
		Disease = "Pneumonia"
		Medicine = "PainKiller"
		FavorMod = 15
		Label = "PNEUMONIA"
	--BLACKDEATH
	elseif GetImpactValue("Destination","Blackdeath")==1 then
		Disease = "Blackdeath"
		Medicine = "PainKiller"
		FavorMod = 15
		Label = "BLACKDEATH"
	--ELSE (HP LOSS)
	elseif (GetHP("Destination") < GetMaxHP("Destination")) then
		Medicine = "Salve"
		FavorMod = 5
		Label = "HPLOSS"
	-- NOTHING
	else
		MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOTHING")
		Cured = true
		SimResetBehavior("Destination")
		RemoveProperty("Destination","WaitingForTreatment")
	end
			
	if Cured == false then
		-- TREATMENT
		if Disease == false then -- special case HP LOSS
			Costs = GetMaxHP("Destination") - GetHP("Destination") + 100
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
		local MustPay = DynastyIsPlayer("SickDyn") and GetDynastyID("Hospital") ~= GetDynastyID("SickDyn")
			
		if CanHeal then
			if MustPay and not f_SpendMoney("Destination", Costs, "Offering") then
				MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
			else
				-- remove medicine
				if CanHeal == 1 then
					RemoveItems("Hospital",Medicine,1,INVENTORY_STD)
				elseif CanHeal == 2 then
					MedicineInSalescounter = GetProperty("Hospital", "Salescounter_"..MedicineId) or 0
					SetProperty("Hospital","Salescounter_"..MedicineId,(MedicineInSalescounter - 1))
				end
				
				f_CreditMoney("Hospital",Costs,"Offering")
				economy_UpdateBalance("Hospital", "Service", Costs)
				
				MsgSay("","@L_MEDICUS_TREATMENT_DOC_"..Label)
				
				if Disease == "Sprain" then
					diseases_Sprain("Destination",false)
				elseif Disease == "Cold" then
					diseases_Cold("Destination",false)
				elseif Disease == "Influenza" then
					diseases_Influenza("Destination",false)
				elseif Disease == "Fracture" then
					ms_medicaltreatmenttarget_LayToBed("","Destination",BedNumber)
					diseases_Fracture("Destination",false)
				elseif Disease == "BurnWound" then
					ms_medicaltreatmenttarget_LayToBed("","Destination",BedNumber)
					diseases_BurnWound("Destination",false)
					local ToHeal = GetMaxHP("Destination") - GetHP("Destination")
					ModifyHP("Destination",ToHeal,true)
				elseif Disease == "Pox" then
					ms_medicaltreatmenttarget_LayToBed("","Destination",BedNumber)
					diseases_Pox("Destination",false)
				elseif Disease == "Caries" then
					diseases_Caries("Destination", false)
				elseif Disease == "Pneumonia" then
					ms_medicaltreatmenttarget_LayToBed("","Destination",BedNumber)
					diseases_Pneumonia("Destination", false)
				elseif Disease == "Blackdeath" then
					ms_medicaltreatmenttarget_LayToBed("","Destination",BedNumber)
					diseases_Blackdeath("Destination",false)
					-- 120 hours immunity to stop black death
					AddImpact("Destination","PlagueImmunity",1,120)
				else
					local ToHeal = GetMaxHP("Destination") - GetHP("Destination")
					ModifyHP("Destination",ToHeal,true)
				end
					
				if HasData("LayStill") then
					RemoveData("LayStill")
				end
						
				-- modify the favor to the boss
				if BuildingGetOwner("Hospital","MyBoss") then
					chr_ModifyFavor("Destination","MyBoss",FavorMod)
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
		SetProperty("Destination", "IgnoreHospital", GetID("Hospital"))
		SetProperty("Destination", "IgnoreHospitalTime", GetGametime()+12)
	else
		MoveSetActivity("Destination","")
		if ImpactGetMaxTimeleft("Destination","Resist")<4 then
			AddImpact("Destination","Resist",1,4) -- def 6
		end
			
		if HasProperty("Destination","WaitingForTreatment") then
			RemoveProperty("Destination","WaitingForTreatment")
		end
	end
	
	SetData("Blocked", 1)
	Sleep(10)
	SetState("",STATE_DUEL,false)
	SetState("Destination",STATE_DUEL,false)
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
	
	f_ExitCurrentBuilding("")
	SetState("",STATE_DUEL,false)
	f_StrollNoWait("", 800, 5)
	return
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
	
	if AliasExists("Destination") then
		SetState("Destination",STATE_DUEL,false)
	end
end