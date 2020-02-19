function Run()

	CarryObject("", "Handheld_Device/Anim_Scroll.nif", false)

	local Name
	local	Settlement
	
	if not GetSettlement("", "Settlement") then
		Sleep(10)
		return
	end
	
	while true do

		if GetOfficeTypeHolder("Settlement", 6 ,"Office") then	-- 6 = EN_OFFICETYPE_GUILDMAN

			if DynastyIsPlayer("Office") then

				Sleep(20)
				return

			end

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

