-- -----------------------
-- Run
-- -----------------------
function Run()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local PercentDamage = 40
	local PercentInitialDamage = 20
	MsgMeasure("","")
	BuildingGetOwner("Destination", "Victim")
	if (GetImpactValue("Destination","DivineBlessing")==1) then
		MsgQuick("","@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_FAILURES_+0",GetID("Destination"))
		return
	end
	
	if GetImpactValue("Destination","buildingbombedtoday")==1 then
		MsgQuick("","@L_GENERAL_MEASURES_142_ORDERASABOTAGE_FAILURES_+0",GetID("Destination"))
		return
	end
	
	if not HasProperty("Destination","SabotageInProgress") then
		SetProperty("Destination","SabotageInProgress",1)
	else
		MsgQuick("","@L_GENERAL_MEASURES_142_ORDERASABOTAGE_FAILURES_+0",GetID("Destination"))
		StopMeasure()
	end
	
	-- Try to get a free bomb locator or the entry locator or the position of the building
	if GetFreeLocatorByName("Destination", "Bomb", 1, 3, "SabotagePosition") then
		if not f_MoveTo("","SabotagePosition") then
			if GetOutdoorMovePosition("","Destination","SabotagePosition") then
				if not f_MoveTo("","SabotagePosition") then
					MsgQuick("","@L_GENERAL_MEASURES_142_ORDERASABOTAGE_FAILURES_+1",GetID("Destination"))
					StopMeasure()
				end
			else
				MsgQuick("","@L_GENERAL_MEASURES_142_ORDERASABOTAGE_FAILURES_+1",GetID("Destination"))
				StopMeasure()
			end
		end
	else
		if GetOutdoorMovePosition("","Destination","SabotagePosition") then
			if not f_MoveTo("","SabotagePosition") then
				MsgQuick("","@L_GENERAL_MEASURES_142_ORDERASABOTAGE_FAILURES_+1",GetID("Destination"))
				MsgMeasure("","")
				StopMeasure()
			end				
		else
			MsgQuick("","@L_GENERAL_MEASURES_142_ORDERASABOTAGE_FAILURES_+1",GetID("Destination"))
			StopMeasure()
		end
	end

	
	-- die measure darf/sollte nicht restarten, da nach einem erwischt/entdeckt werden ansonsten die Measure immer wieder neu
	-- aufgerufen werden würde, was zu vielen Beweisen führen würde
	MeasureSetNotRestartable()
	CommitAction("lay_bomb", "", "Destination", "Destination")
	
	-- Attach the bomb model to the myrmidon
	CarryObject("", "Handheld_Device/ANIM_Bomb.nif", false)
	SetData("CarryingBomb", 1)

	PlayAnimation("","watch_for_guard")
	Sleep(1)

	-- Check if the building still exists
	if not GetPosition("Destination", "SabotagePosition") then
		StopMeasure()
	end
	
	-- Place the bomb
	local AnimTime = PlayAnimationNoWait("", "manipulate_bottom_r")
	Sleep(2)
	
	-- spawn the tnt
	GfxAttachObject("tntbarrel", "Handheld_Device/ANIM_Bomb.nif")
	GfxSetPositionTo("tntbarrel", "SabotagePosition")
	-- Remove the bomb from the myrmidon
	CarryObject("", "", false)
	SetData("CarryingBomb", 0)
	Sleep(AnimTime-2)	
	StopAction("lay_bomb", "")

	-- Let the myrmidon flee from the crime scene
	GetFleePosition("", "Destination", 1500, "Away")
	f_MoveTo("", "Away", GL_MOVESPEED_RUN)
	AlignTo("", "Destination")
		
	-- wait before bomb explodes
	Sleep(3)
	
	-- start the burn-building measure
	local Damage = srv_GetUseBombDamage("", "Destination")
	SetProperty("Destination", "BurnDamage", Damage)
	
	if IsDynastySim("Owner") then
		xp_OrderASabotage("", GetData("BaseXP"))
	else
		-- give xp to dynasty char
		if SimGetWorkingPlace("Owner", "WorkBuilding") then
			if BuildingGetOwner("WorkBuilding","BuildingOwner") then
				xp_OrderASabotage("BuildingOwner", GetData("BaseXP"))
			end
		end
	end
	local MrBombID
	if SimGetWorkingPlace("","Base") then
		if BuildingGetOwner("Base","MrBomb") then
			MrBombID = GetDynastyID("MrBomb")
			AddImpact("Destination","buildingbombedby",MrBombID,duration)
		end
	end

	CommitAction("explosion", "", "Destination", "Destination")
	AddImpact("Destination","buildingbombedtoday",1,duration)
	
	SetMeasureRepeat(TimeOut)
	DynastyMakeImpact("Owner", GL_IMPACT_AGGRESSIV, 1)
	
	local BuildingStatus = GetHP("Destination")
	local Damage = BuildingStatus*(PercentInitialDamage/100)
	ModifyHP("Destination",-Damage)

	StartSingleShotParticle("particles/Explosion.nif", "SabotagePosition", 4,5)
	PlaySound3D("Destination","fire/Explosion_01.wav", 1.0)
	GfxDetachObject("tntbarrel")
	
	SetState("Destination", STATE_BURNING, true)
	

	
	feedback_MessageCharacter("Destination",
		"@L_GENERAL_MEASURES_142_ORDERASABOTAGE_MSG_VICTIM_HEAD_+0",
		"@L_GENERAL_MEASURES_142_ORDERASABOTAGE_MSG_VICTIM_BODY_+0", GetID("Destination"))

	Sleep(2)
	StopAction("explosion","")
	RemoveProperty("Destination","SabotageInProgress")
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Destination") then
		if HasProperty("Destination","SabotageInProgress") then
			RemoveProperty("Destination","SabotageInProgress")
		end
	end
	StopAction("explosion", "")
	StopAction("lay_bomb","")
	
	f_EndUseLocator("")
	
	-- Remove the bomb if the myrmidon still carries it
	if GetData("CarryingBomb") == 1 then
		CarryObject("", "", true)
	end
	-- GfxDetachObject("tntbarrel")

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

