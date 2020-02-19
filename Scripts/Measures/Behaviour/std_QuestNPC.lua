function Init()
	SetStateImpact("","STATE_NPC",true)
	SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)
end

function Run()
	while true do
		Sleep(10)
	end
end

function CleanUp()
	SetStateImpact("","STATE_NPC",false)
	AllowAllMeasures("")
end

