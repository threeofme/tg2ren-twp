--
-- CheckPosition is called everytime a new position is checked for a building of this kind
-- the only alias defined here is "Position", that represents the wanted position
-- return nil if the position ok else return the label of the error message
-- attention: this function call is unscheduled
--
function CheckPosition()
	-- make sure a building has been requested by AI
	if (GetLocalPlayerDynasty("Builder") 
			and GetProperty("Builder", "BUILD_TargetSimId")
			and GetProperty("Builder", "BUILD_BuildingType")) then
		-- TODO this could also be used to check available space at current position
		return nil
	else
		return "_TWP_BUILD_ERROR_NotRequested_+0"
	end
	
--	if (BuildingFindWaterPos("Position","PositionEntry","WaterPos")) then
--		return nil
--	end
	return nil
end

function Setup()
	-- find owner and transfer ownership of building
	GetDynasty("", "Builder")
	local TargetSimId = GetProperty("Builder", "BUILD_TargetSimId")
	GetAliasByID(TargetSimId, "TargetSim")
	BuildingBuy("", "TargetSim", BM_CAPTURE)
	LogMessage("AITWP::Dummy TargetID = "..TargetSimId)
	LogMessage("AITWP::Dummy Target = "..GetName(TargetSimId))

	-- change building to requested type
	local BuildingType = GetProperty("Builder", "BUILD_BuildingType")
	LogMessage("AITWP::Dummy BuildingType = "..BuildingType)
	local proto = ScenarioFindBuildingProto(GL_BUILDING_CLASS_WORKSHOP, BuildingType, 1, 0)
	BuildingInternalLevelUp("", proto)
	
	-- clean up properties of builder
	RemoveProperty("Builder", "BUILD_TargetSimId")
	RemoveProperty("Builder", "BUILD_BuildingType")
end
