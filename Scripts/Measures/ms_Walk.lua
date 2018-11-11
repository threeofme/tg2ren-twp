function Run()
	
	SimResetBehavior("")
	SetState("", STATE_ROBBERMEASURE, false)
	
	if (IsType("", "Vehicle") ) then
		MsgMeasure("","@L_GENERAL_MOVESPEED_VEHICLE_+0")
	else
		MsgMeasure("","@L_GENERAL_MOVESPEED_+0")
	end
	
	if (f_MoveTo("", "Destination", GL_MOVESPEED_WALK)) then
		-- succesfully reached
		if IsGUIDriven() then
			SimLock("", 0.5)
		end
	end
end

function CleanUp()
	SetState("", STATE_CHECKFORSPINNINGS, false)
end