function Weight()
	
	if GetInsideBuildingID("SIM") == GetID("MyWorkshop") then
		return 0
	end
	
	if not AliasExists("MyWorkshop") then
		return 0
	end
	
	return 50
end

function Execute()
	f_MoveTo("", "MyWorkshop", GL_MOVESPEED_RUN)
	Sleep(2)
end


