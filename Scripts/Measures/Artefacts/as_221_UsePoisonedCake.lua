function Run()

	if IsStateDriven() then
		local ItemName = "PoisonedCake"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 120
	--Time before artefact can be used again

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local duration = mdata_GetDuration(MeasureID)
	
	local skillmodify = -2
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--look at each other and play the animations
	MsgMeasure("Destination","")
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(0.5)
	
	local time1
	local time2
	time1 = PlayAnimationNoWait("Owner", "use_object_standing")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Anim_cake.nif",false)
	
	Sleep(1)
	CarryObject("","",false)
	CarryObject("Destination","Handheld_Device/Anim_cake.nif",false)
	time2 = PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(1)
	StopAnimation("")
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Destination","",false)
	PlayFE("Destination", "smile", 0.5, 2, 0)
	Sleep(1)
	
	--modify the skills
	if RemoveItems("","PoisonedCake",1)>0 then
		AddImpact("","Fighting",-skillmodify,duration)
		AddImpact("","dexterity",-skillmodify,duration)
		
		--show overhead text
		feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+1", false, 
			"@L_TALENTS_fighting_ICON_+0", "@L_TALENTS_fighting_NAME_+0", skillmodify)
		Sleep(1)
		
		--show overhead text
		feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+1", false, 
			"@L_TALENTS_dexterity_ICON_+0", "@L_TALENTS_dexterity_NAME_+0", skillmodify)	
		
		feedback_MessageCharacter("Destination",
				"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_HEAD_+0",
				"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_BODY_+0", GetID("Destination"))
	
		--remove item from inventory and add db impact
		
		chr_GainXP("",GetData("BaseXP"))
		SetMeasureRepeat(TimeOut)
		Sleep(2)
		StopMeasure()
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	feedback_OverheadActionName("Destination")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end


