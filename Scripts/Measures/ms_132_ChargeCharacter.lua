function Run()

	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		return
	end

	if not GetInsideBuilding("","councilbuilding") then
		return
	end

	if GetSettlementID("")~=GetSettlementID("councilbuilding") then
		MsgQuick("","@L_NEWSTUFF_TRIAL_INSTALL_WRONGTOWNHALL")
		return
	end
	
	if HasProperty("destination", "AtWar") then	
		MsgQuick("", "@L_CHARGE_FAILURE_+0")
		StopMeasure()
		
	end
	
	if HasProperty("councilbuilding","CityLevelUpAhead") then
		MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+2")
		return
	end
	
	if not IsGUIDriven() and Rand(100)>25 then 
		if ms_132_chargecharacter_HasImmunity() then
			StopMeasure()
		end
		
		GetSettlement("councilbuilding","CityAlias")
		if not GetOfficeTypeHolder("CityAlias",3,"judge") then
			StopMeasure()
		end
		
		if GetID("") == GetID("judge") then
			StopMeasure()
		end
		
		local success = SimCanBeCharged("destination")
		if success==0 then
			SimChargeCharacter("","destination")
		end
		StopMeasure()
	end
	
	if not GetLocatorByName("councilbuilding", "ApproachUsherPos", "destpos") then
		MsgQuick("","@L_LAWSUIT_1_INSTALL_FAILURES_+0")
		return
	end

	while true do
		if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
			break
			--MsgQuick("","@L_LAWSUIT_1_INSTALL_FAILURES_+0")
			--return
		end
		Sleep(2)
	end

	SetData("ReleaseLocator", 1)

	BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher")

	--cutscene cam
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Usher")
	CutsceneCameraCreate("cutscene","")
	camera_CutsceneBothLock("cutscene", "")

	PlayAnimationNoWait("","talk")
	MsgSay("","@L_LAWSUIT_1_INSTALL_ACCUSER_+0",GetID("destination"))

	--WalkTo Scribe locator

	-- der sim erzeugt ein settlementevent mit alias "trial"
	-- das event erhält automatisch einen termin, und eine guildworldID.

	camera_CutsceneBothLock("cutscene", "Usher")

	-- if destination has privilege Immunity
	if ms_132_chargecharacter_HasImmunity() then
		MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_IMMUNITY_+0",GetID("destination"))
		f_StrollNoWait("",250,1)
		StopMeasure()
	end
	GetSettlement("councilbuilding","CityAlias")

	if not GetOfficeTypeHolder("CityAlias",3,"judge") then
		MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_NOJUDGE_+0")
		f_StrollNoWait("",250,1)
		StopMeasure()
	end
	if GetID("") == GetID("judge") then
		MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_YOUAREJUDGE_+0")
		f_StrollNoWait("",250,1)
		StopMeasure()
	end
	local success = SimCanBeCharged("destination")

	if success==0 then
		MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_SUCCESS_+0",GetID("destination"))
		SimChargeCharacter("","destination")
	elseif success==1 then
		MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_TRIAL_+0",GetID("destination"))
	elseif success==2 then
		-- bug, pregnant characters also return 2
		if GetState("destination", STATE_PREGNANT) then
			MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_NOCHARGE_+0",GetID("destination"))
		else
			MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_JAIL_+0",GetID("destination"))
		end
	else
		MsgSay("Usher","@L_LAWSUIT_1_INSTALL_USHER_NOCHARGE_+0",GetID("destination"))
	end
	f_StrollNoWait("",250,1)

end

function HasImmunity()
 if ( GetImpactValue("destination","HaveImmunity")==1 and GetImpactValue("destination","HasRepealedImmunity") < 1 ) then
	return true
 else
	return false
 end
end

function CleanUp()
	DestroyCutscene("cutscene")
	if GetData("ReleaseLocator")==1 then
		f_EndUseLocatorNoWait("","destpos", GL_STANCE_STAND)
	end
end

