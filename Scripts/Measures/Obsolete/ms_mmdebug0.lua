function Run()
	CreateCutscene("Duel","my_duel")
	CopyAliasToCutscene("Destination","my_duel","challenger")
	CopyAliasToCutscene("","my_duel","challenged")
	CutsceneCallUnscheduled("my_duel","Start")
end
