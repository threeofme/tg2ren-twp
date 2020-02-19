function Init()

	this:AttachModule("Menu", "cl_HelloController")
	this:EnableModule("Menu", 4)

	this:AttachModule("SeasonBlender", "cl_SeasonBlendController")
	this:EnableModule("SeasonBlender", 0)

end

function CleanUp()

	this:DetachModule("Menu")
	this:DetachModule("SeasonBlender")			

end

