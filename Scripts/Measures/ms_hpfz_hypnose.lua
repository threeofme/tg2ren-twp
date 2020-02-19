function Run()

	while GetState("", STATE_HPFZ_HYPNOSE) == true do
		CommitAction("bard","","")
		CarryObject("","Handheld_Device/Doll_med_01.nif", false)
		PlayAnimation("","chop_in")
		LoopAnimation("","chop_loop", 20)
		PlayAnimation("","chop_out")
		StopAction("bard","")
		ms_hpfz_hypnose_rundgang()
	end
	
	StopMeasure()
end

function rundgang()
	MoveSetActivity("","sick")
	local offset = math.mod(GetID("Owner"), 30) * 0.1
	local class
	if GetSettlement("", "City") then
		local	RandVal = Rand(7)
		if RandVal < 2 then
			class = GL_BUILDING_CLASS_MARKET
		elseif RandVal < 4 then
			class = GL_BUILDING_CLASS_PUBLIC
		else
			class = GL_BUILDING_CLASS_WORKSHOP
		end	
		if CityGetRandomBuilding("City", class, -1, -1, -1, FILTER_IGNORE, "Destination") then
			if GetOutdoorMovePosition("", "Destination", "MoveToPosition") then
				f_MoveTo("", "MoveToPosition", GL_MOVESPEED_WALK, 400+offset*15)
			end
		end
	end
	MoveSetActivity("","")
end

function CleanUp()
	StopAction("bard","")
	CarryObject("","", false)
	MoveSetActivity("","")
end
