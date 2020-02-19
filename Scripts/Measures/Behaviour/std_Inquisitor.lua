EN_OFFICETYPE_CLERIC = 8

function Run()

	CarryObject("", "Handheld_Device/Anim_Cross.nif", false)

	local Name
	local	Settlement
	
	if not GetSettlement("", "Settlement") then
		Sleep(10)
		return
	end
	
	while true do

		--get the office holder
		CityGetOffice("Settlement",6,0,"Office")
		OfficeGetHolder("Office","Kardinal")
		if(AliasExists("Kardinal")) then
			SimSetReligion("",SimGetReligion("Kardinal"))
		end
			
		if not CityGetRandomBuilding("Settlement", -1, -1, -1, -1, FILTER_IGNORE, "PatrolMe") then
			Sleep(10)
			return
		end
		
		if GetOutdoorMovePosition("Owner", "PatrolMe", "MoveToPosition") then
			Name = GetName("MoveToPosition")
--			MsgMeasure("","Moving to ("..Name..")")
			f_MoveTo("","MoveToPosition",GL_MOVESPEED_WALK, 500)
		end

		Sleep(Rand(10)+30)
	end
	
end

