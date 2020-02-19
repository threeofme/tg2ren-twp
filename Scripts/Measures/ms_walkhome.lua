function Run()
	MsgMeasure("","@L_GENERAL_MOVESPEED_+2")
	if not GetHomeBuilding("","HomeBuilding") then
		return
	end
	if (f_MoveTo("","HomeBuilding")) then
		-- succesfully reached
		if IsGUIDriven() then
			SimLock("", 0.5)
		end
	end
end

