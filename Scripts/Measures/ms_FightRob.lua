function Run()

	local MaxDistance = 1000
	local ActionDistance = 50
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil, true) then
		StopMeasure()
	end
	
	if GetImpactValue("Destination","recentlyrobbed")>0 then
		MsgBoxNoWait("","Destination","@L_FIGHTROB_FAIL_HEAD_+0",
					"@L_FIGHTROB_FAIL_BODY_+0",GetID("Destination"))
		StopMeasure()
	end
	
	
	feedback_OverheadActionName("Destination")
	PlayAnimation("","watch_for_guard")
	if GetImpactValue("Destination","REVOLT")==0 then
		CommitAction("rob", "", "Destination", "Destination")
	end
	PlayAnimation("","manipulate_bottom_r")
--	local Booty = Plunder("", "Destination",1)
	-- instead of cooldown we give an impact
	AddImpact("Destination","recentlyrobbed",1,12)
	
	-- Favor
	if GetDynasty("Destination", "TargetDyn") then
		ModifyFavorToDynasty("", "TargetDyn", -15)
	end
--	if Booty > 0 then
		--for the mission
	--	mission_ScoreCrime("",Booty)
	--	feedback_MessageCharacter("","@L_BATTLE_FIGHTROB_MSG_SUCCESS_OWNER_HEAD_+0",
	--					"@L_BATTLE_FIGHTROB_MSG_SUCCESS_OWNER_BODY_+0",GetID("Destination"))
	--	MsgNewsNoWait("Destination","","","intrigue",-1,
	--					"@L_BATTLE_FIGHTROB_MSG_SUCCESS_VICTIM_HEAD_+0",
	--					"@L_BATTLE_FIGHTROB_MSG_SUCCESS_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
	--else
		local Level = SimGetLevel("Destination")
		local Money = GetMoney("Destination")
		if Money >20000 then
			Money = 20000
		elseif Money <1000 then
			Money = 0
		end
		
		if Money > 0 then
			local MoneyToSteal = Level*(Money*0.1)
	--	f_CreditMoney("",MoneyToSteal,"IncomeRobber")
		
			f_SpendMoney("Destination", MoneyToSteal, "Theft")
			chr_RecieveMoney("", MoneyToSteal, "IncomeRobber")
			Sleep (0.5)
			chr_GainXP("",GetData("BaseXP"))
			mission_ScoreCrime("", MoneyToSteal)
			feedback_MessageCharacter("","@L_BATTLE_FIGHTROB_MSG_SUCCESS_OWNER_HEAD_+0",
						"@L_BATTLE_FIGHTROB_MSG_SUCCESS_OWNER_BODY_+0",GetID("Destination"))
			MsgNewsNoWait("Destination","","","intrigue",-1,
						"@L_BATTLE_FIGHTROB_MSG_SUCCESS_VICTIM_HEAD_+0",
						"@L_BATTLE_FIGHTROB_MSG_SUCCESS_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
		else
			MsgQuick("","@L_BATTLE_FIGHTROB_FAILED_+0",GetID("Destination"))
		end
	--end
	
	Sleep(2)
	if IsType("Destination", "Sim") and DynastyIsPlayer("Destination") then
		AddEvidence("Destination", "", "Destination", 20) -- Theft
	end
	StopAction("rob", "")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

