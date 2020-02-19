function InitTarget()
 --MsgMeasure("",GetData("TargetMessage"))
 InitAlias("Destination",GetData("PanelName"),GetData("TargetFilterID"),GetData("TargetMessage"),0)
end

function Init()
end

function Run()
end

function CleanUp()
end

function OnInterrupt()
end

function OnRejected()
end

function OnObjectAttached()
end

function OnDeath(pAlias)
	if(pAlias == "Owner") then
		StopMeasure()
	else
		RemoveAlias(pAlias)
	end
end

