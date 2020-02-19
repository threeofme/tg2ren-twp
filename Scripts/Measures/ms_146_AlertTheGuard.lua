function Run()

	SetRepeatTimer("dynasty", GetMeasureRepeatName(), 1)

	if IsType("", "cl_Building") then
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==2000)AND(Object.IsInCombatWithMyDynasty()))"
		local NumOfSims = Find("", SimFilter,"HostileSim", -1)
		if NumOfSims > 0 then
			PlaySound3D("","Locations/alarm_horn_single+0.wav",1.0)
		else
			if (GetState("", STATE_FIGHTING)==true) then
				SetState("", STATE_FIGHTING, false)
				return
			end
		end	
	else
		if SimGetAge("")<16 then
			ShowOverheadSymbol("Owner", true, true,"OverheadSymbolID", "@L_GENERAL_MEASURES_146_ALERTTHEGUARD")
		else
			MsgSay("","@L_GENERAL_MEASURES_146_ALERTTHEGUARD")
		end
	end

	CommitAction("call_guards","Owner","Owner")
	Sleep(5)
end

function CleanUp()
	StopAction("call_guards","Owner")
	RemoveOverheadSymbol("OverheadSymbolID")
end


 