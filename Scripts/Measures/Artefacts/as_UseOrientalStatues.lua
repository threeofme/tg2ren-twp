function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if IsStateDriven() then
		local ItemName = "OrientalStatues"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	GetOutdoorMovePosition("","Destination","MovePos")
	if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN) then
		StopMeasure()
	end
	
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","manipulate_middle_twohand")
	if RemoveItems("","OrientalStatues",1)>0 then
		SetMeasureRepeat(TimeOut)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		AddImpact("Destination","Attractivity",0.15,-1)
		AddImpact("Destination","OrientalImprovementsActive",1,-1)
	end
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end