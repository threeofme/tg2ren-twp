

function Run()
	GetInsideBuilding("","Dungeon")
	MoveSetStance("",GL_STANCE_CROUCH)
	while(true) do
		for i=1,2 do
			GetLocatorByName("Dungeon","Cell_Walk"..i,"StrollPos")
			f_MoveTo("","StrollPos",GL_MOVESPEED_SNEAK,50)
			Sleep(2)
		end
	end
end


