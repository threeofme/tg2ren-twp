function Run()

	-- etwa Abstand vom Geschehen, und gaffen
	GetFleePosition("Owner", "Actor", Rand(150)+200, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)
	
	local FavorModify = 2
	if SimGetFaith("Actor") >30 then 
		FavorModify = 3
	elseif SimGetFaith("Actor") >50 then
		FavorModify = 4
	elseif SimGetFaith("Actor") >70 then
		FavorModify = 5
	elseif SimGetFaith("Actor") >90 then
		FavorModify = 6
	end
	
	local ActionName = GetData("Action_Name")
	local TimeLeft = -1
	local	TimeOut = GetGametime()+0.5
	SetRepeatTimer("Owner", "Listen2Preacher", 4)

	--listen
	while not ActionIsStopped("Action") do

		if GetGametime() > TimeOut then
			break
		end
			
		if TimeLeft < 0 then
		local Value = Rand(100)
			if Value < 50 then
				TimeLeft = PlayAnimation("Owner", "cheer_01")
			else
				TimeLeft = PlayAnimation("Owner", "cheer_02")
			end
			if Rand(9) == 0 then
				MsgSayNoWait("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_COMMENT")
			end
		end
		Sleep(5)
		TimeLeft = TimeLeft - 1
	end
	
	--raise favor
	chr_ModifyFavor("","Actor",FavorModify)
	-- raise need
	SatisfyNeed("",4,(-0.5))
	Sleep(2.0)
end

