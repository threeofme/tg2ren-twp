-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_114_BanCharacter"
----
----	with this privilege the office bearer can ban a person from the town, 
----	where he is office holder.
----
-------------------------------------------------------------------------------

function Run()

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 40
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	local OwnerRhetoric = (GetSkillValue("",RHETORIC))
	local DestinationRhetoric = (GetSkillValue("Destination",RHETORIC))
	local OwnerGender = (SimGetGender(""))
	local DestinationGender = (SimGetGender("Destination"))
		
	GetSettlement("","CityAlias")
	if not CityGetRandomBuilding("CityAlias", 3, 23, -1, -1, FILTER_IGNORE, "TownHall") then
		StopMeasure()
	end
	
	--check if destination is too far from city
	GetPosition("TownHall","CityPos")
	if GetInsideBuilding("Destination","CurrentBuilding") then
		GetPosition("CurrentBuilding","BuildingPos")
		if GetDistance("BuildingPos","CityPos") > 12000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	else
		GetPosition("Destination","DestPos")
		if GetDistance("CityPos","DestPos") > 12000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	end
	
	--how long the ban will be 
	local duration
	local OfficeType = SimGetOfficeLevel("")
	if OfficeType == 3 then
		--if office holder is dorfschulze
		duration = 16
	elseif OfficeType == 4 then
		--if officeholder is buergemeister
		duration = 20
	else
		--then officeholder must be landesherr
		duration = 24
	end
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--look at each other
	feedback_OverheadActionName("Destination")
	
	
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Destination")
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")
	
	AlignTo("", "Destination")
	AlignTo("Destination", "")
	Sleep(0.5)
	MeasureSetStopMode(STOP_CANCEL)
	SetMeasureRepeat(TimeOut)
	
	--send message to destination, that he will be banned
	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_BEGIN_HEADLINE_+0",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_BEGIN_BODY_+0",GetID(""),GetID("Destination"),duration,GetID("CityAlias"))
	
	--combine textlabel by checking the destinations gender
	local GenderType
	if DestinationGender == 0 then
		GenderType = "_TOFEMALE"
	else
		GenderType = "_TOMALE"
	end
	
	PlayAnimationNoWait("","threat")
	local Elapse = 60*(GetGametime() + duration)
	MsgSay("","@L_PRIVILEGES_114_BANCHARACTER_BANISHMENT"..GenderType,GetID("CityAlias"),Elapse,GetID("Destination"))
	
	--remove the victim from his office
	if not (SimGetOfficeLevel("Destination") == -1) then
		CityRemoveFromOffice("CityAlias","Destination")
	end
	
	-- remove the victim from office applicants
	CityRemoveApplicant("CityAlias","Destination")
	
	-- set pre banned impact
	--AddImpact("Destination","prebanned",1,4)
	AddImpact("Destination","banned",1,duration)
	
	--modify the favor
	local favormodify = GetFavorToSim("Destination","") - 5
	chr_ModifyFavor("Destination","",-favormodify)
	AddImpact("Destination","BadDay",1,12)
	feedback_OverheadComment("Destination", "@L$S[2006] %1n", false, false, favormodify)

	CreateScriptcall("BanCharacter_Ban_Start",4,"Measures/ms_114_BanCharacter.lua","JailTime","Owner","Destination",duration)
	CreateScriptcall("BanCharacter_Ban_End",duration,"Measures/ms_114_BanCharacter.lua","BanIsOver","Owner","Destination",0)
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function JailTime(duration)
	GetSettlement("","CityAlias")
	if GetInsideBuilding("Destination","Inside") then
		f_ExitCurrentBuilding("Destination")
	end
	--local impacttime = duration - 4
	--AddImpact("Destination","banned",1,impacttime)
	CityAddPenalty("CityAlias","Destination",PENALTY_PRISON,duration)
end

function BanIsOver()
	if GetSettlement("","CityAlias") then
		if CityGetPenalty("CityAlias","Destination",PENALTY_PRISON,true,"Penalty") then
			PenaltyFinish("Penalty")
		end
	end
	RemoveImpact("Destination","banned")	
	
	--send message to destination, that ban is over
	feedback_MessageCharacter("Destination",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_END_HEADLINE",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_END_BODY",GetID("Destination"),GetID("CityAlias"))
	--send message to owner, that ban is over
	feedback_MessageCharacter("",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_ACTOR_END_HEADLINE",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_ACTOR_END_BODY",GetID("Destination"),GetID("CityAlias"))
end

function CleanUp()
	DestroyCutscene("cutscene")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+4",Gametime2Total(mdata_GetDuration(MeasureID)))
end

