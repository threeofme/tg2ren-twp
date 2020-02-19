function Run()
	GetInsideBuilding("", "Destination")

	if AliasExists("Destination") then
		f_MoveTo("", "Destination", GL_MOVESPEED_RUN)
		
		if not BuildingSetOwner("Destination", "") then
			MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID(""), GetID("Destination"))
		end
	end
end
