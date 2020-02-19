--
-- OnLevelUp is called everytime the building level was changed, even when the building is build the first time.
-- This function is called bevor Setup
-- attention: this function call is unscheduled
--
function OnLevelUp()
	local Check 
	local Proto
	local CurrentLevel = BuildingGetLevel("")
	if CurrentLevel == 1 then -- verylow
		Check = Rand(2)
		if Check == 0 then
			return
		else
			Proto = 681
		end	
	elseif CurrentLevel == 2 then -- low
		Check = Rand(5)
		if Check == 0 then
			return
		elseif Check == 1 then
			Proto = 655
		elseif Check == 2 then
			Proto = 656
		elseif Check == 3 then
			Proto = 657
		else
			Proto = 682
		end
	elseif CurrentLevel == 3 then -- lowmed
		Check = Rand(3)
		if Check == 0 then
			return
		elseif Check == 1 then
			Proto = 658
		else
			Proto = 659
		end
	elseif CurrentLevel == 4 then -- med
		Check = Rand(3)
		if Check == 0 then
			return
		elseif Check == 1 then
			Proto = 683
		else
			Proto = 684
		end
	else
		return
	end

	BuildingInternalLevelUp("", Proto)
end

function Run()
end

function Setup()
end

function PingHour()
	GetScenario("World")
	if HasProperty("World", "messages") then
		if GetProperty("World", "messages") == 1 then
		--	if BuildingGetOwner("", "MyBoss") then
				MeasureRun("", "", "RandomEvents", false)
				return
		--	end
		end
	end
end
