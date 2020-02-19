-- the "Prepare" function is called directly after the map is loaded from the .wld-file
function Prepare()
	--ScenarioSetOutdoorScrollBoundaries(41125, -28878, 42895, 42120, -45504, 42405, -37372, -37783)
	ScenarioSetNameLanguage("german")

	local worldname = "Netherlands"
	local mapid = gameplayformulas_GetDatabaseIdByName("maps", worldname)
	GetScenario("World")
	SetProperty("World", "mapid", mapid)

	if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local YearsPerRound = Options:GetValueInt("YearsPerRound")
		if YearsPerRound then
			ScenarioSetYearsPerRound(YearsPerRound)
		end
	end
	
	SetProperty("World", "ambient", 0)
	if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local Ambient = Options:GetValueInt("Ambient")
		if Ambient then
			SetProperty("World", "ambient", Ambient)
		end
	end

	SetProperty("World", "messages", 0)
	if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local Messages = Options:GetValueInt("Messages")
		if Ambient then
			SetProperty("World", "messages", Messages)
		end
	end
end


-- the "Start" function is called after everything has been initializied on the map (players/ai/...)
function Start()
end

