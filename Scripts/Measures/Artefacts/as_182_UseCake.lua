-------------------------------------------------------------------------------
----
----	OVERVIEW "as_182_UseCake"
----
----	with this artifact, the player can increase the favor of an character
----	towards himself
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "Cake"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 30
	--Time before artefact can be used again

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not f_MoveTo("", "Destination",GL_MOVESPEED_RUN, 50) then 
		if not f_MoveTo("", "Destination",GL_MOVESPEED_WALK, 50) then
			return
		end
	end
	
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
	--modify the favor	
	if RemoveItems("","Cake",1)>0 then
		local favormodify = ((100 - math.ceil(GetFavorToSim("Destination","Owner")))/4)
		chr_ModifyFavor("Destination","",favormodify)
		
		MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_ARTEFACTS_182_USECAKE_MSG_VICTIM_HEAD_+0",
				"@L_ARTEFACTS_182_USECAKE_MSG_VICTIM_BODY_+0", GetID("Destination"), GetID(""))
		
		SetMeasureRepeat(TimeOut)
		Sleep(0.4)
		chr_GainXP("",GetData("BaseXP"))
		Sleep(2)
		-- Fajeth Mod: Caries chance and Movespeed
		local caries = 1
		local ill = 1+Rand(10)
		if GetImpactValue("Destination","Sugar")==0 then
			AddImpact("Destination","MoveSpeed",1.25,6)
			AddImpact("Destination","Sugar",1,6)
		end
		-- get sick if you are unlucky and have no protection.
		if caries>=ill then
			if GetImpactValue("Destination","Sickness")==0 and GetImpactValue("Destination","Resist")==0 then
				diseases_Caries("",true)
				MsgSay("Destination", "_EATDRINK_SPRUCH_+3")
			end
		end
		Sleep(1)
		-- Mod end
	end
	StopMeasure()
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
	--active time immediately
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+1",Gametime2Total(mdata_GetDuration(MeasureID)))
end

