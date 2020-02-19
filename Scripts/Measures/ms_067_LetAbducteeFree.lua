function Run()
	if not BuildingGetPrisoner("", "Victim") then
		return
	end
	
	if GetState("Victim",STATE_UNCONSCIOUS) then
		SetState("Victim",STATE_UNCONSCIOUS,false)
	end
	
	SetRoomAnimationTime("","","U_PrisonDoor",0)
	StartRoomAnimation("","","U_PrisonDoor")
	Sleep(1)
	StopRoomAnimation("","","U_PrisonDoor")
	
	GetLocatorByName("","Cell_Door","Cell_Door")
	f_MoveTo("Victim","Cell_Door",GL_MOVESPEED_WALK,0)
	
	GetLocatorByName("","ExitPrisonPos","ExitPrisonPos")
	SimBeamMeUp("Victim","ExitPrisonPos", false) -- false added
	
	StartRoomAnimation("","","U_PrisonDoor")
	Sleep(1.3)
	StopRoomAnimation("","","U_PrisonDoor")
	SetRoomAnimationTime("","","U_PrisonDoor",0)
	f_ExitCurrentBuilding("Victim")
	
	if GetState("Victim",STATE_HIJACKED) then
		SetState("Victim",STATE_HIJACKED,false)
	end
end

function CleanUp()
	if AliasExists("Victim") then
		--SetState("Victim", STATE_EXPEL, true)
		SetState("Victim", STATE_HIJACKED, false)
		--SetState("Victim", STATE_CAPTURED, false)
	
	
		feedback_MessageCharacter("Victim",
			"@L_THIEF_067_LETABDUCTEEOUT_VICTIM_HEAD",
			"@L_THIEF_067_LETABDUCTEEOUT_VICTIM_BODY",GetID("Victim"))
	end
end
