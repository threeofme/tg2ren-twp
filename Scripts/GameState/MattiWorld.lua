function Init()

	this:AttachModule("TestSuite", "cl_TestSuite")
	this:EnableModule("TestSuite", 4)
		
end

function CleanUp()

	this:DetachModule("TestSuite")

end

