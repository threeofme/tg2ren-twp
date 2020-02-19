function Run()
	BuildingGetCity("","city")

	local sollevel = GetProperty("city","SeverityOfLaw")
	local sol = "@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+"..sollevel
	local tax = GetProperty("city","TurnoverTax")
	local tithe = GetProperty("city","ChurchTithe")	

	local result = MsgNewsNoWait("dynasty",-1,"@P@B[O,@L_GENERAL_BUTTONS_CLOSE_+0]","politics",
	-1,
	"@L_GENERAL_MEASURES_SHOW_CITYLAWS_+0",
	"@L_GENERAL_MEASURES_SHOW_CITYLAWS_+1",GetID("city"),tax,tithe,sol)
end
