function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end	

	GetDynasty("","Dyna")
	GetDynasty("Destination","Dynb")
	if DynastyGetDiplomacyState("Dyna","Dynb") >= DIP_NAP then
		StopMeasure("")
	end
	
	f_MoveTo("","Destination",GL_MOVESPEED_WALK,200)

    MsgSayNoWait("","@L_MEASURE_POISONENEMY_TEXT")
	local trunke = PlayAnimationNoWait("","clink_glasses")
	Sleep(1)
	CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
	Sleep(trunke-1)
	if SimGetGender("") == 1 then
		PlaySound3DVariation("","CharacterFX/male_belch",1)
	else
		PlaySound3DVariation("","CharacterFX/female_belch",1)
	end
	CarryObject("","",false)
	Sleep(1)
	AddImpact("","totallydrunk",1,4)
	AddImpact("","MoveSpeed",0.7,4)
	SetState("",STATE_TOTALLYDRUNK,true)
	RemoveProperty("","GoToBePoisoned")
	StopMeasure()
	
end

function CleanUp()
    RemoveProperty("","GoToBePoisoned")
end
