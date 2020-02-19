function Run()

	if not SquadGet("", "Squad") then
		return
	end
	if not SimGetWorkingPlace("","Base") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_MERCENARY)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Base")
		else
			StopMeasure()
		end
	end
	if not AliasExists("Base") then
		return
	end
	if not HasProperty("Squad", "Victim") then
		return 
	end
	
	local	TargetID = GetProperty("Squad", "Victim")
	if TargetID < 1 then
		return 
	end	
	
	if not GetAliasByID(TargetID, "Victim") then
		return 
	end

	
	while true do
		if not ms_squadrazziamember_Check() then
			break
		end
		Sleep(Rand(20)*0.1+2)
	end
end

function Check()

	if GetState("Victim",STATE_BUILDING) or GetState("Victim",STATE_LEVELINGUP) then
		return false
	end

	if GetState("Victim",STATE_BURNING) then
		return false
	end
	
	if not ms_squadrazziamember_Attack() then
        return false
    end		
	SetRepeatTimer("Base", GetMeasureRepeatName2("Razzia"), 24)
	
	return true
end

function Attack()

    if not MeasureRun("","Victim","Razzia",true) then
		return false
	end

	return true
end



function CleanUp()
	MoveSetActivity("","")

	SquadRemoveMember("", true)
	if AliasExists("Squad") then
		if SquadGetMemberCount("Squad", true)<1 then
			SquadDestroy("Squad")
			return
		end
	end
	
end



