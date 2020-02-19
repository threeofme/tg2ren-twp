function Run()

	if IsStateDriven() then
		local ItemName = "HolyWater"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	if not GetPosition("Destination","MovePos") then
		StopMeasure()
	end
	if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN,175) then
		StopMeasure()
	end
	AlignTo("","Destination")
	Sleep(2)
	Time = PlayAnimationNoWait("","manipulate_middle_twohand")
	Sleep(4)
	if RemoveItems("","HolyWater",1)>0 then
		SetMeasureRepeat(TimeOut)
		StartSingleShotParticle("particles/elixirofpurgation.nif","MovePos",1,7)
		PlaySound3D("","measures/putoutfire/putoutfire+1.wav", 1.0)
		Sleep(Time-4)
		RemoveImpact("Destination","polluted")
		SetState("Destination",STATE_CONTAMINATED,false)
		-- Fajeth Mod
		RemoveProperty("Destination","PollutedWell")
		-- Mod end
		chr_GainXP("",GetData("BaseXP"))
	end
end




function CleanUp()

	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


