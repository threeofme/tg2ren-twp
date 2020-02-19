function Run()
	local dyn = GetDynastyID("")
	local prop = "bm"..dyn

	if HasProperty("", prop) then
		MsgBoxNoWait("","Destination","@L_MEASURE_SetBookmark_REMOVED_HEAD","@L_MEASURE_SETBOOKMARK_REMOVED_BODY_+0",GetID("Destination"))
		RemoveProperty("Destination", prop)
	else	
		MsgBoxNoWait("","Destination","@L_MEASURE_SetBookmark_ADDED_HEAD","@L_MEASURE_SETBOOKMARK_ADDED_BODY_+0",GetID("Destination"))
		SetProperty("Destination", prop, 1)
	end
end