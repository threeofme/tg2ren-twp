function Run()
	MeasureSetNotRestartable()

	if GetInsideBuilding("", "Building") then
		return
	end

	SetState("", STATE_CAPTURED, false)
	AddImpact("","REVOLT",1,FugitiveHours)
	SetState("",STATE_REVOLT,true)

--	CommitAction("revolt","","")

--	if GetHomeBuilding("", "Home") then
--		f_MoveTo("", "Home", GL_MOVESPEED_RUN)
--	end
	StopMeasure()
end

function CleanUp()

end
