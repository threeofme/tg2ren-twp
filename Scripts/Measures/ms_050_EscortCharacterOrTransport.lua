function Run()

	if not AliasExists("Destination") then
		return
	end

	local TimeOut
	local IsCityGuard = false
	if SimGetProfession("")==GL_PROFESSION_CITYGUARD then
		IsCityGuard = true
		TimeOut = 5
		SetData("Endtime"..GetID("Destination"),math.mod(GetGametime(),24)+5)
	end

	local fDistance = 300
	if IsType("Destination", "Cart") then
		fDistance = 600
	elseif IsType("Destination", "Ship") then
		fDistance = 900
	end
	
	local	DataValue
	local	Temp
	for l=0,4 do
		Temp = "EscortedBy_"..l
		if not HasProperty("Destination", Temp ) then
			DataValue = Temp
			break
		end
	end
	
	if not DataValue then
		return
	end
	
	SetData("Property", DataValue)
	SetProperty("Destination", DataValue, GetID(""))
	
	--ai timeout
	local TimeOut
	if SimGetWorkingPlace("", "MyWork") and DynastyIsAI("MyWork") then
		TimeOut = GetData("TimeOut") or 4
		if TimeOut then
			TimeOut = GetGametime() + TimeOut
		end
	end

	if IsCityGuard then
		f_FollowNoWait("","Destination", GL_MOVESPEED_RUN, fDistance)
		if math.mod(GetGametime(),24)>GetData("Endtime"..GetID("Destination")) then
			StopMeasure()
		end
	else
		while true do
			if TimeOut and TimeOut < GetGametime() then
				StopMeasure()
				return
			end
			
			if GetInsideBuilding("Destination", "InsideTarget") then
				if HasProperty("","CityBodyguard") or HasProperty("","KIbodyguard") then
					break
				end
				if GetInsideBuilding("","Inside") then
					if GetID("Inside") ~= GetID("InsideTarget") then
						if HasProperty("", "WaitBench") then
							RemoveProperty("", "WaitBench")
						end
						f_MoveTo("", "InsideTarget", GL_MOVESPEED_RUN)
					else
						if GetInsideRoom("", "MyRoom") and GetInsideRoom("Destination", "DesRoom") then
							if GetID("MyRoom") == GetID("DesRoom") then
								if BuildingGetType("Inside") == GL_BUILDING_TYPE_TOWNHALL then -- sit down in townhall
									if BuildingGetRoom("Inside","Judge","Room") then
										if GetID("Room") == GetID("MyRoom") then
											if not HasProperty("", "WaitBench") then
												if GetFreeLocatorByName("Inside","tablechair",16,11,"SitPos") then
													if f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true) then
														SetProperty("", "WaitBench", 1)
													end
												end
											else
												Sleep(2)
											end
										end
									end
								end
							else
								if HasProperty("", "WaitBench") then
									f_EndUseLocator("","SitPos",GL_STANCE_STAND)
									RemoveProperty("", "WaitBench")
								end
								if not f_Follow("","Destination", GL_MOVESPEED_RUN, fDistance, true) then
									Sleep(1)
								end
							end
						else
							if Rand(12)== 0 then
								f_Stroll("", 400, 2)
							end
						end
						Sleep(3)
					end
				else
					if HasProperty("", "WaitBench") then
						f_EndUseLocator("","SitPos",GL_STANCE_STAND)
						RemoveProperty("", "WaitBench")
					end
					f_MoveTo("", "InsideTarget", GL_MOVESPEED_RUN)
				end
			else
				if HasProperty("", "WaitBench") then
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
					RemoveProperty("", "WaitBench")
				end
				if not f_Follow("","Destination", GL_MOVESPEED_RUN, fDistance, true) then
					Sleep(1)
				end
			end
			Sleep(2)
		end
		if HasProperty("", "WaitBench") then
			f_EndUseLocator("","SitPos",GL_STANCE_STAND)
			RemoveProperty("", "WaitBench")
		end
		return
	end
	
end

function CleanUp()
	local	DataValue = GetData("Property")
	if DataValue then
		RemoveProperty("Destination", DataValue)
	end
	if AliasExists("Destination") and HasProperty("Destination","KIbodyguard") then
		if GetProperty("Destination","KIbodyguard")>1 then
			SetProperty("Destination","KIbodyguard",1)
		else
			RemoveProperty("Destination","KIbodyguard")
		end
	end
	if HasProperty("","CityBodyguard") then
		RemoveProperty("","CityBodyguard")
	end
end

