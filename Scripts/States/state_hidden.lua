function Init()
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_idle")
	SetInvisible("", true)
	AddObjectDependendImpact("", 2, "MoveSpeed", 0.5, -1)
end

function Run()
	--ShowOverheadSymbol("", true, false,0,  "@L$S[2022]")
	--MoveSetStance("", GL_STANCE_CROUCH)
	
	local bSuccess =  GetDynasty("", "Dyn")
	if (bSuccess) then
		local iFlagID = DynastyGetFlagNumber("Dyn")
		AddImpact("", "Hidden", iFlagID , -1)
	end
	
	CommitAction("hidden", "","")
	while true do
		Sleep(5)
	end
end

function CleanUp()
	--RemoveOverheadSymbols("")
	--MoveSetStance("", GL_STANCE_STAND)

	RemoveImpact("", "Hidden")

	StopAction("hidden", "")
	SetInvisible("", false) 
	RemoveAllObjectDependendImpacts("", 2)
end

