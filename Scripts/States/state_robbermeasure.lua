function Init()
end

function Run()
	while true do
		-- AI has no need of this and seems to get bugged with it
		if IsDynastySim("") and DynastyIsAI("") then
			SetState("", STATE_ROBBERMEASURE, false)
			break
		else
			if SimGetWorkingPlace("", "MyWork") then
				if BuildingGetOwner("MyWork", "MyBoss") then
					if DynastyIsAI("MyBoss") then
						SetState("", STATE_ROBBERMEASURE, false)
						break
					end
				end
			end
		end
		
		if GetCurrentMeasureName("") == "Idle" or GetCurrentMeasureName("") == "DoNothing" then
			if not BattleIsFighting("") then
				if SimGetBehavior("") == "SquadWaylayMember" then
					SimResetBehavior("")
				end
				Sleep(0.5)
				if SquadGet("", "Squad") and SquadGetMeetingPlace("Squad", "Dest") then
					MeasureRun("", "Dest", "WaylayForBooty", false)
					return
				else
					-- find next outdoor locator
					local Count = GetOutdoorLocator("ambush", -1, "Ambush")
					if (Count==0) or (Count==nil) then
						GetPosition("", "MyPos")
					else
					
						local	Alias
						local	Dist = -1
						local Location = nil
						local BestDist = 99999
					
						for i=0,Count-1 do
							Alias = "Ambush"..i
							Dist = GetDistance("", Alias)
							if Dist < 15000 then
								if not Location or Dist < BestDist then
									Location = Alias
									BestDist = Dist
								end
							end
						end
						
						if Location ~= nil then
							CopyAlias(Location, "MyPos")
						else
							GetPosition("", "MyPos")
						end
					end
	
					MeasureRun("", "MyPos", "WaylayForBooty", false)
					return
				end
			end
		end
		Sleep(15)	
	end
end
		
function CleanUp()
end