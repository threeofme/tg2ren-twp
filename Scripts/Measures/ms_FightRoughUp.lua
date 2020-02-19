-- ******** THANKS TO KINVER ********
function Run()
	local MaxDistance = 1000
	local ActionDistance = 50

	--already beaten up
	if GetImpactValue("Destination","Fracture")~=0 then
		MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+25",GetID("Destination"))
		StopMeasure()
	end
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil, true) then
		StopMeasure()
	end
	if HasProperty("Destination","RoughUp_start") then
		StopMeasure()
	else
		SetProperty("Destination","RoughUp_start",1)
		feedback_OverheadActionName("Destination")
		PlayAnimation("","watch_for_guard")
		if GetImpactValue("Destination","REVOLT")==0 then
			CommitAction("slugging","","Destination","Destination")
		end
		GetPosition("Destination", "ParticleSpawnPos")
		PlayAnimationNoWait("","rough_up")
		Sleep(1)
		StartSingleShotParticle("particles/bloodsplash.nif", "ParticleSpawnPos", 1,4)
		PlaySound3DVariation("Destination","Effects/combat_strike_mace",1)
		SetProperty("Destination","RoughUp_start",2)
		local OkGoOn = GetProperty("Destination","RoughUp_start",2)
		if OkGoOn == 2 then
			if GetImpactValue("Destination","Fracture")~=0 then
				MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+25",GetID("Destination"))
				StopMeasure()
			end
			
			-- Favor
			if GetDynasty("Destination", "TargetDyn") then
				ModifyFavorToDynasty("", "TargetDyn", -20)
			end
			Sleep(0.2)
			-- set fracture for the victim
			diseases_Fracture("Destination", true)
			-- set property for TakeOverBid
			if HasProperty("Destination","initimidated") then
				RemoveProperty("Destination","intimidated")
			end
			SetProperty("Destination","intimidated",GetDynastyID(""))
			chr_GainXP("",GetData("BaseXP"))
			
			if IsType("Destination", "Sim") and DynastyIsPlayer("Destination") then
				AddEvidence("Destination", "", "Destination", 7) -- Slugging
			end
			
			SetRepeatTimer("", GetMeasureRepeatName2("RoughUp"), 2)
			feedback_MessageCharacter("","@L_BATTLE_FIGHTROUGHUP_MSG_SUCCESS_OWNER_HEAD_+0",
								"@L_BATTLE_FIGHTROUGHUP_MSG_SUCCESS_OWNER_BODY_+0",GetID(""),GetID("Destination"))
			MsgNewsNoWait("Destination","","","intrigue",-1,
							"@L_BATTLE_FIGHTROUGHUP_MSG_SUCCESS_VICTIM_HEAD_+0",
							"@L_BATTLE_FIGHTROUGHUP_MSG_SUCCESS_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
			StopAction("slugging", "")
		end
	end
	RemoveProperty("Destination","RoughUp_start")
end

function CleanUp()
	RemoveProperty("Destination","RoughUp_start")
end
