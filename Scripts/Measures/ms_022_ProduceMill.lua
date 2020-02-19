function MehlMahlen()
	GetLocatorByName("WorkBuilding","Entry1","GehPos")
	f_MoveTo("","WorkBuilding")
	StartProduction("","WorkBuilding")
	SetState("", 54, true)
	SetProperty("WorkBuilding","Active",1)
	
	while true do
		
		PlaySound3D("WorkBuilding","Cart/CartRumbling_r_01.wav",1.0)
		Sleep(10)
		if not HasProperty("WorkBuilding","Active") or GetProperty("WorkBuilding","Active")~=1 then
		    SetProperty("WorkBuilding","Active",1)
		end
		
	end
	return --true
end

function CleanUp()

	if GetState("",54) == true then
		SetState("", 54, false)
	end
	SimBeamMeUp("","GehPos",false)
	SetProperty("WorkBuilding","Active",0)
	SetData("muehle", 0)
end
