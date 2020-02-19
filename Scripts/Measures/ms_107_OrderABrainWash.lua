-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_107_OrderABrainwash"
----
----	with this privilege the office bearer can force an alliance with the
----	victim, for 24h
----
-------------------------------------------------------------------------------

function Run()
	--how far the Destination can be to start this action
	local MaxDistance = 400
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 60
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not AliasExists("Destination") then
		-- no destination found (should never happen)
		return
	end

	if not GetSettlement("", "CityAlias") then
		-- no city found (should never happen for a city guard)
		return
	end

	if not CityGetRandomBuilding("CityAlias", -1, GL_BUILDING_TYPE_PRISON, -1, -1, FILTER_IGNORE, "Prison") then
		-- no prison found
		return
	end
	
	--check if destination is too far from city
	GetPosition("CityAlias","CityPos")
	if GetInsideBuilding("Destination","CurrentBuilding") then
		GetPosition("CurrentBuilding","BuildingPos")
		if GetDistance("BuildingPos","CityPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	else
		GetPosition("Destination","DestPos")
		if GetDistance("CityPos","DestPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	end
	
	local BossID = dyn_GetValidMember("dynasty")
	GetAliasByID(BossID, "MrBrainwash")
	
	if not GetState("Destination",STATE_IMPRISONED) then
	
		--run to destination and start action at MaxDistance
		if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
			StopMeasure()
		end
		SetData("arrester",1)
		BlockChar("Destination")
		SendCommandNoWait("Destination", "Captured")
		--BattleWeaponPresent("")
		AlignTo("", "Destination")
		Sleep(0.7)
		Time = PlayAnimationNoWait("", "propel")
		local ActivityTime = MoveSetActivity("Destination","arrested")
		
		Sleep(Time)
		--BattleWeaponStore("")
		
		--move to jail
		f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK, 180)
		if GetOutdoorMovePosition(nil, "Prison", "MovePos") then
			if not (f_MoveTo("Destination", "MovePos", GL_MOVESPEED_WALK)) then
				StopMeasure()
				return
			end	
		else
			if not (f_MoveTo("Destination", "Prison", GL_MOVESPEED_WALK)) then
				StopMeasure()
				return
			end		
		end
		
		f_MoveTo("", "Prison", GL_MOVESPEED_WALK, "MoveResult")
		ActivityTime = MoveSetActivity("Destination","")
		Sleep(ActivityTime)
		
	else
		if not GetInsideBuilding("","CurrentBuilding") then
			if not f_MoveTo("","Prison") then
				StopMeasure()
			end
			GetLocatorByName("Prison","Stroll2","ThereYouGo")
			f_MoveTo("","ThereYouGo")
		end
		AlignTo("","Destination")
		Sleep(1)
		PlayAnimationNoWait("","propel")
		SetProperty("Destination","GettingTortured",1)
		SetData("WasImprisoned",1)
		SetState("Destination",STATE_IMPRISONED,false)
		SimSetBehavior("Destination","")
		RemoveProperty("Destination","Imprisoned")
		Sleep(1)
		StopAnimation("Destination")
		BlockChar("Destination")
	end
	
	
	--SetMeasureRepeat(TimeOut)
	SimGetWorkingPlace("","Workbuilding")
	SetRepeatTimer("Workbuilding", GetMeasureRepeatName(), TimeOut)
	
	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_107_ORDERABRAINWASH_MSG_VICTIM_HEADLINE_+0",
		"@L_PRIVILEGES_107_ORDERABRAINWASH_MSG_VICTIM_BODY_+0",GetID(""), GetID("Destination"), GetID("CityAlias"), GetID("Destination"))
	
	--get the chair, sit down
	if GetFreeLocatorByName("Prison", "Chair01",-1,-1, "Chairpos") then
		f_BeginUseLocator("Destination","Chairpos",GL_STANCE_SIT,1)
		BlockLocator("Destination","Chairpos")
		
		Sleep(0.5)
	end
	
	if GetFreeLocatorByName("Prison", "Brainwash",-1,-1, "BrainwashPos") then
		BlockLocator("","BrainwashPos")
	 	f_MoveTo("", "BrainwashPos")
	end
	
	Sleep(0.5)
	
	--start brainwashing
	local DestinationGender = (SimGetGender("Destination"))
	local GenderType
	if DestinationGender == 0 then
		GenderType = "_1ST_TOFEMALE"
	else
		GenderType = "_1ST_TOMALE"
	end
	PlayFE("","smile",1.0,3.0, 0)
	PlayAnimationNoWait("","threat")
	MsgSay("","@L_PRIVILEGES_107_ORDERABRAINWASH_TORTURER"..GenderType)
	PlayAnimationNoWait("","insult_character")
	MsgSay("","@L_PRIVILEGES_107_ORDERABRAINWASH_TORTURER"..GenderType)
	Sleep(2)
	PlayAnimation("","fistfight_in")
	Time = PlayAnimationNoWait("","fistfight_punch_06")
	Sleep(0.6)
	PlaySound3DVariation("","Effects/combat_strike_fist",1)
	Sleep(Time-1)
	PlayAnimation("","fistfight_out")
	MsgSay("","@L_PRIVILEGES_107_ORDERABRAINWASH_TORTURER_2ND_MAKE_PANIC")
	Sleep(1)
	PlayAnimationNoWait("","talk")
	MsgSay("","@L_PRIVILEGES_107_ORDERABRAINWASH_TORTURER_3RD_PROPOSAL")
	PlayAnimationNoWait("Destination","sit_talk")
	MsgSay("Destination","@L_PRIVILEGES_107_ORDERABRAINWASH_VICTIM_TO_TORTURER")
	f_EndUseLocator("Destination","Chairpos",GL_STANCE_STAND)
	PlayFE("","smile",1.0,3.0, 0)
	

----	Das Diplomatieverhältnis zwischen den beiden Dynastien wird 
----	für 24h auf "Blutbande" gestellt. 

	
	--force dynasty relations to alliance
	DynastySetMinDiplomacyState("MrBrainwash", "Destination", DIP_ALLIANCE, GetID("MrBrainwash"), duration)
	DynastyForceCalcDiplomacy("MrBrainwash")
	DynastyForceCalcDiplomacy("Destination")
	AddImpact("Destination","brainwashed",1,duration)
	chr_GainXP("MrBrainwash",GetData("BaseXP"))
	
	StopMeasure()

end


function Captured()
	MoveStop("")
	SetProperty("","NoEscape",1)
	SetState("", STATE_CAPTURED, true)
	AlignTo("", "Owner")
	Sleep(0.7)

	
	while true do
		Sleep(100)
	end
end

function CleanUp()	
	if AliasExists("Destination") then
		if HasData("WasImprisoned") then
			SetState("Destination",STATE_IMPRISONED,true)
		end
		SimResetBehavior("Destination")
		
		if AliasExists("Chairpos") then
			if HasProperty("Destination","NoEscape") then
				RemoveProperty("Destination","NoEscape")
			end
			ReleaseLocator("Destination","Chairpos")
		end
		MoveSetActivity("Destination","")
		SetState("Destination", STATE_CAPTURED, false)
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

