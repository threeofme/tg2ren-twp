function Init()
  SimSetMortal("", false)
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
end
	
function Run()

  SetState("", STATE_TOWNNPC, true)
	GetInsideBuilding("Owner","Tave")
	GetFreeLocatorByName("Tave","SitRich",1,5,"SitPos")
	f_BeginUseLocator("Owner","SitPos",GL_STANCE_SIT,true)
	local zeit = math.mod(GetGametime(),24)
	while zeit > 7 and zeit <= 24 or zeit <4 do
		Sleep(25)
		PlayAnimationNoWait("","sit_talk")
		local spruch = Rand(6)
		if spruch == 0 then
		    MsgSay("","_HPFZ_BLACKJACK_SPRUCH_+0")
		elseif spruch == 1 then
		    MsgSay("","_HPFZ_BLACKJACK_SPRUCH_+1")
		elseif spruch == 2 then
		    MsgSay("","_HPFZ_BLACKJACK_SPRUCH_+2")
		elseif spruch == 3 then
		    MsgSay("","_HPFZ_BLACKJACK_SPRUCH_+3")
		elseif spruch == 4 then
		    MsgSay("","_HPFZ_BLACKJACK_SPRUCH_+4")
		else
		    MsgSay("","_HPFZ_BLACKJACK_SPRUCH_+5")
		end
		Sleep(10)
		zeit = math.mod(GetGametime(),24)
	end

	f_EndUseLocator("Owner","SitPos",GL_STANCE_STAND)
	CityGetRandomBuilding("", 1, 1, -1, -1, FILTER_IGNORE, "Abgang")
	ReleaseLocator("","SitPos")
  f_MoveTo("","Abgang",GL_MOVESPEED_WALK)
	SetState("", STATE_INVISIBLE, true)

end

function CleanUp()
	InternalDie("")
	InternalRemove("")
end
