function Init()
	SetStateImpact("no_enter")
end

function Run()
	-- as long as state_inspected is set, no character is able to enter the building
	while (GetImpactValue("","questinspection")==1)  do
		Evacuate("Owner")
		Sleep(2)
	end
end

