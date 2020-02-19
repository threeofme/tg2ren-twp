-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_089_PrayForGodsBlessing"
----
----	with this measure, the player can protect a building of his own 
----	dynasty against sabotage and other catastrophes
----
-------------------------------------------------------------------------------

function Run()
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
--	if not (GetDynastyID("Destination")==GetDynastyID("")) then
--		StopMeasure()
--	end
	
	MeasureSetStopMode(STOP_CANCEL)
	
	if not SimGetWorkingPlace("","church") then
		if IsPartyMember("") then
			local NextBuilding1 = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_CHURCH_EV)
			local NextBuilding2 = false
			if NextBuilding1 then
				CopyAlias(NextBuilding1,"church")
			else			
				NextBuilding2 = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_CHURCH_CATH)
				if NextBuilding2 then
					CopyAlias(NextBuilding2,"church")
				else
					StopMeasure()
				end
			end
		else
			StopMeasure()
		end
	end
	
	if GetInsideBuilding("","CurrentBuilding") then
		f_ExitCurrentBuilding("")
	end
	if not f_MoveTo("","Destination",GL_MOVESPEED_WALK,500) then
		StopMeasure()
	end
	AlignTo("","Destination")
	Sleep(1)
	GetPosition("","ParticleSpawnPosPrayer")
	GetPosition("Destination","ParticleSpawnPosBuilding")
	
	local Time = PlayAnimationNoWait("","pray_standing") 
	StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPosPrayer",2,Time)
	MsgSay("","@L_CHURCH_089_PRAYFORGODSBLESSING_PRAYING",GetID("Destination")) 
	Sleep(1)
	local Elapse = 60*(GetGametime() + duration)
	local BossID = dyn_GetValidMember("dynasty")
	GetAliasByID(BossID, "Boss")
	if GetDynastyID("")~=GetDynastyID("Destination") then
		if BuildingGetOwner("Destination","LuckyGuy") then
	
			feedback_MessageWorkshop("Destination",
				"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_LUCKYGUY_HEAD_+0",
				"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_LUCKYGUY_BODY_+0",GetID("Destination"),Elapse,GetID(""))
			Sleep(0.5)
			MsgNewsNoWait("","Destination","","building",-1,
				"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_NICEGUY_HEAD_+0",
				"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_NICEGUY_BODY_+0",GetID("Destination"),Elapse,GetID("LuckyGuy"))
			ModifyFavorToSim("LuckyGuy","Boss",10)
		end
	else
		feedback_MessageWorkshop("Destination",
			"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_OWNER_HEAD_+0",
			"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_OWNER_BODY_+0",GetID("Destination"),Elapse)
	end
	
	CreateScriptcall("PrayForGodsBlessing_End",duration,"Measures/ms_089_PrayForGodsBlessing.lua","ResetBlessing","Owner","Destination",0)
	
	SetMeasureRepeat(TimeOut)
	AddImpact("destination","DivineBlessing",1,duration)
	chr_GainXP("",GetData("BaseXP"))
	
end

function ResetBlessing()
	feedback_MessageWorkshop("Destination",
		"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_END_HEAD_+0",
		"@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_END_BODY_+0",GetID("Destination"))
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

