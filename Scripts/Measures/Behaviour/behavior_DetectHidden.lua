function Run()
	AlignTo("", "Actor")
	local Time = PlayAnimationNoWait("","point_at")
	MsgSayNoWait("", "@L_THIEF_DETECT_HIDDEN")
	Sleep(Time)
end

function CleanUp()
	AlignTo("")	
	RemoveOverheadSymbols("")
end

