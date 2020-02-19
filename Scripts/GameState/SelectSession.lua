function Init()

	this:AttachModule("SessionSelector", "cl_SessionSelector")
	this:EnableModule("SessionSelector")

end

function CleanUp()

	this:DetachModule("SessionSelector")

end


