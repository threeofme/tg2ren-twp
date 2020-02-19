-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseGravestone.lua"
----
----	with this artifact, the player upgrade his church temporarily
----
-------------------------------------------------------------------------------
function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	if not (BuildingGetType("Destination")==GL_BUILDING_TYPE_NEKRO) then
		MsgBoxNoWait("","Destination","@L_GENERAL_ERROR_HEAD","@L_MEASURE_USEGRAVESTONE_ERROR_+0")
		StopMeasure()
	end
	
	local GraveID = GetImpactValue("Destination","Gravestone")
	if GraveID>0 then
		GetAliasByID(GraveID,"Family")
		MsgBoxNoWait("","Destination","@L_GENERAL_ERROR_HEAD","@L_MEASURE_USEGRAVESTONE_ERROR_+1",GetID("Family"))
		StopMeasure()
	end
	
	if IsStateDriven() then
		local ItemName = "Gravestone"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				StopMeasure()
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,20) then
		StopMeasure()
	end
	Sleep(0.5)
	
	-- Commit the action
	if RemoveItems("","Gravestone",1)==1 then
		
		SetMeasureRepeat(TimeOut)
		MsgNewsNoWait("Destination","","","building",-1,
						"@L_ARTEFACTS_USEGRAVESTONE_HEAD_+0",
						"@L_ARTEFACTS_USEGRAVESTONE_BODY_+0",GetID(""),GetID("Destination"))
		AddImpact("Destination","Gravestone",(GetID("")),duration)
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

