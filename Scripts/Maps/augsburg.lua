-- the "Prepare" function is called directly after the map is loaded from the .wld-file
function Prepare()
	ScenarioSetOutdoorScrollBoundaries(-17438, 7046, -16515, -17092, 22203, -12550, 17710, 12815)
	ScenarioSetNameLanguage("german")
	
	local worldname = "South_Germany"
	local mapid = gameplayformulas_GetDatabaseIdByName("maps", worldname)
	GetScenario("World")
	SetProperty("World", "mapid", mapid)
	

	--if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local YearsPerRound = Options:GetValueInt("YearsPerRound")
		if YearsPerRound then
			ScenarioSetYearsPerRound(YearsPerRound)
		end
	--end
	
	SetProperty("World", "ambient", 0)
	if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local Ambient = Options:GetValueInt("Ambient")
		if Ambient==0 then
			SetProperty("World", "ambient", 1)
		end
	end

	SetProperty("World", "messages", 0)
	if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local Messages = Options:GetValueInt("Messages")
		if Messages==0 then
			SetProperty("World", "messages", 1)
		end
	end

	local Options = FindNode("\\Settings\\Options")
	local FrequencyOfficeSessions = Options:GetValueInt("FrequencyOfficeSessions")
	SetProperty("World", "fos", FrequencyOfficeSessions)

end


-- the "Start" function is called after everything has been initializied on the map (players/ai/...)
function Start()
end

