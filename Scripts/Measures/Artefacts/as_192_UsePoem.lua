-------------------------------------------------------------------------------
----
----	OVERVIEW "as_192_UsePoem"
----
----	with this artifact, the player can increase the favour of the destination
----	if the wealth is lower or same or 1 level Higher as the owner. favor of sims of the 
----	same gender will not raise.
----	
----
-------------------------------------------------------------------------------

function Run()
	if (GetState("", STATE_CUTSCENE)) then
		as_192_usepoem_Cutscene()
	else
		as_192_usepoem_Normal()
	end
end

function Normal()

	if IsStateDriven() then
		if (HasProperty("","HaveCutscene") == true) then
			return
		end
		local ItemName = "Poem"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	if not AliasExists("Destination") then
		StopMeasure()
	end

	--how much the favor of the destination to the owner is increased
	local favormodify = 10
	--how far the victim can be to start this action
	local MaxDistance = 800
	--how far from the destination, the owner should stand while reading the poem
	local ActionDistance = 80
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	
	if (SimGetGender("Owner") == SimGetGender("Destination")) then
		MsgQuick("", "@L_GIVEAPOEM_MESSAGE_FAILURES_+0")
		StopMeasure()
	end

	if GetNobilityTitle("Destination") > (GetNobilityTitle("Owner")+2) then
		MsgQuick("", "@L_GIVEAPOEM_MESSAGE_FAILURES_+1",GetID("Destination"))
		StopMeasure()
	end
		
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--look at each other
	feedback_OverheadActionName("Destination")
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(0.5)
	
	local IsMarried = SimGetSpouse("")
	local DesFamilyName = SimGetLastname("Destination")
	local OwnFamilyName = SimGetLastname("")
	
	SimGetBeloved("", "Beloved")
	if GetID("Beloved") == GetID("Destination") then
		InLove = true
	else
		InLove = false
	end

	--read the poem
	local Time
	Time = PlayAnimationNoWait("","use_book_standing")
	PlayAnimationNoWait("Destination","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Anim_openscroll.nif",false)
	Sleep(1)
	MsgSayNoWait("", chr_SpeakPoem(SimGetGender("Destination"),IsMarried,InLove,DesFamilyName,OwnFamilyName));
	Sleep(Time-3)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	
	if RemoveItems("","Poem",1)>0 then
		--modify the favor
		chr_ModifyFavor("Destination","",favormodify)
		
		local CurrentSimGender = SimGetGender("Destination")
		if CurrentSimGender == GL_GENDER_FEMALE then
			PlayAnimation("Destination","curtsy")
		else
			PlayAnimation("Destination","bow")
		end
	
		if(IsDynastySim("Destination")) then
			MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_ARTEFACTS_192_USEPOEM_MSG_VICTIM_HEAD_+0",
				"@L_ARTEFACTS_192_USEPOEM_MSG_VICTIM_BODY_+0", GetID("Destination"), GetID(""))
		end
	
		SetRepeatTimer("", GetMeasureRepeatName2("UsePoem"), TimeOut)
		chr_GainXP("",GetData("BaseXP"))
		
		Sleep(2)
	end
	StopMeasure()

end


function Cutscene()

	--how much the favor of the destination to the owner is increased
	local favormodify = 10
	--how far the victim can be to start this action
	local MaxDistance = 3000
	--how far from the destination, the owner should stand while reading the poem
	local ActionDistance = 35
	--time before artefact can be used again, in hours
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	TimeOut = TimeOut - (chr_ArtifactsDuration("Owner",TimeOut))
	
	
	
	
	if (SimGetGender("Owner") == SimGetGender("Destination")) then
		MsgQuick("", "@L_GIVEAPOEM_MESSAGE_FAILURES_+0")
		StopMeasure()
	end

	if not(SimGetRank("Destination") <= (SimGetRank("Owner")+1)) then
		MsgQuick("", "@L_GIVEAPOEM_MESSAGE_FAILURES_+1",GetID("Destination"))
		StopMeasure()
	end
	
	
	local IsMarried = SimGetSpouse("")
	local DesFamilyName = SimGetLastname("Destination")
	local OwnFamilyName = SimGetLastname("")
	
	SimGetBeloved("", "Beloved")
	if GetID("Beloved") == GetID("Destination") then
		InLove = true
	else
		InLove = false
	end

	--modify the favor
	if RemoveItems("","Poem",1)>0 then
		chr_ModifyFavor("Destination","",favormodify)
		
		if SimGetCutscene("","cutscene") then
			CutsceneCallUnscheduled("cutscene", "UpdatePanel")
			Sleep(0.1)
		else
			return
		end		
		
		if(IsDynastySim("Destination")) then
			MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_ARTEFACTS_192_USEPOEM_MSG_VICTIM_HEAD_+0",
				"@L_ARTEFACTS_192_USEPOEM_MSG_VICTIM_HEAD_+0", GetID("Destination"), GetID(""))
		end
	
		SetRepeatTimer("", GetMeasureRepeatName2("UsePoem"), TimeOut)
		chr_GainXP("",GetData("BaseXP"))
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

