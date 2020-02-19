function OnButtonPressed(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local Ambient = Options:GetValueInt("Ambient")
	local AmbientNextStep = Options:GetValueInt("AmbientNextStep")

	if Ambient==1 then
		Options:SetValueInt("Ambient",0)
		Options:SetValueInt("AmbientNextStep",0)
	else
		Options:SetValueInt("Ambient",1)
		Options:SetValueInt("AmbientNextStep",0)
	end
end


function OnButtonPressed_Back(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local AmbientNextStep = Options:GetValueInt("AmbientNextStep")

	if (AmbientNextStep < 2) or (AmbientNextStep > 2) then
		Options:SetValueInt("AmbientNextStep",0)
		Options:SetValueInt("Ambient",1)
	else
		Options:SetValueInt("AmbientNextStep",AmbientNextStep-1)
	end
end


function OnButtonPressed_Next(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local AmbientNextStep = Options:GetValueInt("AmbientNextStep")

	Options:SetValueInt("AmbientNextStep",AmbientNextStep+1)
end

