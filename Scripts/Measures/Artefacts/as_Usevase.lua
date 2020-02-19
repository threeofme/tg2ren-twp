-------------------------------------------------------------------------------
----
----	OVERVIEW "as_Usevase.lua"
----	This item boosts the buildings attracitiveness
----
-------------------------------------------------------------------------------

function Run()

	local Item = "vase"
	local ObjectLabel = ItemGetLabel(Item, true)
	local choice
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = GetDatabaseValue("Measures",MeasureID,"repeat_time")
	local Duration = GetDatabaseValue("Measures",MeasureID,"duration")

	if IsStateDriven() then
		choice = 0
	else
		choice = MsgBox("", "", "@P@B[0,@LJa_+0]"..
							"@B[1,@LNein_+0]",
							"@L_USE_vase_HEAD_+0",
							"@L_USE_vase_BODY_+0",
							ObjectLabel, GetID(""))
	end
	
	if choice == 0 then
		
		if GetImpactValue("","Vase")>0 then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD","@L_USE_vase_FAIL_BODY_+0",ObjectLabel,GetID(""))
		else
			if RemoveItems("",Item,1)>0 then
				MsgBoxNoWait("","","@L_USE_vase_MESSAGE_HEAD_+0","@L_USE_vase_MESSAGE_BODY_+0",ObjectLabel,GetID(""))
				SetMeasureRepeat(TimeOut)
				AddImpact("","Attractivity",0.05,Duration)
				AddImpact("","Vase",1,Duration)
			else
				StopMeasure()
			end
		end
	end
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end


function CleanUp()
end
