function OnButtonPressed(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local Messages = Options:GetValueInt("Messages")
	local MessagesNextStep = Options:GetValueInt("MessagesNextStep")

	if Messages==1 then
		Options:SetValueInt("Messages",0)
		Options:SetValueInt("MessagesNextStep",0)
	else
		Options:SetValueInt("Messages",1)
		Options:SetValueInt("MessagesNextStep",0)
	end
end


function OnButtonPressed_Back(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local MessagesNextStep = Options:GetValueInt("MessagesNextStep")

	if (MessagesNextStep < 2) or (MessagesNextStep > 2) then
		Options:SetValueInt("MessagesNextStep",0)
		Options:SetValueInt("Messages",1)
	else
		Options:SetValueInt("MessagesNextStep",MessagesNextStep-1)
	end
end


function OnButtonPressed_Next(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local MessagesNextStep = Options:GetValueInt("MessagesNextStep")

	Options:SetValueInt("MessagesNextStep",MessagesNextStep+1)
end

