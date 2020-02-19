

--
-- Setup is called after the building is build. The function is called after OnLevelUp
-- attention: this function call is unscheduled
--
function Setup()
	if not HasProperty("","PamphletCnt") then
		SetProperty("","PamphletCnt",0)
	end
end

function PingHour()
end

function Run()
end

function OnLevelUp()
end
