-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_ShowContracts"
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	GetInsideBuilding("", "guildhouse")
	BuildingGetCity("guildhouse","myCity")

--	if GetLocatorByName("guildhouse","Curtain","CurtainPos") then
--		GfxAttachObject("Curtain","Locations/Residence/Curtain_Residence.nif")
--		GfxSetPositionTo("Curtain","CurtainPos")
--		GfxSetRotation("Curtain",0,0,0,true)
--	end

	MsgBoxNoWait("",false,
		"@L_GUILDHOUSE_SHOWCONTRACTS_HEAD_+0",
		"@L_GUILDHOUSE_SHOWCONTRACTS_BODY_+0",
		GetName("myCity"),400)

--	MsgBoxNoWait("",false,
--		"@L_GUILDHOUSE_SHOWCONTRACTS_HEAD_+0",
--		"@L_GUILDHOUSE_SHOWCONTRACTS_BODY_+1",
--		GetName("myCity"),640)

end
