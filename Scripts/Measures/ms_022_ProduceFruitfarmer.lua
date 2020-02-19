function GatherFruit()
	GetLocatorByName("WorkBuilding","Entry1","GehPos")
	f_MoveTo("","GehPos")
	SetState("", 54, true)
	StartProduction("","WorkBuilding")
	
	while true do
		Sleep(5)
		if not HasProperty("WorkBuilding","Active") or GetProperty("WorkBuilding","Active")~=1 then
			SetProperty("WorkBuilding","Active",1)
		end
		
	end
	return
end

function CleanUp()

	if GetState("",54) == true then
		SetState("", 54, false)
	end
	SimBeamMeUp("","GehPos",false)
	SetProperty("WorkBuilding","Active",0)
	SetData("fruitfarmer", 0)
	
	if AliasExists("WorkBuilding") and DynastyIsAI("WorkBuilding") then
		ms_022_gather_ReturnItems("", "WorkBuilding")
	end

end
