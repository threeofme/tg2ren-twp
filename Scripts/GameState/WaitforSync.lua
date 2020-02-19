function Init()
	LogMessage("TWP::WaitForSync Starting init...")
end

function CleanUp()
	LogMessage("TWP::WaitForSync Cleaning up...")
	this:DetachModule("Hud")
	this:DetachModule("WinInputCtrl")
end



