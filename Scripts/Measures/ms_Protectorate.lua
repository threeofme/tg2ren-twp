
function Init() 
	CopyAlias("Destination","Protectorate")
	MsgMeasure("","")
end

function AIInit()
end

function Run()
	SimResetBehavior("")

	--ai timeout
	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end
	
	if IsType("Protectorate","Building") then		
		GetOutdoorMovePosition("", "Destination", "MoveTarget")
	else
		CopyAlias("Protectorate","MoveTarget")
	end
	
	if not f_MoveTo("", "MoveTarget", GL_MOVESPEED_RUN, 10) then
		StopMeasure()
	end
		
	while true do
	
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
		
		--for the ai
		if not AliasExists("Protectorate") then
			if (GetOutdoorMovePosition("", "Destination", "Target")) then
				if not (f_MoveTo("", "Target", GL_MOVESPEED_RUN, 200)) then
					return
				end
			end
			f_Stroll("", 500, 20)
			return
		else
			--if Protectorate is building
			if IsType("Protectorate","Building") then
					
				for k=1, 4 do
					if GetLocatorByName("Protectorate", "Walledge"..k, "VictimsCorner"..k) then
						f_MoveTo("", "VictimsCorner"..k, GL_MOVESPEED_RUN, 10)
					end
					Sleep(Rand(7)+1)
				end
			else
				
				--f_Stroll("", 500, 20)
				local Target = ms_protectorate_Scan()
				if Target then
					local MercLevel = SimGetLevel("")
					local VictimLevel = SimGetLevel(Target)
					local HeadMoney	= (MercLevel * 100) + (VictimLevel * 200)
					GetPosition("Protectorate", "Position")
					SetProperty("", "Protectorate", "Position")
					SetProperty("", "Victim", GetID("Victim"))
					SetProperty("", "HeadMoney", HeadMoney)
					SimSetBehavior("","MercAttack")
					MeasureRun("","Victim","AttackEnemy",true)
				end
			end
		end
		Sleep(Rand(10)+1)
	end
end

function Scan()
	
	-- constants
	local NumOfObjects = Find("","__F( (Object.GetObjectsByRadius(Sim)==1000) AND NOT(Object.BelongsToMe()) AND((Object.GetProfession() == 15)OR (Object.GetProfession() == 18)OR (Object.GetProfession() == 19)OR (Object.GetProfession() == 26)OR (Object.GetProfession() == 30)) AND NOT(Object.GetState(cutscene))AND NOT(Object.GetState(townnpc))AND(Object.MinAge(16)))","Sims",-1)

	if NumOfObjects <= 0 then
		return
	end
		
	for FoundObject=0,NumOfObjects-1 do
		if DynastyGetDiplomacyState("Dynasty","Sims"..FoundObject)<=DIP_NEUTRAL then
			
			if GetCurrentMeasureName("Sims"..FoundObject)=="PickpocketPeople" and SimGetProfession("Sims"..FoundObject)==GL_PROFESSION_THIEF then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="ScoutAHouse" and SimGetProfession("Sims"..FoundObject)==GL_PROFESSION_THIEF then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="WaylayForBooty" and SimGetProfession("Sims"..FoundObject)==GL_PROFESSION_ROBBER then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="PressProtectionMoney" and SimGetProfession("Sims"..FoundObject)==GL_PROFESSION_ROBBER then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="OrderASabotage_Bomb" and SimGetProfession("Sims"..FoundObject)==GL_PROFESSION_MYRMIDON then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="OrderASabotage_CombustionBomb" and SimGetProfession("Sims"..FoundObject)==GL_PROFESSION_MYRMIDON then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="AssignToLaborOfLove" and SimGetProfession("Sims"..FoundObject)==30 then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="AssignToThiefOfLove" and SimGetProfession("Sims"..FoundObject)==30 then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			elseif GetCurrentMeasureName("Sims"..FoundObject)=="AssignToPoisonEnemy" and SimGetProfession("Sims"..FoundObject)==30 then 
				CopyAlias("Sims"..FoundObject,"Victim")
				return "Victim"
			end
		end
	end

	Sleep(Rand(4) + 1)

	return
end


function CleanUp()
end

