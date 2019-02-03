function Weight()
	TotalFound = 0
	Count = DynastyGetWorkerCount("dynasty", GL_PROFESSION_MYRMIDON)
	for i=0,Count-1 do
		if DynastyGetWorker("dynasty", GL_PROFESSION_MYRMIDON, i, "CHECKME") then
			if GetState("CHECKME", STATE_IDLE) and SimIsWorkingTime("CHECKME") then
				CopyAlias("CHECKME", "MEMBER"..TotalFound )
				TotalFound = TotalFound + 1
			end
		end
	end
	
	if TotalFound==0 then
		return 0
	end
	
	return TotalFound*100
end

function Execute()
	random = Rand(TotalFound)
	if not CopyAlias("MEMBER"..random, "SIM") then
		return 0
	end
	
	name	= GetName("SIM")
	str		= "CheckMyrmidon: Selected "..name
	LogMessage(str);

	return 1
end
