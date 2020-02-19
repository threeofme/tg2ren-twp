-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_070_ScoutAHouse"
----
----	with this measure, the player can send a thief, to spy an building
----
-------------------------------------------------------------------------------

-- halfed scount duration

function Run()
	if not IsGUIDriven() then  
		local DynID = GetDynastyID("")
		SetProperty("Destination","AIScouted"..DynID,1)
	end
	
	--get the shadow art skill from the thief
	local Skill = GetSkillValue("","6")
	
	--time needed to spy out the building, 0.125 to 1 hours
	local Time = 0.25
	if Skill == 10 then
		Time = 0.125
	elseif Skill > 7 then
		Time = 0.25
	elseif Skill > 5 then
		Time = 0.5
	else
		Time = 1
	end
	SetData("Time",Time)
	--move to the building
	f_MoveTo("","Destination",GL_MOVESPEED_RUN,100)
	StartGameTimer(Time)
	local StartTime = GetGametime()
	local EndTime = StartTime + Time
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("",Time*10)
	--hide the thief
	SetState("",STATE_HIDDEN,true)
	SendCommandNoWait("","Progress")
	
	--do the visual stuff
	while not (CheckGameTimerEnd()) do
		
		if not AliasExists("Destination") then
			StopMeasure()
		end
		for i=1, 3 do
			if GetLocatorByName("Destination", "Walledge"..i, "VictimsCorner"..i) then
				f_MoveTo("", "VictimsCorner"..i, GL_MOVESPEED_WALK, 100)
				if CheckGameTimerEnd() then
					break
				end
				AlignTo("","Destination")
				Sleep(Rand(3))
			end
		end
		if CheckGameTimerEnd() then
			break
		end
		if Rand(100) < 75 then
			GetFleePosition("","Destination",500,"FleePosition")
			f_MoveTo("","FleePosition")
			PlayAnimation("","watch_for_guard")
			Sleep(1)
		end	
	end
	
	--combine the textlabels 
	local ProtectionClass = chr_GetBuildingProtFromBurglaryLevel("Destination")	
	local ProtectionLabel = "_REPLACEMENTS_PROTECTION_+"..ProtectionClass	
	
	local LootClass = chr_GetBuildingLootLevel("Destination", GetID("Dynasty") )
	local ValueLabel = "_REPLACEMENTS_HAUL_+"..LootClass
	
	local OwnerDyn = GetDynastyID("")
	local VictimID = GetID("Destination")

	SetProperty("Destination","ScoutedBy"..OwnerDyn,1)
	SetProperty("Destination","ScoutedProt"..OwnerDyn,ProtectionClass)
	SetProperty("Destination","ScoutedLoot"..OwnerDyn,LootClass)
	local scriptcall = "ScoutAHouse"..OwnerDyn.."_ExpireValues"..VictimID
	
	-- remove old existing expirycall to avoid lost update
	RemoveScriptcall(scriptcall)
		
	local bSuccess =  GetDynasty("", "Dyn")
	if (bSuccess) then
		local iFlagID = DynastyGetFlagNumber("Dyn")
		AddImpact("Destination", "Scouted", iFlagID , -1)
		chr_GainXP("",GetData("BaseXP"))
	end	
	
	CreateScriptcall(scriptcall,48,"Measures/ms_070_ScoutAHouse.lua","ExpireValues","Owner","Destination",OwnerDyn)
	
	--message to thief owner
	feedback_MessageCharacter("Owner",
		"@L_THIEF_070_SCOUTAHOUSE_MSG_ACTOR_HEAD_+0",
		"@L_THIEF_070_SCOUTAHOUSE_MSG_ACTOR_BODY_+0",GetID("Destination"),ProtectionLabel,ValueLabel)

	--stop hiding
	ResetProcessProgress("")
	SetState("",STATE_HIDDEN,false)
	StopMeasure()
end

function Progress()
	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime")
		local CurrentTime = GetGametime()
		CurrentTime = EndTime - CurrentTime
		CurrentTime = Time - CurrentTime
		SetProcessProgress("",CurrentTime*10)
		Sleep(3)
	end
end

function ExpireValues(OwnerDyn)
	if AliasExists("Destination") then
		RemoveProperty("Destination","ScoutedBy"..OwnerDyn)
		RemoveProperty("Destination","ScoutedProt"..OwnerDyn)
		RemoveProperty("Destination","ScoutedLoot"..OwnerDyn)
		RemoveImpact("Destination", "Scouted")
	end
end

function CleanUp()
	ResetProcessProgress("")

	local DynID = GetDynastyID("")
	if AliasExists("Destination") then
		RemoveProperty("Destination","AIScouted"..DynID)
	end
	
	--stop hiding
	SetState("",STATE_HIDDEN,false)
end

