function Run()
	BuildingGetCity("","city")

	local termine = ""
	local event_cnt = CityGetNumEvents("city")
	
	if (event_cnt==0) or (event_cnt==nil) then
		termine = "@L_GENERAL_MEASURES_SHOW_CITYSCHEDULE_+1"
	else
		for i = 0, event_cnt-1 do
			termine = termine..(i+1)..") "..CityGetEventText("city",i).."@L$N"
		end
	end
	
	local result = MsgNewsNoWait("dynasty",-1,"@P@B[O,@L_GENERAL_BUTTONS_CLOSE_+0]",
	"politics",
	-1,
	"@L_GENERAL_MEASURES_SHOW_CITYSCHEDULE_+0",
	termine)
end
