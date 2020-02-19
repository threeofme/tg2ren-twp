function Run()

	if IsStateDriven() then
		local ItemName = "InvisiblePotion"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,100) then
		StopMeasure()
	end

	Time = PlayAnimationNoWait("","manipulate_middle_twohand")
	Sleep(3)
	if GetImpactValue("Destination","Invisible")<1 then
		if RemoveItems("","InvisiblePotion",1)>0 then
			PlaySound3D("","Locations/papermaking+0.wav", 1.0)
			Sleep(Time-3)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			SetMeasureRepeat(TimeOut)				
			AddImpact("Destination","Invisible",1,duration) 
			
			chr_GainXP("",GetData("BaseXP"))
		end
	else
		if DynastyIsPlayer("") then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_ARTEFACT_FAIL_+0", GetID("Destination"))
		end
	end
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end


