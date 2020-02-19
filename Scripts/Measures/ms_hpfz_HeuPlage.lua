function Init()
end

function Run()

	if GetSeason() == 3 then
	    RemoveProperty("","Heuschrecken")
	    StopMeasure()
	end
    GetPosition("","Plage")
	GfxStartParticle("Hsch1", "particles/Grasshopper.nif", "Plage", 1.2)
	local htime = 0
    while GetProperty("","Heuschrecken")>0 do
		if GetSeason() == 3 then
		    RemoveProperty("","Heuschrecken")
		    StopMeasure()
		end
        Sleep(Rand(9)+6)
		if Rand(100) > 60 then
			local FeldFilter = "__F( (Object.GetObjectsByRadius(Building)==1000)AND(Object.IsClass(6))AND(Object.IsType(33))AND(Object.GetLevel()==0)AND NOT(Object.HasProperty(Heuschrecken)) )"
			if Find("",FeldFilter,"Feldy",1) > 0 then	
				if not HasProperty("Feldy","Heuschrecken") then
					SetProperty("Feldy","Heuschrecken",1)
					MeasureRun("Feldy","","HeuPlage",true)
				end			
			end
			htime = htime + 1
			if htime == 10 then
				break
			end
		end
	end
	
end	
		
function CleanUp()
    RemoveProperty("","Heuschrecken")
    GfxDetachAllObjects()
end
