-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_074_RenovateBuilding"
----
----	With this measure the player can renovate one of its buildings
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if GetState("", STATE_REPAIRING) then
		return
	end
	
	if GetState("", STATE_FIGHTING) then
		return
	end
	
	if GetState("", STATE_BURNING) then
		return
	end
	
	if GetState("", STATE_LEVELINGUP) then
		return
	end
	
	if GetState("", STATE_DEAD) then
		return
	end

	local TimeUntilRepeat = 4	
	-- Loose money according to buildingcosts
	Cost = BuildingGetRepairPrice("")
	
	local Result = MsgNews("","","@P"..
				"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
				"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
				ms_074_renovatebuilding_AIDecision,  --AIFunc
				"building", --MessageClass
				2, --TimeOut
				"@L_MEASURE_RenovateBuilding_NAME_+0",
				"@L_GENERAL_MEASURES_074_RENOVATEBUILDING_MSG_BODY_+0",
				GetID(""),Cost)
	if Result == "C" then
		StopMeasure()
	end
	
	if not f_SpendMoney("dynasty", Cost, "BuildingRepairs") then
		MsgQuick("", "@L_GENERAL_MEASURES_074_RENOVATEBUILDING_FAILURES_+0", Cost, GetID(""))
		return
	end
	SetMeasureRepeat(TimeUntilRepeat)
	-- Actually start the repairing
	SetState("", STATE_REPAIRING, true)
	
end

function AIDecision()
	return "O"
end

