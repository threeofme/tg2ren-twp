function Run()
	GetPosition("", "myself") 
	--GfxStartParticle("smoke", "particles/smoke_light.nif", "myself", 5)
	SetState("", STATE_HIDDEN, true)
	while GetState("", STATE_HIDDEN) do
		Sleep(3)
	end
end

function CleanUp()
	--GfxStopParticle("smoke")
	SetState("",STATE_HIDDEN, false)
end



