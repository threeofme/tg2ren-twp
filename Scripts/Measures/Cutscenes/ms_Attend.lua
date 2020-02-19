function Run()
	--if DynastyIsPlayer("") then
	--	if MsgNews("","destination","@P@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",-1,"politics",-1,"@L_LAWSUIT_DIARY_REMEMBER_+0","@L_LAWSUIT_DIARY_REMEMBER_+1",GetID(""),GetSettlementID("destination"))=="C" then
	--		return 
	--	end
	--end
	SimSetProduceItemID("", -1, -1)
	SetState("", STATE_WORKING, false)
	if GetState("", STATE_ROBBERMEASURE) then
		SetState("", STATE_ROBBERMEASURE, false)
	end
	f_MoveTo("","destination")
	Sleep(100000)
end
