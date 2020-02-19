function OnButtonPressed(x, y, device, key)
	-- local Options = FindNode("\\Settings\\Options")
	-- local YearsPerRoundbtnPressed = GetSettingNumber("OPTIONS", "YearsPerRoundBtnPressed", 0);
	-- --local YPRNextStep = Options:GetValueInt("YPRNextStep")
	-- if YearsPerRoundbtnPressed > 0 then
		-- Options:SetValueInt("YearsPerRound",1)
		-- LogMessage("YearsPerRound = 1");
	-- else
		-- Options:SetValueInt("YearsPerRound",4)
		-- LogMessage("YearsPerRound = 4");
	-- end
	-- if YearsPerRound==4 then
		-- Options:SetValueInt("YearsPerRound",1)
		-- Options:SetValueInt("YPRNextStep",0)
		-- LogMessage("YPRNextStep = "..YPRNextStep);
		-- LogMessage("YearsPerRound = 1");
	-- else
		-- Options:SetValueInt("YearsPerRound",4)
		-- Options:SetValueInt("YPRNextStep",0)
		-- LogMessage("YPRNextStep = "..YPRNextStep);
		-- LogMessage("YearsPerRound = 4");
	-- end
end


function OnButtonPressed_Back(x, y, device, key)
	-- local Options = FindNode("\\Settings\\Options")
	-- local YPRNextStep = Options:GetValueInt("YPRNextStep")

	-- if (YPRNextStep < 2) or (YPRNextStep > 2) then
		-- Options:SetValueInt("YPRNextStep",0)
		-- LogMessage("YPRNextStep = 0");
		-- Options:SetValueInt("YearsPerRound",4)
		-- LogMessage("YearsPerRound = 4");
	-- else
		-- Options:SetValueInt("YPRNextStep",YPRNextStep-1)
		-- LogMessage("YPRNextStep = "..YPRNextStep-1);
	-- end
end


function OnButtonPressed_Next(x, y, device, key)
	-- local Options = FindNode("\\Settings\\Options")
	-- local YPRNextStep = Options:GetValueInt("YPRNextStep")

	-- Options:SetValueInt("YPRNextStep",YPRNextStep+1)
	-- LogMessage("YPRNextStep = "..YPRNextStep+1);
end

