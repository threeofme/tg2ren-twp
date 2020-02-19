-------------------------------------------------------------------------------
----
----	OVERVIEW "as_178_UseToadslime"
----
----	with this artifact, the player can infect an sim with a disease
----
-------------------------------------------------------------------------------
function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	if BuildingGetType("Destination")==GL_BUILDING_TYPE_TOWER then
		StopMeasure()
	end

	if IsStateDriven() then
		local ItemName = "Toadslime"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				StopMeasure()
			end
		end
	end

	--how far the Destination can be to start this action
	local MaxDistance = 1500
	--how far from the destination
	local ActionDistance = 30
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not GetLocatorByName("Destination","entry1","MovePos") then
		StopMeasure()
	end
	if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN,20) then
		StopMeasure()
	end
	AlignTo("","Destination")
	Sleep(0.65)
	
	-- Commit the action
	BuildingGetOwner("Destination", "Victim")
	if GetImpactValue("Destination","toadslime")<1 then
		if RemoveItems("","Toadslime",1)>0 then
			CommitAction("lay_bomb", "Owner", "Victim", "Destination")
			PlayAnimation("","manipulate_middle_twohand")
			StopAction("lay_bomb", "Owner")
			
			SetMeasureRepeat(TimeOut)
			MsgNewsNoWait("","Destination","","building",-1,
							"@L_ARTEFACTS_178_USETOADSLIME_MSG_ACTOR_HEAD_+0",
							"@L_ARTEFACTS_178_USETOADSLIME_MSG_ACTOR_BODY_+0",GetID(""),GetID("Destination"))
			
			AddImpact("Destination","InfectedByDisease",1,duration)
			AddImpact("Destination","toadslime",1,duration)
			chr_GainXP("",GetData("BaseXP"))
		end
	else
		if DynastyIsPlayer("") then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_ARTEFACT_FAIL_+1", GetID("Destination"))
		end
	end
end

function CleanUp()
	StopAnimation("")
	StopAction("lay_bomb", "Owner")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

