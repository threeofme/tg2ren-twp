function Run()
	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")

	if not GetProperty("WarChooser","WarPhase")==1 then
		StopMeasure()
	end

	local Count = Find("", "__F((Object.GetObjectsByRadius(Building)==2000)AND(Object.IsType(27))AND(Object.Property.prewar>0))","Arsenal", -1)
	
	if Count < 1 then
		StopMeasure()
	end
	
	CopyAlias("Arsenal0", "Arsenal")
	GetSettlement("Arsenal", "City")
	GetSettlement("", "settlement")
	if not GetID("City") == GetID("settlement") then
		MsgBoxNoWait("","Arsenal","@L_GENERAL_ERROR_HEAD_+0","@L_TRAVELARSENAL_FAILURE_+0",GetID("settlement"))
		StopMeasure()
	end

	local choice
	local Officers = GetProperty("Arsenal", "officers")
	if not Officers then
		Officers = 0
	end
	local count = Officers
	local enemy = GetProperty("WarChooser","WarEnemy")

	for i=1,Officers do
		if HasProperty("Arsenal", "officer"..i) then
			count = count - 1
		end
	end

	if count < 1 then
		MsgBoxNoWait("","Arsenal","@L_GENERAL_ERROR_HEAD_+0","@L_TRAVELARSENAL_FAILURE_+2",GetID("settlement"))
		StopMeasure()
	end

	if IsStateDriven() then
		
		--!!!!!!!!!!!!!!!!!!
		
	else
		choice = MsgBox("", "", "@P@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
							"@B[0,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
							"@L_TRAVELARSENAL_HIRE_MAIN_HEAD_+0",
							"@L_TRAVELARSENAL_HIRE_MAIN_BODY_+0",
							"@L_SCENARIO_WAR_"..enemy.."_+0",GetID("City"),count,GetID(""))

		if (choice==1) then
			if not GetProperty("WarChooser","WarPhase")==1 then
				MsgBoxNoWait("","Arsenal","@L_GENERAL_ERROR_HEAD_+0","@L_TRAVELARSENAL_FAILURE_+1")
				StopMeasure()
			else
				count = 0
				for i=1,Officers do
					if HasProperty("Arsenal", "officer"..i) then
						count = count - 1
					else
						SetProperty("Arsenal", "officer"..i, GetID(""))
						SetProperty("", "officer", 1)
						SetProperty("", "AtWar",1)
						-- ForbidMeasure("", "ToggleInventory", EN_BOTH)
						SetState("",STATE_LOCKED,true)
						SetState("",STATE_GLOBALTRAVELLING,true)
						GetDynasty("", "family")
						local power = GetSkillValue("", "rhetoric") * GetSkillValue("", "fighting") + 3*GetSkillValue("", "secret_knowledge")
						if HasProperty("family", "WarLandNo") then
							local familypower = GetProperty("family", "WarLandNo") + power
							SetProperty("family", "WarLandNo", familypower)
						else
							SetProperty("family", "WarLandNo", power)
						end
						local totalpower = GetProperty("WarChooser","WarLandNo") + power
						SetProperty("WarChooser","WarLandNo", totalpower)
						MsgBoxNoWait("","Aresnal","@L_MEASURE_TravelArsenal_NAME_+0","@L_TRAVELARSENAL_MSG_+0",GetID(""),GetID("settlement"))
						StopMeasure()
					end
				end
				if count < 1 then
					MsgBoxNoWait("","Arsenal","@L_GENERAL_ERROR_HEAD_+0","@L_TRAVELARSENAL_FAILURE_+2",GetID("settlement"))
					StopMeasure()
				end
			end
		else
			StopMeasure()
		end

	end

end

function CleanUp()
end
