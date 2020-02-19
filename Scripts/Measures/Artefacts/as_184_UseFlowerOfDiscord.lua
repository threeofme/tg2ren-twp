-------------------------------------------------------------------------------
----
----	OVERVIEW "as_184_UseFlowerOfDiscord"
----
----	with this artifact, the player can decrease the favor of two persons
----	to each other
----
-------------------------------------------------------------------------------

function Init()
	if not AliasExists("Believer") then
		InitAlias("Believer",MEASUREINIT_SELECTION, "__F( NOT(Object.BelongsToMe())AND(Object.Type == Sim)AND(Object.IsDynastySim()))",
			"@L_ARTEFACTS_184_USEFLOWEROFDISCORD_TARGET2_+0",AIInit)
	end
	MsgMeasure("","")
end

function AIInit()
end

function Run()

	if IsStateDriven() then
		local ItemName = "FlowerOfDiscord"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	if not AliasExists("Destination") or not AliasExists("Believer") then
		StopMeasure()
	end

	--how far the destination can be to start this action
	local MaxDistance = 800
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 80
	--how much the favor is decreased, in percent
	local FavorPercent = 20
	

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if GetID("Believer") == GetID("Destination") then
		StopMeasure()
	end
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Believer", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	MeasureSetNotRestartable()
	--look at each other and play anims
	feedback_OverheadActionName("Believer")
	feedback_OverheadActionName("Destination")
	AlignTo("Owner", "Believer")
	AlignTo("Believer", "Owner")
	Sleep(1)
	
	time1 = PlayAnimationNoWait("Owner", "talk")
	Sleep(0.7)
	time2 = PlayAnimationNoWait("Believer", "talk")
	time1 = math.max(time1, time2)
	Sleep(time1)
	if RemoveItems("","FlowerOfDiscord",1)>0 then
		CommitAction("poison", "", "Destination", "Destination")
		GetPosition("Believer", "ParticleSpawnPos")
		StartSingleShotParticle("particles/flowerofdiscord.nif", "ParticleSpawnPos",2.7,5)
		PlaySound3D("Believer","Locations/destillery/destillery+0.wav", 1.0)
		
		SetMeasureRepeat(TimeOut)
		
		--modify the favor
	--	local DestinationFavorModify = ((FavorPercent/100)*GetFavorToSim("Destination","Believer"))
		local BelieverFavorModify = ((FavorPercent/100)*GetFavorToSim("Believer","Destination"))
		
		chr_ModifyFavor("Believer","Destination",-BelieverFavorModify)
		--chr_ModifyFavor("Destination","Believer",-DestinationFavorModify)
		
		
		MsgNewsNoWait("Destination","Believer","","intrigue",-1,
				"@L_ARTEFACTS_184_USEFLOWEROFDISCORD_MSG_VICTIM_HEAD_+0",
				"@L_ARTEFACTS_184_USEFLOWEROFDISCORD_MSG_VICTIM_BODY_+0", GetID("Believer"), GetID("Destination"))
				
		MsgNewsNoWait("Believer","Destination","","intrigue",-1,
				"@L_ARTEFACTS_184_USEFLOWEROFDISCORD_MSG_VICTIM_HEAD_+0",
				"@L_ARTEFACTS_184_USEFLOWEROFDISCORD_MSG_VICTIM_BODY_+0", GetID("Destination"), GetID("Believer"))
		
	
		chr_GainXP("",GetData("BaseXP"))
		Sleep(2)
		StopAction("poison","")
	end
end

function CleanUp()
	StopAction("poison","")
	if AliasExists("Believer") then
		feedback_OverheadActionName("Believer")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time immediately
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+1",Gametime2Total(mdata_GetDuration(MeasureID)))
end

