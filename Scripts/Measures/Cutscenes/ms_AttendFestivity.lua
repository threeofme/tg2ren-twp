function AIFunction()
	return "O"
end
function Run()
	SimSetProduceItemID("", -1, -1)
	SetState("", STATE_WORKING, false)
	if GetState("", STATE_ROBBERMEASURE) then
		SetState("", STATE_ROBBERMEASURE, false)
	end
	if HasProperty("","InvitedBy") then
		local HostID = GetProperty("","InvitedBy")
		if GetAliasByID(HostID,"PartyHost") then
			if not GetHomeBuilding("PartyHost","PartyLocation") then
				StopMeasure()
			end
		end
	elseif not HasProperty("","Host") then
		StopMeasure()
	end
	local PartyTime
	if HasProperty("","Host") then
		if not GetHomeBuilding("","PartyLocation") then
			StopMeasure()
		end
	end
	PartyTime = GetProperty("PartyLocation","PartyDate")
	PartyTime = PartyTime / 60
	if HasProperty("","Host") then
		if not GetHomeBuilding("","PartyLocation") then
			StopMeasure()
		end
		
		if GetInsideBuilding("","CurrentBuilding") then
			if not (GetID("CurrentBuilding") == GetID("Destination")) then
				f_ExitCurrentBuilding("")
				if not f_MoveTo("","Destination") then
					StopMeasure()
				end
			end
			GetLocatorByName("PartyLocation","HostWelcome","HostWelcomePos")
			f_BeginUseLocator("","HostWelcomePos",GL_STANCE_STAND,true)
			
		else
			if not f_MoveTo("","Destination") then
				StopMeasure()
			end
			GetLocatorByName("PartyLocation","HostWelcome","HostWelcomePos")
			f_BeginUseLocator("","HostWelcomePos",GL_STANCE_STAND,true)
		end
	else
		if not HasProperty("","InvitedBy") then
			StopMeasure()
		end
		local HostID = GetProperty("","InvitedBy")
		if not GetAliasByID(HostID,"PartyHost") then
			StopMeasure()
		end
		if not GetHomeBuilding("PartyHost","PartyLocation") then
			StopMeasure()
		end
		if not GetOutdoorMovePosition("","PartyLocation","MovePos") then
			StopMeasure()
		end
		if not f_MoveTo("","MovePos") then
			StopMeasure()
		end
		if not GetFreeLocatorByName("PartyLocation","GuestArrive",1,6,"GuestArrivePos") then
			StopMeasure()
		end
		while GetGametime() < PartyTime do	
			if not GetState("PartyLocation",STATE_FEAST) then
				StopMeasure()
			end
			if not f_BeginUseLocator("","GuestArrivePos",GL_STANCE_STAND,true) then
				Sleep(5)
			else
				break
			end
		end
	end
	SetState("",STATE_LOCKED,true)
	
	while GetGametime() < PartyTime do
		Sleep(3)
		if Rand(100) < 50 then
			PlayAnimation("","cogitate")
		else
			PlayAnimation("","sentinel_idle")
		end
	end
	if not GetState("PartyLocation",STATE_FEAST) then
		StopMeasure()
	end
		
	if not SimSetBehavior("","Feast") then
		StopMeasure()
	end
	SetData("Start",1)
	StopMeasure()
end

function CleanUp()
	SetState("",STATE_LOCKED,false)
	if not HasData("Start") then
		if HasProperty("","InvitedBy") then
			RemoveProperty("","InvitedBy")
		end
		if AliasExists("PartyLocation") then
			for i=1,6 do
				if HasProperty("PartyLocation","Guest"..i) then
					if (GetProperty("PartyLocation","Guest"..i) == GetID("")) then
						RemoveProperty("PartyLocation","Guest"..i)
					end
				end
			end
		end
	end
end

