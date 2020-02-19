function Run()
--	local Count = ScenarioGetObjects("cl_Building", 99, "Build")
	
--	for l=0, Count-1 do
--		local Height = GfxGetHeight("Build"..l)
--		LogMessage(GetID("Build"..l).." = "..Height)
--		Sleep(0.1)
--	end
	
	GetAliasByID(8364, "test")
	local Height = GfxGetHeight("test")
	LogMessage(GetID("test").." = "..Height)
end

function CleanUp()
end

