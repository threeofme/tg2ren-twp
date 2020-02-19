-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_055_InsultCharacter"
----
----	with this measure the player can insult an other character to
----	disincrease the favour of his victim
----
-------------------------------------------------------------------------------

function AIDecide()
	
	local Threat = 0
	local VictimSkills = SimGetLevel("Destination")*1.5 + GetSkillValue("Destination", FIGHTING) + GetSkillValue("Destination", CONSTITUTION)
	local InsulterSkills = SimGetLevel("")*2 + GetSkillValue("", FIGHTING) + Rand(3)
	Threat = InsulterSkills - VictimSkills
	
	if GetImpactValue("","Insulter") == 1 or Threat > 5 then
		return "C"
	elseif Threat < 3 then
		return "A"
	elseif DynastyGetDiplomacyState("", "Destination") == DIP_FOE then
		if Threat > 7 then
			return "B"
		else
			return "A"
		end
	else
		return "B"
	end
end

function Run()
	if (GetState("", STATE_CUTSCENE)) then
		SetData("FromCutscene",1)
		ms_055_insultcharacter_Cutscene()
	else
		SetData("FromCutscene",0)
		ms_055_insultcharacter_Normal()
	end
end

function Normal()

	-- Check Inside Building
	if GetInsideBuilding("Destination","Inside") then
		if BuildingGetType("Inside")==2 then
			StopMeasure()
		end
	end
	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 120
	--how much favor from destination to owner is decreased
	local ModifyFavor = 20
	--how much favor from observers to destination is decreased when duel is rejected
	local ObserverFavor = 5
	SetData("ObserverFavor",ObserverFavor)
	--how long message for destination will be displayed
	local MsgTimeOut = 0.5 --15 sekunden
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	-- check if the owner has RattleTheChains impact
	local Chain_factor = 1
	if GetImpactValue("","RattleTheChains")==1 then
		Chain_factor = 2
	end
 
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	MeasureSetNotRestartable()
	-- check if the destination has BeVenerability impact
	if GetImpactValue("Destination","BeVenerability")==1 then
		MsgQuick("", "@L_PRIVILEGES_121_BEVENERABILITY_FAILURES_+0", GetID("Destination"))
		StopMeasure()
	end

	Sleep(0.75)
	
	--check if destination has drunken boozybreathbeer
	if GetImpactValue("Destination","boozybreathbeer")==1 then	
		GetPosition("Destination", "ParticleSpawnPos")
		StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
		PlaySound3DVariation("Destination","measures/boozybreathbeer",1)
		feedback_OverheadComment("",
			"@L_INTRIGUE_055_INSULTCHARACTER_BOOZYBREATHBEER_+0", false, true)
		GetFleePosition("", "Destination", 1000, "Away")
		f_MoveTo("", "Away", GL_MOVESPEED_RUN)
		
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_ACTOR_HEAD_+0",
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_ACTOR_BODY_+0", GetID("Destination"))
		
		MsgNewsNoWait("Destination","","","intrigue",-1,
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_VICTIM_HEAD_+0",
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_VICTIM_BODY_+0", GetID("Owner"),GetID("Destination"),ItemGetLabel("BoozyBreathBeer", true))			
		StopMeasure()
	end
	
	--cutscene init
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Destination")
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")	-- irgend ein befehl um die cutscene camera zu setzen
	
	
	local CurrentRound = GetRound()
	if not HasProperty("", "LastTimeInsulted") then
		SetProperty("", "LastTimeInsulted", CurrentRound)
	end
	
	local LastTimeInsulted = GetProperty("", "LastTimeInsulted")
	if CurrentRound - LastTimeInsulted < 3 then -- only count insults in the last 3 rounds
		if not HasProperty("", "TimesInsulted") then
			SetProperty("", "TimesInsulted", 0)
		end
		
		if (GetImpactValue("", "Insulter") == 0) then
			local TimesInsulted = GetProperty("", "TimesInsulted") + 1
			SetProperty("", "TimesInsulted", TimesInsulted)
			if TimesInsulted > 3 then
				AddImpact("","Insulter",1,48) 
				SetProperty("", "TimesInsulted", 0)
				MsgNewsNoWait("","","","intrigue",-1,
					"@L_DUELL_1_DIALOGMSG_INSULTER_IMPACTINSULTER_HEAD_+0",
					"@L_DUELL_1_DIALOGMSG_INSULTER_IMPACTINSULTER_BODY_+0",GetID(""))
			end
		end
	end
	SetProperty("", "LastTimeInsulted", CurrentRound)
	--do visual stuff
	local time1 = PlayAnimationNoWait("", "insult_character")
	
	--let the dialog begin
	local Index = MsgSay("","@L_DUELL_1_DIALOGMSG_INSULTS")
	--store label index for news message
	local ReplacementLabel = "_DUELL_1_DIALOGMSG_INSULTS_+"..Index
	--display decision message for destination
	
	local ChooseText = "@B[A,@L_DUELL_1_DIALOGMSG_INSULTEDONE_+2]@B[B,@L_DUELL_1_DIALOGMSG_INSULTEDONE_+3]"
	if not (GetImpactValue("", "Insulter") == 0) then
		ChooseText = ChooseText.."@C[A,@L_DUELL_1_DIALOGMSG_INSULTEDONE_+2]"
	end
	local Result = MsgSayInteraction("Destination","Destination","",
				ChooseText,
				ms_055_insultcharacter_AIDecide,  --AIFunc
				"@L_DUELL_1_DIALOGMSG_INSULTEDONE_+1",
				GetID(""),ReplacementLabel,GetID("Destination"))
	
	--destination wants satisfaction
	SetMeasureRepeat(TimeOut)
	if Result == "A" then  
		camera_CutsceneBothLock("cutscene", "Destination")
		MsgSay("Destination","@L_DUELL_1_DIALOGMSG_INSULTEDONE_SATISFACTION_YES")
		MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_DUELL_1_DIALOGMSG_INSULTER_+0",
				"@L_DUELL_1_DIALOGMSG_INSULTER_YES_+0",GetID(""),GetID("Destination"),ReplacementLabel)
		
		-- initialize the cutscene: 
		CreateCutscene("Duel","my_duel")
		CopyAliasToCutscene("Destination","my_duel","challenger")
		CopyAliasToCutscene("","my_duel","challenged")
		CutsceneCallUnscheduled("my_duel","Start")
		chr_GainXP("",GetData("BaseXP"))
		
	--destination is a n00b and defeats
	elseif Result == "B" then
		camera_CutsceneBothLock("cutscene", "Destination")
		MsgSay("Destination","@L_DUELL_1_DIALOGMSG_INSULTEDONE_SATISFACTION_NO")
		camera_CutsceneBothLock("cutscene", "")
		MsgSay("","@L_DUELL_1_DIALOGMSG_INSULTEDONE_SATISFACTION_NO_SUB")
		MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_DUELL_1_DIALOGMSG_INSULTER_+0",
				"@L_DUELL_1_DIALOGMSG_INSULTER_NO_+0",GetID(""),GetID("Destination"),ReplacementLabel)
		
		--find sims in range and decrease favor to destination
		SendCommandNoWait("Destination","DecreaseFavor")
		
	-- destination doesn't want to duel with such a brutal guy
	elseif Result == "C" then
		camera_CutsceneBothLock("cutscene", "Destination") 
		MsgSay("Destination","@L_DUELL_1_DIALOGMSG_INSULTEDONE_SATISFACTION_NOTINSANE_+0") 
		camera_CutsceneBothLock("cutscene", "") 
		MsgSay("","@L_DUELL_1_DIALOGMSG_INSULTEDONE_SATISFACTION_NO_SUB") 
		MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_DUELL_1_DIALOGMSG_INSULTER_+0",
				"@L_DUELL_1_DIALOGMSG_INSULTER_NOTINSANE_+0",GetID(""),GetID("Destination"),ReplacementLabel) 
	end
	
	Sleep(1)	
	ModifyFavor = ModifyFavor / Chain_factor
	chr_ModifyFavor("Destination","",-ModifyFavor)
	
	
	
	
	StopMeasure()
