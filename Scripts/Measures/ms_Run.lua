function Run()
	
	SimResetBehavior("")
	SetState("", STATE_ROBBERMEASURE, false)
	
	local Label
	if (IsType("", "Vehicle") ) then
		Label   =  "@L_GENERAL_MOVESPEED_VEHICLE"
	else
		Label = "@L_GENERAL_MOVESPEED"
	end

	Label = Label.."_+1" 
	MsgMeasure("",Label)
	if (f_MoveTo("", "Destination", GL_MOVESPEED_RUN)) then
		-- succesfully reached
		if IsGUIDriven() then
			SimLock("", 0.5)
		end
	end
end

function CleanUp()
	SetState("", STATE_CHECKFORSPINNINGS, false)
end





