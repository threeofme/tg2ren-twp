function Init()
	SimSetHireable("", false)
	SetExclusiveMeasure("", "StartDialog",EN_BOTH)
end

function Run()

	GetSettlement("#Player","Settlement")

	CityGetRandomBuilding("Settlement",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"CouncilBuilding")

	if (GetOutdoorMovePosition("#OfficeInfoGuy","CouncilBuilding0","Move")) then
		f_MoveTo("","Move",GL_MOVESPEED_WALK)
	end
	
	while true do
		Sleep(60)
		break
	end
	
	SetData("Success", 1)
end

function CleanUp()

	if GetData("Success")==1 then
		SetState("", STATE_LOCKED, False)
		
		BindQuest("Mission_1_3_A","#OfficeInfoGuy")
		StartQuest("Mission_1_3_A_BIND","#Player",null,false)

		SimSetHireable("", true)
		AllowAllMeasures("")
	end
end

