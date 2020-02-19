function Init()

	cl_LoadingScreen:GetInstance():ShowLoadingScreen("LoadingScreen/balken.dds", 183, 684, 657, 32, 4, 3)
	
	this:AttachModule("WorldSessionCtrl", "cl_WorldSessionController")
	this:AttachModule("TextSystem","cl_TextSystemModule")
	
	this:SetValueInt("GameMode",1)
	this:SetValueString("SessionType", "LOCALHOST")
	
	InputCtrl = FindNode("\\Application\\Game\\InputCtrl")
	InputCtrl:LoadInputMapping("Input.ini")
	
	this:AttachModule("Illustrator", "cl_Illustrator")
	this:EnableModule("Illustrator", 1)
	
	this:SetValueString("SessionType", "LOCALHOST")
	
	this:AttachModule("SimulationController", "cl_SimulationController")
	this:EnableModule("SimulationController", 2)
	
	this:AttachModule("CharacterCreationSessionCtrl", "cl_CharacterCreationSessionCtrl")
	local Module = FindNode("\\Application\\Game\\CharacterCreationSessionCtrl")
	if Module then
		local WorldName = this:GetSettingString("GAME", "CharacterCreation", "")
		if WorldName then
			Module:SetValueString("CampaignName", WorldName)
		end
	end
	
	local Options = FindNode("\\Settings\\Options")
	Options:SetValueInt("YearsPerRound",4)
	Options:SetValueInt("YPRNextStep",0)

	Options:SetValueInt("Ambient",1)
	Options:SetValueInt("AmbientNextStep",0)

	Options:SetValueInt("Messages",1)
	Options:SetValueInt("MessagesNextStep",0)

	Options:SetValueInt("FrequencyOfficeSessions",2)
	Options:SetValueInt("FOSNextStep",0)

	this:ChangeGameState("StartScreen")
end

