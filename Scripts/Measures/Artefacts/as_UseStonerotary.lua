function Run()
	
	local ItemName = "Stonerotary"
	
	if IsStateDriven() then
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MaxDistance = 2000
	local ActionDistance = 130
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end	

	StopAnimation("Destination")
	AlignTo("", "Destination")
	AlignTo("Destination", "")

	local time1
	local time2
	time1 = PlayAnimationNoWait("", "use_object_standing")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
		
	Sleep(1)

	CarryObject("","",false)
	CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
	time2 = PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(1)	
	StopAnimation("")
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Destination","",false)	
	
	if RemoveItems("",ItemName,1)>0 then	
		SetMeasureRepeat(TimeOut)
		MeasureSetNotRestartable()
		-- Check if we are happy or not to receive that kind of toy
		if GetImpactValue("Destination","ToyKreisel")>0 then
			PlayAnimationNoWait("Destination","shake_head")
			MsgSay("Destination","@L_MEASURE_TOYKREISEL_REJECT_FIRST")
			Sleep(1.5)
			PlayAnimationNoWait("Destination","cogitate")
			MsgSay("Destination","@L_MEASURE_TOY_REJECT_SECOND")
		else
			local random = Rand(101) + 100
			chr_GainXP("Destination",random)
			AddImpact("Destination", "ToyKreisel", 1, 24)
			if SimGetGender("")==GL_GENDER_FEMALE then
				MsgSayNoWait("Destination","@L_MEASURE_TOY_CHEER_MOM")
			else
				MsgSayNoWait("Destination","@L_MEASURE_TOY_CHEER_DAD")
			end
			local DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
			Sleep(DestinationAnimationLength * 0.4)
		end
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

function CleanUp()
	CarryObject("","",false)
	CarryObject("Destination","",false)
	StopAnimation("")
	StopAnimation("Destination")
end