end




function Cutscene()

	if SimGetCutscene("","cutscene") then
		CutsceneSetMeasureLockTime("cutscene", 2.0)
	end
	
	Sleep(1)

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 120
	--how much favor from destination to owner is decreased
	local ModifyFavor = 5
	--how much favor from observers to destination is decreased when duel is rejected
	local ObserverFavor = 5
	SetData("ObserverFavor",ObserverFavor)
	--how long message for destination will be displayed
	local MsgTimeOut = 0.5 --15 sekunden
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	-- check if the owner has RattleTheChains impact
	local Chain_factor = 1
	if GetImpactValue("","RattleTheChains")==1 then
		Chain_factor = 2
	end
 
	--run to destination and start action at MaxDistance
--	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
--		StopMeasure()
--	end
	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)
	-- check if the destination has BeVenerability impact
	if GetImpactValue("Destination","BeVenerability")==1 then
		MsgQuick("", "@L_PRIVILEGES_121_BEVENERABILITY_FAILURES_+0", GetID("Destination"))
		StopMeasure()
	end

	Sleep(0.75)
	
	--check if destination has drunken boozybreathbeer
	if GetImpactValue("Destination","boozybreathbeer")==1 then	
		GetPositionOfSubobject("Destination","Game_Head","ParticleSpawnPos")
		StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
		PlaySound3DVariation("Destination","measures/boozybreathbeer",1)
		feedback_OverheadComment("",
			"@L_INTRIGUE_055_INSULTCHARACTER_BOOZYBREATHBEER_+0", false, true)
		
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_ACTOR_HEAD_+0",
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_ACTOR_BODY_+0", GetID("Destination"))
		
		MsgNewsNoWait("Destination","","","intrigue",-1,
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_VICTIM_HEAD_+0",
			"@L_INTRIGUE_055_INSULTCHARACTER_FAILED_VICTIM_BODY_+0", GetID("Owner"),GetID("Destination"),ItemGetLabel("BoozyBreathBeer", true))			
		StopMeasure()
	end
	
	--let the dialog begin
	local Index = MsgSay("","@L_DUELL_1_DIALOGMSG_INSULTS")
	--store label index for news message
	
	Sleep(1)	
	ModifyFavor = ModifyFavor / Chain_factor
	chr_ModifyFavor("Destination","",-ModifyFavor)
	
	chr_GainXP("",GetData("BaseXP"))
	
	StopMeasure()
end



function DecreaseFavor()
local ObserverFavor = GetData("ObserverFavor")
	local Radius = 1000
	local Count = Find("", "__F( (Object.GetObjectsByRadius(Sim) == "..Radius..")","Sim", -1)
	for i=0,Count-1 do 
		chr_ModifyFavor("Sim"..i,"",-ObserverFavor)
		SendCommandNoWait("Sim"..i,"LookAt")
		Sleep(0.1)
	end
end

function LookAt()
	Sleep(0.5)
	AlignTo("", "Destination")
	Sleep(Rand(2)+1)
	if Rand(2) == 0 then
		PlayAnimation("","cheer_02")
	else
		PlayAnimation("","cheer_01")
	end
end

function CleanUp()
	if GetData("FromCutscene") == 0 then
		DestroyCutscene("cutscene")
		if AliasExists("Destination") then
			StopAnimation("Destination")
		end
		AddImpact("Destination","BadDay",1,12)
		StopAnimation("")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	
end


