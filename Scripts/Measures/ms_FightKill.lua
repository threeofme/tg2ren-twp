function Run()

	local MaxDistance = 1000
	local ActionDistance = 100
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if GetState("Destination",STATE_DEAD) then
		StopMeasure()
	end
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil, true) then
		StopMeasure()
	end
	if GetProperty("Destination","KillAction_start") then
		StopMeasure()
	else
		SetProperty("Destination","KillAction_start",1)
		feedback_OverheadActionName("Destination")
		GetPosition("Destination", "ParticleSpawnPos")
		BattleWeaponPresent("")
		Sleep(2)
		local Bounty = 0
		PlayAnimationNoWait("","finishing_move_01")
		Sleep(0.6)	
		StartSingleShotParticle("particles/bloodsplash.nif", "ParticleSpawnPos", 1,4)
		PlaySound3DVariation("Destination","Effects/combat_strike_mace",1)
		Sleep(2)
		BattleWeaponStore("")
		
		SetProperty("Destination","KillAction_start",2)
		local Action = GetProperty("Destination","KillAction_start")
		if Action == 2 then
			MeasureSetNotRestartable()
			feedback_MessageCharacter("","@L_BATTLE_FIGHTKILL_MSG_SUCCESS_OWNER_HEAD_+0",
								"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_OWNER_BODY_+0",GetID("Destination"))

			if not HasProperty("Destination","MessageRecieved") then
				SetProperty("Destination","MessageRecieved",1)
				MsgNewsNoWait("Destination","","","intrigue",-1,
								"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_VICTIM_HEAD_+0",
								"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
			end

			local VictimLevel = SimGetLevel("Destination")
			local baseXP = GetData("BaseXP")
			baseXP = baseXP*VictimLevel -- You get more XP for high level targets

			if GetDynastyID("")>0 then
				if GetImpactValue("Destination","REVOLT")==0 then
					CommitAction("murder","","Destination","Destination")
					StopAction("murder", "")
				else
					Bounty = SimGetLevel("Destination")*500
					chr_RecieveMoney("", Bounty, "IncomeOther")
				end
			end	
			
			if IsType("Destination", "Sim") and DynastyIsPlayer("Destination") then
				AddEvidence("Destination", "", "Destination", 16) -- Murder
			end
			
			chr_GainXP("",baseXP)
			GetDynasty("Destination","TargetDyn")
			SetFavorToDynasty("","TargetDyn",0)
			SetProperty("Destination","UnconsciousKill",1)
			Kill("Destination")	-- must be the last command in this measure, because the kill of a measure object restarts the measure
		end
	end
	if AliasExists("Destination") then
		RemoveProperty("Destination","KillAction_start")
	end
end
function CleanUp()
	if AliasExists("Destination") then
		RemoveProperty("Destination","KillAction_start")
	end
	StopAction("murder","")
end