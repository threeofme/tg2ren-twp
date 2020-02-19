-- the "Prepare" function is called directly after the map is loaded from the .wld-file
function Prepare()
	ScenarioSetOutdoorScrollBoundaries(-39511, 5940, -24147, -3791, -17980, 8863, -33634, 20247)
	ScenarioSetNameLanguage("english")

	GetScenario("World")
	SetProperty("World", "static", 1)
end


-- the "Start" function is called after everything has been initializied on the map (players/ai/...)
function Start()
end

