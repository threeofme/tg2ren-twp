function Init()
end

function Run()
	local Incubate = true
	if IsPartyMember("") then
		feedback_MessageCharacter("","@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_HEAD_+0",
						"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_BODY_+0",GetID(""))
	end
	
	while Incubate == true do
		StopAction("sickness","")
		RemoveOverheadSymbols("")
		
		------------------------------------------------------
		-- increase the number of infections
		-- this is only done twice because incubate is only true if
		-- the disease changed to a higher level
		if GetSettlement("","City") then
			if GetImpactValue("","Sprain")==1 then
				chr_incrementInfectionCount("SprainInfected", "City")
				Incubate = state_sick_SprainBehaviour()
			elseif GetImpactValue("","Cold")==1 then
				chr_incrementInfectionCount("ColdInfected", "City")
				Incubate = state_sick_ColdBehaviour()
			elseif GetImpactValue("","Influenza")==1 then
				chr_incrementInfectionCount("InfluenzaInfected", "City")
				Incubate = state_sick_InfluenzaBehaviour()
			elseif GetImpactValue("","BurnWound")==1 then
				chr_incrementInfectionCount("BurnWoundInfected", "City")
				Incubate = state_sick_BurnWoundBehaviour()
			elseif GetImpactValue("","Pox")==1 then
				chr_incrementInfectionCount("PoxInfected", "City")
				Incubate = state_sick_PoxBehaviour()
			elseif GetImpactValue("","Pneumonia")==1 then
				chr_incrementInfectionCount("PneumoniaInfected", "City")
				Incubate = state_sick_PneumoniaBehaviour()
			elseif GetImpactValue("","Blackdeath")==1 then
				chr_incrementInfectionCount("BlackdeathInfected", "City")
				Incubate = state_sick_BlackdeathBehaviour()
			elseif GetImpactValue("","Fracture")==1 then
				chr_incrementInfectionCount("FractureInfected", "City")
				Incubate = state_sick_FractureBehaviour()
			elseif GetImpactValue("","Caries")==1 then
				chr_incrementInfectionCount("CariesInfected", "City")
				Incubate = state_sick_CariesBehaviour()
			elseif GetState("", STATE_BLACKDEATH) then
				return
			else
				SetState("", STATE_SICK, false)
				return
			end
		end
		------------------------------------------------------
	end
	return
end

function SprainBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab mir den Fuss verstaucht!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","hobble")
		end
	end
	while GetImpactValue("","Sprain")==1 do
		Sleep(Rand(20)+10)
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("SprainInfected", "City")
	end
	
	return false
end

function ColdBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab ne Erkältung")
	CommitAction("sickness","","")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	while GetImpactValue("","Cold")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			if Rand(10)>4 then
				AnimTime = PlayAnimationNoWait("","sneeze")
				Sleep(0.5)
				PlaySound3DVariation("","CharacterFX/sneeze",1)
				Sleep(AnimTime-0.5)
			else
				AnimTime = PlayAnimationNoWait("","cough")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/disease_light_cough",1)
				
				Sleep(AnimTime-1)
				
			end
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("ColdInfected", "City")
	end
	
	if Rand(3) == 0 then
		diseases_Influenza("",true,false)
	end
	return true
end

function InfluenzaBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab Grippe!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	CommitAction("sickness","","")
	while GetImpactValue("","Influenza")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			if Rand(10)>4 then
				AnimTime = PlayAnimationNoWait("","sneeze")
				Sleep(0.5)
				PlaySound3DVariation("","CharacterFX/sneeze",1)
				Sleep(AnimTime-0.5)
			else
				AnimTime = PlayAnimationNoWait("","cough")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/disease_light_cough",1)
				Sleep(AnimTime-1)
				
			end
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("InfluenzaInfected", "City")
	end
	
	if Rand(3) == 0 then
		diseases_Pneumonia("",true,false)
	end
	return true
end

function BurnWoundBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab mich verbrannt!")
	local HPChange = GetMaxHP("") * 0.1

	while true do
		Sleep(60)
		if not AliasExists("") or GetImpactValue("","BurnWound")~=1 then
			break
		end
		if IsDynastySim("") then
			SetProperty("", "WasDynastySim",1)
		end
		if not GetState("",STATE_CUTSCENE) then
			ModifyHP("",-HPChange,true)
		end
	end
		
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("BurnWoundInfected", "City")
	end
	
	return false
end

function PoxBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Verdammt, ich hab die Pocken!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	CommitAction("sickness","","")
	while GetImpactValue("","Pox")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			
			AnimTime = PlayAnimationNoWait("","cough")
			Sleep(1)
			PlaySound3DVariation("","CharacterFX/disease_seriously_cough",1)
			Sleep(AnimTime-1)
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("PoxInfected", "City")
	end
	
	return false
end

function PneumoniaBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Verdammt, Lungenentzündung! *hust*")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	while GetImpactValue("","Pneumonia")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			if Rand(10)>4 then
				AnimTime = PlayAnimationNoWait("","sneeze")
				Sleep(0.5)
				PlaySound3DVariation("","CharacterFX/sneeze",1)
				Sleep(AnimTime-0.5)
			else
				AnimTime = PlayAnimationNoWait("","cough")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/disease_seriously_cough",1)
				Sleep(AnimTime-1)
				
			end
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("PneumoniaInfected", "City")
	end
	
	SetProperty("","WasSick",1)
	if IsDynastySim("") then
		SetProperty("", "WasDynastySim",1)
	end
	while GetState("",STATE_CUTSCENE) do
		Sleep(20)
	end
	ModifyHP("",-GetMaxHP(""),true)
	return false
end

function BlackdeathBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Argh, PEST!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	CommitAction("sickness","","")
	
	--extra visuals for blackdeath
--	GfxAttachObject("Trine","particles/ship_burn.nif")
--	AttachModel("", "Trine")
--	GfxSetPosition("Trine", 0, 100, 0, true)
--	GfxScale("Trine",1)
	
	while GetImpactValue("","Blackdeath")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			
			AnimTime = PlayAnimationNoWait("","cough")
			Sleep(1)
			PlaySound3DVariation("","CharacterFX/disease_seriously_cough",1)
			Sleep(AnimTime-1)
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("BlackdeathInfected", "City")	
	end
	
	SetProperty("","WasSick",1)
	if IsDynastySim("") then
		SetProperty("", "WasDynastySim",1)
	end
	while GetState("",STATE_CUTSCENE) do
		Sleep(20)
	end
	ModifyHP("",-GetMaxHP(""),true)
	return false
end

function FractureBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Aua, hab mir mein Bein gebrochen!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","hobble")
		end
	end
		
	while GetImpactValue("","Fracture")==1 do
		Sleep(Rand(20)+10)
	end

	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("FractureInfected", "City")
	end
	
	return false
end

function CariesBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Meine Zähne faulen!")
	while GetImpactValue("","Caries")==1 do
		Sleep(Rand(20)+10)
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("CariesInfected", "City")		
	end
	
	return false
end

function CleanUp()
	GfxDetachAllObjects()
	GetSettlement("","City")
	if AliasExists("City") then
		if HasProperty("City","InfectedSims") then
			local CurrentInfected = GetProperty("City","InfectedSims") - 1
			SetProperty("City","InfectedSims",CurrentInfected)
		end
	end
	RemoveProperty("", "YearBlackdeath")
	StopAction("sickness","")
	RemoveOverheadSymbols("")
end

