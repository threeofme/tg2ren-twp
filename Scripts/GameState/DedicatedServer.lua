
function Init()

	this:AttachModule("SimulationController", "cl_SimulationController")
	this:EnableModule("SimulationController", 2)	

end

function Exit()

	this:DetachModule("SimulationController")

end




