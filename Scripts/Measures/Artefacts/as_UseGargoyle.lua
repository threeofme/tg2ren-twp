-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseGargoyle"
----
----	with this artifact, the player upgrade his church temporarily
----
-------------------------------------------------------------------------------
function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	if BuildingGetType("Destination")==GL_BUILDING_TYPE_TOWER then
		StopMeasure()
	elseif not (BuildingGetType("Destination")==GL_BUILDING_TYPE_CHURCH_EV or BuildingGetType("Destination")==GL_BUILDING_TYPE_CHURCH_CATH) then
		MsgBoxNoWait("","Destination","@L_GENERAL_ERROR_HEAD","@L_MEASURE_USEGARGOYLE_ERROR")
		StopMeasure()
	end
	
	if IsStateDriven() then
		local ItemName = "Gargoyle"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				StopMeasure()
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not GetFreeLocatorByName("Destination","ChangeFaith",-1,-1,"MovePos") then
		StopMeasure()
	end
	if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN,20) then
		StopMeasure()
	end
	Sleep(0.5)
	
	-- Commit the action
	if RemoveItems("","Gargoyle",1)>0 then
		
		PlayAnimation("","manipulate_middle_twohand")
		
		SetMeasureRepeat(TimeOut)
		MsgNewsNoWait("Destination","","","building",-1,
						"@L_ARTEFACTS_USE_GARGOYLE_HEAD_+0",
						"@L_ARTEFACTS_USE_GARGOYLE_BODY_+0",GetID(""),GetID("Destination"))
		SetState("Destination",STATE_CONTAMINATED,true)
		AddImpact("Destination","gargoyle",1,duration)
		chr_GainXP("",GetData("BaseXP"))
	end
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

