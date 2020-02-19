function Init()
end

function Run()
	while true do
		
		if GetDynasty("", "MyDynasty") then
			if DynastyIsPlayer("MyDynasty") then
				SetState("", STATE_CHECKFORSPINNINGS, false)
				return
			end
		end
		
		if GetState("", STATE_TOTALLYDRUNK) then
			SetState("", STATE_CHECKFORSPINNINGS, false)
			return
		end
		
		if GetState("", STATE_ANIMAL) then
			SetState("", STATE_CHECKFORSPINNINGS, false)
			return
		end
		
		if GetState("", STATE_CUTSCENE) then
			SetState("", STATE_CHECKFORSPINNINGS, false)
			return
		end
		
		if not f_SimIsValid("") then -- check for states
			SetState("", STATE_CHECKFORSPINNINGS, false)
			return
		end
		
		if GetImpactValue("", 360) > 0 then -- totallydrunk
			SetState("", STATE_CHECKFORSPINNINGS, false)
			return
		end
		
		if SimGetProfession("") == GL_PROFESSION_MYRMIDON then
			SetState("", STATE_CHECKFORSPINNINGS, false)
			return
		end
		
		if GetInsideBuildingID("") >= 0 then
			return
		else
			GetPosition("", "StartPos")
			Sleep(35)
			--slowly reduce cart HP while moving
--			if CartGetType("") > 0 then
--				local HPloss = -0.01 * GetMaxHP("") 
--				ModifyHP("", HPloss, false) 
--			end
			
			if GetInsideBuildingID("") == -1 then -- outside
				GetPosition("", "CheckPos")
				if GetState("", STATE_CHECKFORSPINNINGS) then
					if GetDistance("StartPos", "CheckPos") <= 120 then 
						if GetCurrentMeasureName("") == "WorldTrader" then
							MoveStop("")
							MeasureRun("", nil, "WorldTrader", true)
							return
						else
							MoveStop("")
							SimStopMeasure("")
							return
						end
					end
				else
					return
				end
			else
				return
			end
		end
	end
end
		
function CleanUp()
	if GetState("", STATE_CHECKFORSPINNINGS) then
		SetState("", STATE_CHECKFORSPINNINGS, false)
	end
end